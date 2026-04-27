#!/usr/bin/env bash
# Generate Markdown documentation for all profiles.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
DOCS_DIR="$ROOT/docs"

yqr() {
  yq e "$1" "$2" | sed 's/^null$//'
}

# Convert lib.energy.battery.soc -> lib/energy/battery/soc.yml
dotpath_to_file() {
  local dotpath="$1"
  local rel="${dotpath#lib.}"
  echo "$ROOT/lib/${rel//\./\/}.yml"
}

# Convert lib.energy.battery.soc -> docs/lib/energy/battery/soc.md
dotpath_to_doc() {
  local dotpath="$1"
  local rel="${dotpath#lib.}"
  echo "$DOCS_DIR/lib/${rel//\./\/}.md"
}

# Compute relative path from $1 (doc file) to $2 (target file)
relpath() {
  python3 -c "import os,sys; print(os.path.relpath(sys.argv[2], os.path.dirname(sys.argv[1])))" "$1" "$2"
}

# Normalize multiline YAML strings to single line
normalize() {
  echo "$1" | tr '\n' ' ' | sed 's/  */ /g; s/^ *//; s/ *$//'
}

render_enum() {
  local lib_file="$1" field_key="$2" section="$3"
  echo ""
  echo "**Values:**"
  echo ""
  echo "| Value | Name | Description |"
  echo "|-------|------|-------------|"

  local keys
  keys="$(yqr ".${section}.${field_key}.enum | keys | .[]" "$lib_file")"
  for val in $keys; do
    local name desc
    name="$(yqr ".${section}.${field_key}.enum.${val}.display_name" "$lib_file")"
    desc="$(yqr ".${section}.${field_key}.enum.${val}.description" "$lib_file")"
    desc="$(normalize "$desc")"
    [[ -z "$name" ]] && name="$val"
    echo "| \`${val}\` | ${name} | ${desc} |"
  done
}

render_field() {
  local field_key="$1" section="$2" lib_file="$3" lib_dotpath="$4" doc_path="$5"
  local lib_doc rel
  lib_doc="$(dotpath_to_doc "$lib_dotpath")"
  rel="$(relpath "$doc_path" "$lib_doc")"

  local display_name type unit desc has_enum
  display_name="$(yqr ".${section}.${field_key}.display_name" "$lib_file")"
  type="$(yqr ".${section}.${field_key}.type" "$lib_file")"
  unit="$(yqr ".${section}.${field_key}.unit" "$lib_file")"
  desc="$(yqr ".${section}.${field_key}.description" "$lib_file")"
  desc="$(normalize "$desc")"
  has_enum="$(yqr ".${section}.${field_key} | has(\"enum\")" "$lib_file")"

  echo "### \`${field_key}\`"
  echo ""
  echo "- **Display name:** ${display_name}"
  echo "- **Type:** \`${type}\`"
  if [[ -n "$unit" ]]; then
    echo "- **Unit:** ${unit}"
  fi
  echo "- **Inherited from:** [\`${lib_dotpath}\`](${rel})"

  if [[ -n "$desc" ]]; then
    echo ""
    echo "$desc"
  fi

  if [[ "$has_enum" == "true" ]]; then
    render_enum "$lib_file" "$field_key" "$section"
  fi

  echo ""
}

generate_doc() {
  local profile_path="$1"
  local rel_profile="${profile_path#$ROOT/}"
  local doc_path="$DOCS_DIR/${rel_profile%.yml}.md"

  mkdir -p "$(dirname "$doc_path")"

  local display_name desc
  display_name="$(yqr '.display_name' "$profile_path")"
  desc="$(yqr '.description' "$profile_path")"
  desc="$(normalize "$desc")"

  {
    echo "# ${display_name}"
    echo ""
    if [[ -n "$desc" ]]; then
      echo "$desc"
      echo ""
    fi

    local has_properties=false has_telemetry=false
    local implements
    implements="$(yqr '.implements[]' "$profile_path" 2>/dev/null || true)"

    # First pass: check what sections exist
    for lib_dotpath in $implements; do
      local lib_file
      lib_file="$(dotpath_to_file "$lib_dotpath")"
      if [[ ! -f "$lib_file" ]]; then
        echo "WARNING: $lib_file not found" >&2
        continue
      fi
      local prop_keys tel_keys
      prop_keys="$(yqr '.properties | keys | .[]' "$lib_file" 2>/dev/null || true)"
      tel_keys="$(yqr '.telemetry | keys | .[]' "$lib_file" 2>/dev/null || true)"
      if [[ -n "$prop_keys" ]]; then has_properties=true; fi
      if [[ -n "$tel_keys" ]]; then has_telemetry=true; fi
    done

    if [[ "$has_properties" == "true" ]]; then
      echo "## Properties"
      echo ""
      for lib_dotpath in $implements; do
        local lib_file
        lib_file="$(dotpath_to_file "$lib_dotpath")"
        [[ -f "$lib_file" ]] || continue
        local keys
        keys="$(yqr '.properties | keys | .[]' "$lib_file" 2>/dev/null || true)"
        for key in $keys; do
          render_field "$key" "properties" "$lib_file" "$lib_dotpath" "$doc_path"
        done
      done
    fi

    if [[ "$has_telemetry" == "true" ]]; then
      echo "## Telemetry"
      echo ""
      for lib_dotpath in $implements; do
        local lib_file
        lib_file="$(dotpath_to_file "$lib_dotpath")"
        [[ -f "$lib_file" ]] || continue
        local keys
        keys="$(yqr '.telemetry | keys | .[]' "$lib_file" 2>/dev/null || true)"
        for key in $keys; do
          render_field "$key" "telemetry" "$lib_file" "$lib_dotpath" "$doc_path"
        done
      done
    fi
  } > "$doc_path"

  echo "  ${doc_path#$ROOT/}"
}

