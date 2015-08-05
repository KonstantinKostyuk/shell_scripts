#!/bin/bash
# usage:<script> <Source Path>  
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
	LOG_NAME=${inst}_${DAY_NUM}_${CURRENT}.log
	echo "Started ..." > ${WORK_DIR}/${LOG_DIR}/${LOG_NAME}
	for l_one in `ls /erm/input/${inst}/archive`
	do
		for l_two in `ls /erm/input/${inst}/archive/$l_one`
		do
			DAY_PATH="/erm/raw_str_archive/${DAY_NUM}/${inst}/archive/${l_one}/${l_two}"
			SRC_PATH="/erm/input/${inst}/archive/${l_one}/${l_two}/${DAY_MASK}"
			echo "SOURCE="${SRC_PATH} >> ${WORK_DIR}/${LOG_DIR}/${LOG_NAME}
			echo "DESTINATION="${DAY_PATH} >> ${WORK_DIR}/${LOG_DIR}/${LOG_NAME}
			if [ -d "${SRC_PATH}" ];
			then
				rsync -arvtz ${SRC_PATH} ${DAY_PATH} >> ${WORK_DIR}/${LOG_DIR}/${LOG_NAME}
#				echo "Clear SOURCE" >> ${WORK_DIR}/${LOG_DIR}/${LOG_NAME}
#				rm -fr ${SRC_PATH}
			else
				echo "SOURCE not found" >> ${WORK_DIR}/${LOG_DIR}/${LOG_NAME}
			fi
				echo "Finished OK" >> ${WORK_DIR}/${LOG_DIR}/${LOG_NAME}
		done
	done
done
