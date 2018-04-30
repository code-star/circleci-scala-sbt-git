#
# Scala and sbt Dockerfile
#
# https://github.com/code-star/circleci-scala-sbt-git (based on https://github.com/spikerlabs/scala-sbt)
#

# Pull base image
FROM  openjdk:8-jdk-alpine

ARG SCALA_VERSION
ARG SBT_VERSION

ENV SCALA_VERSION ${SCALA_VERSION:-2.12.6}
ENV SBT_VERSION ${SBT_VERSION:-1.1.4}

RUN \
  echo "building docker image for scala $SCALA_VERSION sbt $SBT_VERSION"

RUN \
  echo "Setting up JDK and base system" && \
  mkdir -p /usr/lib/jvm/java-1.8-openjdk/jre && \
  touch /usr/lib/jvm/java-1.8-openjdk/jre/release && \
  apk add --no-cache bash && \
  apk add --no-cache curl && \
  apk add --no-cache git && \
  apk add --no-cache openssh-client

RUN \
  echo "Downloading and setting up Scala $SCALA_VERSION" && \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /usr/local && \
  ln -s /usr/local/scala-$SCALA_VERSION/bin/* /usr/local/bin/ && \
  scala -version && \
  scalac -version

RUN \
  echo "Downloading and setting up SBT ${SBT_VERSION}" && \
  SBT_URL="https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz" && \
  curl -fsL $SBT_URL | tar xfz - -C /usr/local && \
  $(mv /usr/local/sbt-launcher-packaging-$SBT_VERSION /usr/local/sbt || true) \
  ln -s /usr/local/sbt/bin/* /usr/local/bin/ && \
  sbt sbtVersion