generate_lib_doc() {
  local lib_path="$1"
  local rel_lib="${lib_path#$ROOT/}"
  local doc_path="$DOCS_DIR/${rel_lib%.yml}.md"

  mkdir -p "$(dirname "$doc_path")"

  local display_name desc
  display_name="$(yqr '.display_name' "$lib_path")"
  desc="$(yqr '.description' "$lib_path")"
  desc="$(normalize "$desc")"

  {
    echo "# ${display_name}"
    echo ""
    if [[ -n "$desc" ]]; then
      echo "$desc"
      echo ""
    fi

    local prop_keys tel_keys
    prop_keys="$(yqr '.properties | keys | .[]' "$lib_path" 2>/dev/null || true)"
    tel_keys="$(yqr '.telemetry | keys | .[]' "$lib_path" 2>/dev/null || true)"

    if [[ -n "$prop_keys" ]]; then
      echo "## Properties"
      echo ""
      for key in $prop_keys; do
        local f_display_name f_type f_unit f_desc f_has_enum
        f_display_name="$(yqr ".properties.${key}.display_name" "$lib_path")"
        f_type="$(yqr ".properties.${key}.type" "$lib_path")"
        f_unit="$(yqr ".properties.${key}.unit" "$lib_path")"
        f_desc="$(yqr ".properties.${key}.description" "$lib_path")"
        f_desc="$(normalize "$f_desc")"
        f_has_enum="$(yqr ".properties.${key} | has(\"enum\")" "$lib_path")"

        echo "### \`${key}\`"
        echo ""
        echo "- **Display name:** ${f_display_name}"
        echo "- **Type:** \`${f_type}\`"
        if [[ -n "$f_unit" ]]; then
          echo "- **Unit:** ${f_unit}"
        fi
        if [[ -n "$f_desc" ]]; then
          echo ""
          echo "$f_desc"
        fi
        if [[ "$f_has_enum" == "true" ]]; then
          render_enum "$lib_path" "$key" "properties"
        fi
        echo ""
      done
    fi

    if [[ -n "$tel_keys" ]]; then
      echo "## Telemetry"
      echo ""
      for key in $tel_keys; do
        local f_display_name f_type f_unit f_desc f_has_enum
        f_display_name="$(yqr ".telemetry.${key}.display_name" "$lib_path")"
        f_type="$(yqr ".telemetry.${key}.type" "$lib_path")"
        f_unit="$(yqr ".telemetry.${key}.unit" "$lib_path")"
        f_desc="$(yqr ".telemetry.${key}.description" "$lib_path")"
        f_desc="$(normalize "$f_desc")"
        f_has_enum="$(yqr ".telemetry.${key} | has(\"enum\")" "$lib_path")"

        echo "### \`${key}\`"
        echo ""
        echo "- **Display name:** ${f_display_name}"
        echo "- **Type:** \`${f_type}\`"
        if [[ -n "$f_unit" ]]; then
          echo "- **Unit:** ${f_unit}"
        fi
        if [[ -n "$f_desc" ]]; then
          echo ""
          echo "$f_desc"
        fi
        if [[ "$f_has_enum" == "true" ]]; then
          render_enum "$lib_path" "$key" "telemetry"
        fi
        echo ""
      done
    fi
  } > "$doc_path"

  echo "  ${doc_path#$ROOT/}"
}

generate_index() {
  local index_path="$DOCS_DIR/index.md"
  {
    echo "# Profiles"
    echo ""

    for category in energy sensor; do
      echo "## ${category^}"
      echo ""
      find "$ROOT/$category" -name '*.yml' -print0 | sort -z | while IFS= read -r -d '' profile_path; do
        local display_name rel dotpath
        display_name="$(yqr '.display_name' "$profile_path")"
        rel="${category}/${profile_path#$ROOT/$category/}"
        rel="${rel%.yml}.md"
        dotpath="${rel%.md}"
        dotpath="${dotpath//\//.}"
        echo "- [${display_name}](${rel}) — \`${dotpath}\`"
      done
      echo ""
    done

    echo "## Lib"
    echo ""
    find "$ROOT/lib" -name '*.yml' -print0 | sort -z | while IFS= read -r -d '' lib_path; do
      local display_name rel dotpath
      display_name="$(yqr '.display_name' "$lib_path")"
      rel="lib/${lib_path#$ROOT/lib/}"
      rel="${rel%.yml}.md"
      dotpath="lib.${rel#lib/}"
      dotpath="${dotpath%.md}"
      dotpath="${dotpath//\//.}"
      echo "- [${display_name}](${rel}) — \`${dotpath}\`"
    done
    echo ""
  } > "$index_path"

  echo "  ${index_path#$ROOT/}"
}

# Clean and regenerate
rm -rf "$DOCS_DIR"

for lib_path in $(find "$ROOT/lib" -name '*.yml' | sort); do
  generate_lib_doc "$lib_path"
done

for profile_path in $(find "$ROOT/energy" "$ROOT/sensor" -name '*.yml' | sort); do
  generate_doc "$profile_path"
done

generate_index
