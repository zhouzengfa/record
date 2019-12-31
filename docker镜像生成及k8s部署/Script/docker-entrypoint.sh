#!/bin/bash
HOME="/interface"
CONF="${HOME}/resource"
echo "${CONF}"

APP_PRO="${CONF}/apollo-${APOLLO_ENV}.properties"
echo "${APP_PRO}"

sed -i "s#apollo.cluster.*#apollo.cluster=${APOLLO_CLUSTER}#g;s#meta.*#meta=${APOLLO_META}#g;s/zk.address.*/zk.address=${ZK_ADDRESS}/g" ${APP_PRO}
if [ -z "${ZK_NODE_PATH}" ];then
   sed -i 's/nodePath.*//g' ${APP_PRO}
   echo -e "clear nodePath\n"
else
   if grep "nodePath" ${APP_PRO}; then
      sed -i 's/nodePath.*//g' ${APP_PRO}
      echo -e "nodePath exist! clean first\n"
   fi
   echo -e "\nnodePath=${ZK_NODE_PATH}" >> ${APP_PRO}
   echo -e "nodePath reset\n"
fi
cat ${APP_PRO}
cd ${HOME}/bin/
python InterfaceServer.py start

if [ "true" = "${TRACE_LOG}" ];then
		sleep 2s
        tail -f ../../log/*/*.log
fi

