#
# Copyright (C) 2015-2019 Uber Technologies, Inc. (streaming-data@uber.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM maven:3.5-jdk-8 as builder

RUN apt-get update && \
apt-get install -y netcat

ARG MAVEN_OPTS="-Xmx1024M -Xss128M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=1024M -XX:+CMSClassUnloadingEnabled"
COPY . /usr/src/app
WORKDIR /usr/src/app

RUN mvn clean package -DskipTests

FROM openjdk:8-jre-alpine

RUN apk --update add bash libstdc++ bind-tools && \
    rm -rf /tmp/* /var/cache/apk/*

COPY --from=builder /usr/src/app/uReplicator-Distribution/target/uReplicator-Distribution-pkg /uReplicator
COPY entrypoint.sh /uReplicator/bin/entrypoint.sh

WORKDIR /uReplicator/bin

RUN chmod +x /uReplicator/bin/entrypoint.sh && \
    chmod +x /uReplicator/bin/*.sh

ENTRYPOINT [ "./entrypoint.sh" ]