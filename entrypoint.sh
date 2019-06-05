#!/bin/sh

if [ ${SERVICE_TYPE} == "controller" ] ; then
./start-controller.sh \
          -port ${PORT:-9000} \
          -zookeeper ${ZK_CONNECT} \
          -helixClusterName ${HELIX_CL_NAME:-devMirrorMaker} \
          -backUpToGit ${BACKUP_GIT:-false} \
          -autoRebalanceDelayInSeconds ${AUTOREBALANCE_DELAY_SEC:-120} \
          -localBackupFilePath ${BACKUP_PATH:-/tmp/uReplicator} \
          -enableAutoWhitelist ${ENABLE_AUTOWHITELIST:-true} \
          -enableAutoTopicExpansion ${AUTO_TOPIC_EXPANSION:-true} \
          -srcKafkaZkPath ${SRC_ZK_CONNECT} \
          -destKafkaZkPath ${DST_ZK_CONNECT} \
          -initWaitTimeInSeconds ${INIT_WAIT_SEC:-10} \
          -refreshTimeInSeconds ${REFRESH_SEC:-20} \
          -env ${ENV_NAME:-k8.testing} ${@}

elif [ ${SERVICE_TYPE} == "worker" ] ; then
./start-worker.sh \
          --helix.config config/helix.properties \
          --consumer.config config/consumer.properties \
          --producer.config config/producer.properties
fi
