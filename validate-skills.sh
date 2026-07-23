#!/bin/bash

# Validates skills against the Agent Skills specification.
# Reference: https://agentskills.io/specification.md
#
# Spec-defined frontmatter (only these top-level fields are allowed):
#   name          (required) 1-64 chars, [a-z0-9-], no leading/trailing/consecutive hyphens, must match dir name
#   description   (required) 1-1024 chars, non-empty
#   license       (optional) any license name or reference
#   compatibility (optional) 1-500 chars
#   metadata      (optional) map of string -> string
#   allowed-tools (optional) space-separated STRING (not a YAML list)
#
# Also enforced: SKILL.md must start with YAML frontmatter; body <500 lines recommended.

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SKILLS_DIR="."
ISSUES=0
WARNINGS=0
PASSED=0

# Fields the spec allows at the top level of the frontmatter.
ALLOWED_FIELDS="name description license compatibility metadata allowed-tools"

echo "🔍 Auditing Skills Against Agent Skills Specification"
echo "======================================================"
echo ""
echo "Reference: https://agentskills.io/specification.md"
echo ""

for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="${skill_dir}SKILL.md"
    skill_errors=()
    skill_warnings=()

    # Skip directories that aren't skills (no SKILL.md), e.g. assets/
    [[ -f "$skill_file" ]] || continue

    # ===== FRONTMATTER EXTRACTION =====
    # Frontmatter MUST be the first thing in the file, delimited by --- ... ---
    first_line=$(head -1 "$skill_file")
    if [[ "$first_line" != "---" ]]; then
        echo -e "${RED}❌ $skill_name${NC}"
        echo -e "   ${RED}Error:${NC} File must start with YAML frontmatter ('---' on line 1)"
        ((ISSUES++))
        continue
    fi

    # Everything between the first '---' and the next '---'
    frontmatter=$(awk 'NR==1 && /^---[[:space:]]*$/{f=1; next} f && /^---[[:space:]]*$/{done=1; exit} f{print} END{if(!done) exit 3}' "$skill_file")
    if [[ $? -eq 3 ]]; then
        echo -e "${RED}❌ $skill_name${NC}"
        echo -e "   ${RED}Error:${NC} Frontmatter is not closed with a second '---'"
        ((ISSUES++))
        continue
    fi

    # Top-level keys = frontmatter lines that start at column 0 with "key:"
    top_keys=$(echo "$frontmatter" | grep -oE '^[A-Za-z][A-Za-z0-9_-]*:' | sed 's/:$//')

    # ===== UNKNOWN TOP-LEVEL FIELDS =====
    # Anything outside the spec's field set risks breaking strict parsers on other agents.
    while IFS= read -r key; do
        [[ -z "$key" ]] && continue
        if ! echo " $ALLOWED_FIELDS " | grep -q " $key "; then
            skill_errors+=("Unknown top-level field '$key' (not in spec; move custom data under 'metadata:')")
        fi
    done <<< "$top_keys"

    # ===== NAME VALIDATION =====
    name_in_file=$(echo "$frontmatter" | grep -E '^name:' | head -1 | sed -E 's/^name:[[:space:]]*//' | sed -E 's/[[:space:]]*$//' | sed -E 's/^"(.*)"$/\1/;s/^'"'"'(.*)'"'"'$/\1/')

    if ! echo "$top_keys" | grep -qx "name"; then
        skill_errors+=("Missing required 'name' field")
    elif [[ -z "$name_in_file" ]]; then
        skill_errors+=("'name' is empty")
    else
        if [[ "$name_in_file" != "$skill_name" ]]; then
            skill_errors+=("Name mismatch: directory='$skill_name' but frontmatter='$name_in_file'")
        fi
        if [[ ${#name_in_file} -gt 64 ]]; then
            skill_errors+=("Name too long: ${#name_in_file} chars (max 64)")
        fi
        # a-z0-9, hyphen-separated, no leading/trailing/consecutive hyphens
        if ! [[ "$name_in_file" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
            skill_errors+=("Invalid name '$name_in_file' (lowercase a-z/0-9/hyphens only; no leading, trailing, or consecutive hyphens)")
        fi
    fi

    # ===== DESCRIPTION VALIDATION =====
    description=$(echo "$frontmatter" | grep -E '^description:' | head -1 | sed -E 's/^description:[[:space:]]*//' | sed -E 's/[[:space:]]*$//' | sed -E 's/^"(.*)"$/\1/;s/^'"'"'(.*)'"'"'$/\1/')

    if ! echo "$top_keys" | grep -qx "description"; then
        skill_errors+=("Missing required 'description' field")
    elif [[ -z "$description" ]]; then
        skill_errors+=("'description' is empty (must be 1-1024 chars)")
    else
        desc_len=${#description}
        if [[ $desc_len -gt 1024 ]]; then
            skill_errors+=("Description too long: $desc_len chars (max 1024)")
        fi
    fi

    # ===== COMPATIBILITY VALIDATION =====
    if echo "$top_keys" | grep -qx "compatibility"; then
        compatibility=$(echo "$frontmatter" | grep -E '^compatibility:' | head -1 | sed -E 's/^compatibility:[[:space:]]*//' | sed -E 's/[[:space:]]*$//' | sed -E 's/^"(.*)"$/\1/;s/^'"'"'(.*)'"'"'$/\1/')
        if [[ -z "$compatibility" ]]; then
            skill_errors+=("'compatibility' is present but empty (must be 1-500 chars)")
        elif [[ ${#compatibility} -gt 500 ]]; then
            skill_errors+=("Compatibility too long: ${#compatibility} chars (max 500)")
        fi
    fi

    # ===== LICENSE VALIDATION =====
    # Spec allows ANY license name or reference; only flag an empty value.
    if echo "$top_keys" | grep -qx "license"; then
        license=$(echo "$frontmatter" | grep -E '^license:' | head -1 | sed -E 's/^license:[[:space:]]*//' | sed -E 's/[[:space:]]*$//')
        if [[ -z "$license" ]]; then
            skill_warnings+=("'license' is present but empty")
        fi
    fi

    # ===== ALLOWED-TOOLS VALIDATION =====
    # Must be a space-separated STRING on the same line, not a YAML block/list.
    if echo "$top_keys" | grep -qx "allowed-tools"; then
        at_value=$(echo "$frontmatter" | grep -E '^allowed-tools:' | head -1 | sed -E 's/^allowed-tools:[[:space:]]*//' | sed -E 's/[[:space:]]*$//')
        if [[ -z "$at_value" ]]; then
            skill_errors+=("'allowed-tools' must be an inline space-separated string, not a YAML list/block")
        fi
    fi

    # ===== METADATA VALIDATION =====
    # metadata is a map of string -> string. Flag unquoted numeric values (they parse as numbers, not strings).
    if echo "$top_keys" | grep -qx "metadata"; then
        # Lines indented under metadata, until the next top-level key
        meta_block=$(echo "$frontmatter" | awk '/^metadata:/{m=1; next} m && /^[A-Za-z]/{m=0} m{print}')
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            val=$(echo "$line" | sed -E 's/^[[:space:]]*[^:]+:[[:space:]]*//')
            if [[ "$val" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                mkey=$(echo "$line" | sed -E 's/^[[:space:]]*([^:]+):.*/\1/')
                skill_warnings+=("metadata.$mkey='$val' is unquoted numeric (metadata values should be strings, e.g. \"$val\")")
            fi
        done <<< "$meta_block"
    fi

    # ===== FILE STRUCTURE VALIDATION =====
    line_count=$(wc -l < "$skill_file")
    if [[ $line_count -gt 500 ]]; then
        skill_warnings+=("SKILL.md is $line_count lines (spec recommends <500; move detail into references/)")
    fi

    # ===== REPORT RESULTS =====
    if [[ ${#skill_errors[@]} -gt 0 ]]; then
        echo -e "${RED}❌ $skill_name${NC}"
        for error in "${skill_errors[@]}"; do
            echo -e "   ${RED}Error:${NC} $error"
        done
        for warning in "${skill_warnings[@]}"; do
            echo -e "   ${YELLOW}Warning:${NC} $warning"
        done
        ((ISSUES++))
    elif [[ ${#skill_warnings[@]} -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  $skill_name${NC}"
        for warning in "${skill_warnings[@]}"; do
            echo -e "   ${YELLOW}Warning:${NC} $warning"
        done
        ((WARNINGS++))
    else
        echo -e "${GREEN}✓ $skill_name${NC}"
        ((PASSED++))
    fi
done

echo ""
echo "======================================================"
echo "Summary:"
echo -e "  ${GREEN}✓ Passed: $PASSED${NC}"
if [[ $WARNINGS -gt 0 ]]; then
    echo -e "  ${YELLOW}⚠️  Warnings: $WARNINGS${NC}"
fi
if [[ $ISSUES -gt 0 ]]; then
    echo -e "  ${RED}❌ Issues: $ISSUES${NC}"
fi
echo ""

if [[ $ISSUES -eq 0 ]]; then
    echo -e "${GREEN}All skills are spec-compliant! ✓${NC}"
    exit 0
else
    echo -e "${RED}Found $ISSUES skill(s) with spec violations.${NC}"
    exit 1
fi
