#!/bin/bash

set -e

gradleArgs=("clean" "test" "assemble")

for arg in "$@"; do
  case "$arg" in
    --skip-tests)
      echo "Skipping tests" >&2
      gradleArgs=("clean" "assemble")
      ;;
    --prod)
      echo "Building production package" >&2
      export FOR_ENVIRONMENT="production"
      ;;
    *)
      echo "Ignoring argument \"$arg\"" >&2
      ;;
  esac
done

./gradlew "${gradleArgs[@]}" && rm -rf ../gocd/server/plugins/external/ecs-elastic-agent-plugin-*.jar

mkdir -p ../gocd/server/plugins/external && \
  cp build/libs/ecs-elastic-agent-plugin-*.jar \
     ../gocd/server/plugins/external/
