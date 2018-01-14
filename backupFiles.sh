###############################################################################
# backupFiles.sh
# Purpose: backup files and folders from origin to destination. Only either
#          new files or changed ones are moved.
#
# Usage: $0 '<OriginDirectory>' '<DestinationDirectory>' <ApplyIt>
# 
# Arguments:
#  <OriginDirectory>: name of the origin folder FROM where the files will be
#     copied.
#  <DestinationDirectory>: name of the destination folder TO where the files
#     will be backed-up.
#  <ApplyIt>: if set to 'S', then the backup will be applied, otherwise
#     only indicates the backup to be made but not apply them.
###############################################################################

#Read the arguments
if [ $# -ne 3 ] 
then
    echo "Number of arguments required is 3"
    echo "Usage: $0 '<OriginDirectory>' '<DestinationDirectory>' <ApplyIt>"
    exit 1
fi

ORIGIN_DIR=$1
DESTINATION_DIR=$2
APPLY_IT=$3

echo "Origin directory is: [${ORIGIN_DIR}]"
echo "Destination directory is: [${DESTINATION_DIR}]"
echo "Apply it? [${APPLY_IT}]"

#Validate origin directory
if [ ! -d ${ORIGIN_DIR} ]
then
    echo "Origin directory does not exist! Please inform a valid directory name."
    exit 1
fi

#Validate destination directory
if [ ! -d ${DESTINATION_DIR} ]
then
    echo "Destination directory does not exist! Please inform a valid directory name."
    exit 1
fi

NOW=$(date +'%Y%m%d%H%M')
TEMP_FROM_DIR=./temp-${NOW}
TEMP_FROM_FILE=${NOW}-tempFile.txt

#List all files and folders from origin
cd ${ORIGIN_DIR}
pwd

#Create a temp FROM dir
if [ ! -d ${TEMP_FROM_DIR} ] 
then
    mkdir ${TEMP_FROM_DIR}
else
    echo "Temporary FROM directory ${TEMP_FROM_DIR} has to be created but it already exists. Please try again in a minute."
    exit 1
fi

find -mindepth 1 -type d > ${TEMP_FROM_DIR}/${TEMP_FROM_FILE}

#TODO: continue

