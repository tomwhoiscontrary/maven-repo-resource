#! /usr/bin/env bats

ignoring_error() {
  "$@" 2>/dev/null
}

remove_whitespace() {
  echo "$1" | tr -d " \n"
}

@test "checking" {
  MAVEN_REPO="$(mktemp -d)"
  mkdir -p "$MAVEN_REPO/repo/g/r/o/u/p/artifact"
  cat >"$MAVEN_REPO/repo/g/r/o/u/p/artifact/maven-metadata.xml" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
    <metadata modelVersion="1.1.0">
      <groupId>ignored</groupId>
      <artifactId>ignored</artifactId>
      <versioning>
        <latest>ignored</latest>
        <release>ignored</release>
        <versions>
          <version>1.9</version>
          <version>1.10</version>
          <version>1.11</version>
        </versions>
        <lastUpdated>ignored</lastUpdated>
      </versioning>
    </metadata>
EOF

  run ignoring_error ./check <<EOF
    {
      "source": {
        "repository":"file://$MAVEN_REPO/repo",
        "group":"g.r.o.u.p",
        "artifact":"artifact"
      },
      "version": { "version": "1.10" }
    }
EOF

  expected='[{"version": "1.10"}, {"version": "1.11"}]'

  [[ $status -eq 0 ]]
  [[ "$(remove_whitespace "$output")" == "$(remove_whitespace "$expected")" ]]
}

@test "checking for the first time" {
  MAVEN_REPO="$(mktemp -d)"
  mkdir -p "$MAVEN_REPO/repo/g/r/o/u/p/artifact"
  cat >"$MAVEN_REPO/repo/g/r/o/u/p/artifact/maven-metadata.xml" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
    <metadata modelVersion="1.1.0">
      <groupId>ignored</groupId>
      <artifactId>ignored</artifactId>
      <versioning>
        <latest>ignored</latest>
        <release>ignored</release>
        <versions>
          <version>1.9</version>
          <version>1.10</version>
          <version>1.11</version>
        </versions>
        <lastUpdated>ignored</lastUpdated>
      </versioning>
    </metadata>
EOF

  run ignoring_error ./check <<EOF
    {
      "source": {
        "repository":"file://$MAVEN_REPO/repo",
        "group":"g.r.o.u.p",
        "artifact":"artifact"
      }
    }
EOF

  expected='[{"version": "1.11"}]'

  [[ $status -eq 0 ]]
  [[ "$(remove_whitespace "$output")" == "$(remove_whitespace "$expected")" ]]
}
