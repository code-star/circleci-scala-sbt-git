#!/usr/bin/env bash
scala_versions=(
  2.11.12
  2.12.8
  2.13.0-M5
)
sbt_versions=(
  0.13.18
  1.1.6
  1.2.8
)

for scala_version in ${scala_versions[@]}; do
  for sbt_version in ${sbt_versions[@]}; do
    version=scala-${scala_version}-sbt-${sbt_version}
    docker build \
      -t codestar/circleci-scala-sbt-git:${version} \
      --build-arg SCALA_VERSION=${scala_version} \
      --build-arg SBT_VERSION=${sbt_version} \
      .
    docker push codestar/circleci-scala-sbt-git:${version}
    echo "Built ${version}"
  done
done
