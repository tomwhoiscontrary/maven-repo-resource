Tracks the versions of a particular artifact in a Maven repository.

## Source Configuration

* `repository` *(required)*: the base URL of the repository
* `group` *(required)*: the group of the artifact
* `artifact` *(required)*: the name of the artifact
* `classifier` *(defaults to none)*: the classifier of the artifact
* `packaging` *(defaults to `jar`)*: the packaging of the artifact

### Example

Resource configuration:

```
resources:
  - name: spring-core-jar
    type: maven
    source:
    repository: https://repo1.maven.org/maven2
      group: org.springframework
      artifact: spring-core
```

## Behaviour

### check: Check for new versions

The set of available versions is obtained from the Maven metadata, and versions from the given version on are returned. If no version is given, the latest version is returned. It is assumed that the versions are in order in the metadata file.

### in: Download a new version

The specified artifact is downloaded from the repository to the destination directory.

### out: Do nothing

We hope to have the out script publish a new version to the repository, but this is tricky.
