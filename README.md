# mirror-maker

A mirror-maker container based on [bitnami/kafka](https://hub.docker.com/r/bitnami/kafka/) and
 [srotya/docker-kafka-mirror-maker](https://github.com/srotya/docker-kafka-mirror-maker). Now uses
 [MirrorMaker 2](https://cwiki.apache.org/confluence/display/KAFKA/KIP-382%3A+MirrorMaker+2.0)

### Build
This image is available from Docker hub however, if you would like to build it yourself here are the steps:

```
cat > commands.sh << 'EOF'
git clone https://github.com/Sfaynet/mirror-maker.git && /
cd mirror-maker && /
git pull && /
docker build -t mirror-maker:2.8.0-debian-10-r68 . && /
EOF
bash commands.sh

```

**Note: Docker is expected to be installed where you run the build**

### Environment Variables
|    Variable Name    |                   Description                |   Default |
|---------------------|----------------------------------------------|------------|
|      SOURCE         | bootstrap.servers for the source kafka       |source-cluster:9092|
|    DESTINATION      | bootstrap.servers for the destination kafka  |localhost:9092|
|     TOPICS          | Topics to mirror     | .* |

#### Docker usage
```

export S_KAFKA_CLUSTER_DESTINATION=destination1:9092,destination2:9092 &&
export S_KAFKA_CLUSTER_SOURCE=source1:9092 &&
export S_GROUP_ID=s_test &&
export S_KAFKA_HEAP_OPTS="-Xms256m -Xmx256m" &&
export S_NAME_SOURCE=A &&
export S_NAME_DESTINATION=B &&
export S_CLIENT_ID=1 &&
export S_TOPICS=s_test &&
export S_SCHEDULED_REBALANCE_MAX_DELAY_MS=15000 &&
export S_EMIT_CHECKPOINTS_INTERVAL_SECONDS=3 &&
export S_SYNC_GROUP_OFFSET_ENABLED=true &&
export S_ALLOW_PLAINTEXT_LISTENER=yes &&

docker run -d --rm -e EMIT_CHECKPOINTS_INTERVAL_SECONDS=$S_EMIT_CHECKPOINTS_INTERVAL_SECONDS -e SCHEDULED_REBALANCE_MAX_DELAY_MS=$S_SCHEDULED_REBALANCE_MAX_DELAY_MS -e KAFKA_HEAP_OPTS="$S_KAFKA_HEAP_OPTS" -e ALLOW_PLAINTEXT_LISTENER=$S_ALLOW_PLAINTEXT_LISTENER -e SYNC_GROUP_OFFSET_ENABLED=$S_SYNC_GROUP_OFFSET_ENABLED -e GROUP_ID=$S_GROUP_ID -e CLIENT_ID=$S_CLIENT_ID -e DESTINATION=$S_KAFKA_CLUSTER_DESTINATION -e SOURCE=$S_KAFKA_CLUSTER_SOURCE -e NAME_SOURCE=$S_NAME_SOURCE -e NAME_DESTINATION=$S_NAME_DESTINATION -e TOPICS=$S_TOPICS --name mirror_maker2_"$S_GROUP_ID"_"$S_CLIENT_ID" mirror-maker:2.8.0-debian-10-r68

export S_CLIENT_ID=2 &&

docker run -d --rm -e EMIT_CHECKPOINTS_INTERVAL_SECONDS=$S_EMIT_CHECKPOINTS_INTERVAL_SECONDS -e SCHEDULED_REBALANCE_MAX_DELAY_MS=$S_SCHEDULED_REBALANCE_MAX_DELAY_MS -e KAFKA_HEAP_OPTS="$S_KAFKA_HEAP_OPTS" -e ALLOW_PLAINTEXT_LISTENER=$S_ALLOW_PLAINTEXT_LISTENER -e SYNC_GROUP_OFFSET_ENABLED=$S_SYNC_GROUP_OFFSET_ENABLED -e GROUP_ID=$S_GROUP_ID -e CLIENT_ID=$S_CLIENT_ID -e DESTINATION=$S_KAFKA_CLUSTER_DESTINATION -e SOURCE=$S_KAFKA_CLUSTER_SOURCE -e NAME_SOURCE=$S_NAME_SOURCE -e NAME_DESTINATION=$S_NAME_DESTINATION -e TOPICS=$S_TOPICS --name mirror_maker2_"$S_GROUP_ID"_"$S_CLIENT_ID" mirror-maker:2.8.0-debian-10-r68

```

#### Docker-compose usage

```
version: '2'

services:
  zookeeper:
    image: 'bitnami/zookeeper:3'
    ports:
      - '2181:2181'
    volumes:
      - 'zookeeper_data:/bitnami'
    environment:
      - ALLOW_ANONYMOUS_LOGIN=yes
  kafka:
    image: 'bitnami/kafka:2'
    ports:
      - '9092:9092'
    volumes:
      - 'kafka_data:/bitnami'
    environment:
      - KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181
      - ALLOW_PLAINTEXT_LISTENER=yes
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092
    depends_on:
      - zookeeper
  mirrormaker:
    image: 'wpietri/mirror-maker:2'
    depends_on:
      - kafka
    environment:
      - SOURCE=mysourcekafka.example.com:9092
      - DESTINATION=kafka:9092
      - TOPICS=Topic1,Topic2


volumes:
  zookeeper_data:
    driver: local
  kafka_data:
    driver: local

```

### License

Apache 2.0
