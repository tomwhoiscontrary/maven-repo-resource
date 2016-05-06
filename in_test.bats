#! /usr/bin/env bats

ignoring_error() {
  "$@" 2>/dev/null
}

remove_whitespace() {
  echo "$1" | tr -d " \n"
}

@test "getting the default artifact" {
  MAVEN_REPO="$(mktemp -d)"
  OUTPUT_DIR="$(mktemp -d)"
  mkdir -p "$MAVEN_REPO/repo/g/r/o/u/p/artifact/1.10"
  echo "this is a jar" > "$MAVEN_REPO/repo/g/r/o/u/p/artifact/1.10/artifact-1.10.jar"

  run ignoring_error ./in "$OUTPUT_DIR" <<EOF
    {
      "source": {
        "repository":"file://$MAVEN_REPO/repo",
        "group":"g.r.o.u.p",
        "artifact":"artifact"
      },
      "version": { "version": "1.10" }
    }
EOF

  expected='{"version": {"version": "1.10"}}'

  echo "output=$output" >&2

  [[ $status -eq 0 ]]
  [[ "$(remove_whitespace "$output")" == "$(remove_whitespace "$expected")" ]]
  [[ -f "$OUTPUT_DIR/artifact-1.10.jar" ]]
  [[ "$(cat "$OUTPUT_DIR/artifact-1.10.jar")" == "this is a jar" ]]
}

@test "getting an artifact with a classifer" {
  MAVEN_REPO="$(mktemp -d)"
  OUTPUT_DIR="$(mktemp -d)"
  mkdir -p "$MAVEN_REPO/repo/g/r/o/u/p/artifact/1.10"
  echo "this is a source jar" > "$MAVEN_REPO/repo/g/r/o/u/p/artifact/1.10/artifact-1.10-sources.jar"

  run ignoring_error ./in "$OUTPUT_DIR" <<EOF
    {
      "source": {
        "repository":"file://$MAVEN_REPO/repo",
        "group":"g.r.o.u.p",
        "artifact":"artifact",
        "classifier":"sources"
      },
      "version": { "version": "1.10" }
    }
EOF

  expected='{"version": {"version": "1.10"}}'

  echo "output=$output" >&2

  [[ $status -eq 0 ]]
  [[ "$(remove_whitespace "$output")" == "$(remove_whitespace "$expected")" ]]
  [[ -f "$OUTPUT_DIR/artifact-1.10-sources.jar" ]]
  [[ "$(cat "$OUTPUT_DIR/artifact-1.10-sources.jar")" == "this is a source jar" ]]
}

@test "getting an artifact with specific packaging" {
  MAVEN_REPO="$(mktemp -d)"
  OUTPUT_DIR="$(mktemp -d)"
  mkdir -p "$MAVEN_REPO/repo/g/r/o/u/p/artifact/1.10"
  echo "this is a POM" > "$MAVEN_REPO/repo/g/r/o/u/p/artifact/1.10/artifact-1.10.pom"

  run ignoring_error ./in "$OUTPUT_DIR" <<EOF
    {
      "source": {
        "repository":"file://$MAVEN_REPO/repo",
        "group":"g.r.o.u.p",
        "artifact":"artifact",
        "packaging":"pom"
      },
      "version": { "version": "1.10" }
    }
EOF

  expected='{"version": {"version": "1.10"}}'

  echo "output=$output" >&2

  [[ $status -eq 0 ]]
  [[ "$(remove_whitespace "$output")" == "$(remove_whitespace "$expected")" ]]
  [[ -f "$OUTPUT_DIR/artifact-1.10.pom" ]]
  [[ "$(cat "$OUTPUT_DIR/artifact-1.10.pom")" == "this is a POM" ]]
}
