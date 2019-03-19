# DEPRECATED: Use [circleci/openjdk](https://circleci.com/docs/2.0/circleci-images/#openjdk) image

This docker image has become superfluous, CircleCI is now publishing an image with SBT included

Example `config.yml` file for Scala and SBT development:

```
version: 2.1
jobs:
  build:
    working_directory: ~/app
    docker:
      - image: circleci/openjdk:8
    steps:
      - checkout

      - restore_cache:
          keys:
            - app-cache-{{ checksum "build.sbt" }}
            - app-cache-v1

      - run:
          command:
            sbt compile test:compile exit

      - save_cache:
          key: app-cache-{{ checksum "build.sbt" }}
          paths:
            - target/resolution-cache
            - target/streams
            - project/target/resolution-cache
            - project/target/streams
            - ~/.sbt
            - ~/.ivy2/cache
      - save_cache:
          # Change this key to start the next build with a fully clean cache and forget old scala, sbt and library versions
          key: app-cache-v1
          paths:
            - ~/.sbt
            - ~/.ivy2/cache

      - run:
          command:
            sbt test exit

      - store_test_results:
          path: target/test-reports
```
