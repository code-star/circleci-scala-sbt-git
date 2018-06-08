# Scala, SBT and Git Dockerfile 

[Scala](http://www.scala-lang.org), [SBT](http://www.scala-sbt.org) and [Git](https://git-scm.com/) container.

This image can be build Scala projects on CircleCI v2, but is generic and not tied to CircleCI.

Using this image over [the default recommendation](https://circleci.com/blog/migrating-your-scala-sbt-schema-from-circleci-1-0-to-circleci-2-0/) has several advantages:

* Your config.xml remains small
* The correct version of Scala and SBT does not have to be downloaded/cached, it is contained within the container

## Base Docker Image ##

* [openjdk:8-jre-alpine](https://hub.docker.com/_/openjdk)


## Installation ##

1. Install [Docker](https://www.docker.com)
2. Pull [automated build](https://hub.docker.com/r/codestar/circleci-scala-sbt-git/) from public [Docker Hub Registry](https://hub.docker.com):
3. See [tags](https://hub.docker.com/r/codestar/circleci-scala-sbt-git/tags/) for built specific versions (not the latest ones)
```
docker pull codestar/circleci-scala-sbt-git
```
Alternatively, you can build an image from Dockerfile:
```
docker build -t circleci-scala-sbt-git github.com/codestar/circleci-scala-sbt-git
```
Or with specific versions:
```
docker build \
  -t circleci-scala-sbt-git \
  --build-arg SCALA_VERSION=2.12.6 \
  --build-arg SBT_VERSION=1.1.6 \
  github.com/code-star/circleci-scala-sbt-git
```

## Usage ##

```
docker run -it --rm codestar/circleci-scala-sbt-git /bin/bash
```

### Example .circleci/config.yml:

```
version: 2
jobs:
  build:
    working_directory: ~/my-project
    docker:
      - image: codestar/circleci-scala-sbt-git:scala-2.12.6-sbt-1.1.6
    steps:
      - checkout

      - restore_cache:
          keys:
            - my-project-{{ checksum "project/build.sbt" }}-{{ checksum "build.sbt" }}
            - my-project

      - run:
          command:
            sbt compile test:compile exit

      - save_cache:
          key: my-project-{{ checksum "project/build.sbt" }}-{{ checksum "build.sbt" }}
          paths:
            - target/resolution-cache
            - target/streams
            - project/target/resolution-cache
            - project/target/streams
            - ~/.sbt
            - ~/.iv2/cache
            - ~/.m2
      - save_cache:
          # Changing this to a different key is the only way to remove old dependencies from the cache and/or generate a more up-to-date cache
          key: my-project
          paths:
            - ~/.sbt
            - ~/.iv2/cache
            - ~/.m2

      - run:
          command:
            sbt test exit

      - store_test_results:
          path: target/test-reports
```


## Contribution policy ##

Contributions via GitHub pull requests are gladly accepted from their original author. Along with any pull requests, please state that the contribution is your original work and that you license the work to the project under the project's open source license. Whether or not you state this explicitly, by submitting any copyrighted material via pull request, email, or other means you agree to license the material under the project's open source license and warrant that you have the legal authority to do so.


## License ##

This code is open source software licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

This fork is based on [spikerlabs/scala-sbt](https://github.com/spikerlabs/scala-sbt) and [hseeberger/scala-sbt](https://github.com/hseeberger/scala-sbt).
