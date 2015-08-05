#!/bin/bash
# usage:<script>
# Daily Archive for FileServer
# kkostyuk - konstantin.kostuk@hp.com
#-----------------------------------------------------------------------------
WORK_DIR="/erm/iumbin/housekeeping"
LOG_DIR="dlog"

DAY_NUM="0"`date +%u -d "1 days ago"`
DAY_MASK=`date +%m-%d-%Y -d "1 days ago"`
CURRENT=`date +%Y%m%d_%H%M`

INSTANCES="MSK_CNT POV_URAL UG NW SIB_DV COMMON"

for inst in ${INSTANCES}
do
	LOG_NAME=${WORK_DIR}/${LOG_DIR}/${inst}_${DAY_NUM}_${CURRENT}.log
	echo "Started ..." > ${LOG_NAME}
	ARC_DIR="/erm/input/${inst}/archive/"

	for file in `find ${ARC_DIR} -mindepth 1 -xtype d|grep -vE "[0-9]{2}-[0-9]{2}-[0-9]{4}"`
	do
	DAY_PATH="/erm/raw_str_archive/${DAY_NUM}/${inst}/archive/${file/${ARC_DIR}/}"
	SRC_PATH="/erm/input/${inst}/archive/${file/${ARC_DIR}/}/${DAY_MASK}"

	if [ -d "${SRC_PATH}" ];
	  then
			echo "SOURCE="${SRC_PATH} >> ${LOG_NAME}
			echo "DESTINATION="${DAY_PATH} >> ${LOG_NAME}

			rsync -arvtz ${SRC_PATH} ${DAY_PATH} >> ${LOG_NAME}
#                       echo "Clear SOURCE" >> ${LOG_NAME}
#                       rm -fr ${SRC_PATH}
	  else
			echo "SOURCE ${SRC_PATH} not found" >> ${LOG_NAME}
	fi
	echo "Finished OK" >> ${LOG_NAME}
	done
done
