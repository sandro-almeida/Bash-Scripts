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

#TODO
#> Turn the third argument functional
#> Compare origin and destination after the backup and print a message

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
TEMP_DIR=temp-${NOW}
TEMP_FILE=${NOW}-tempFile.txt

#Create a temp directory at the destination
cd ${DESTINATION_DIR}
pwd
DESTINATION_ABS_DIR=$PWD

if [ ! -d ./${TEMP_DIR} ] 
then
    mkdir ${TEMP_DIR}
    cd ${TEMP_DIR}
    TEMP_ABS_DIR=$PWD
else
    echo "Temporary destination directory ${TEMP_DIR} has to be created but it already exists. Please try again in a minute."
    exit 1
fi

#List all files and folders from origin
cd ${ORIGIN_DIR}
pwd

find -mindepth 1 -type d > ${TEMP_ABS_DIR}/${TEMP_FILE}
find -type f >> ${TEMP_ABS_DIR}/${TEMP_FILE}


#Backup files
while read LINE
do 
    #Remove the first two characters if they match './'
    if [ ${LINE:0:2} == "./" ]
    then
        LINE_CONTENT=${LINE:2}
    else
    	LINE_CONTENT=${LINE}
    fi

    #Create directory at destination in case it does not exist
    if [ -d ${LINE} ]
    then
        if [ ! -d ${DESTINATION_ABS_DIR}/${LINE_CONTENT} ]
        then
            mkdir ${DESTINATION_ABS_DIR}/${LINE_CONTENT}
            echo "New directory [${LINE_CONTENT}] created at destination."
        fi
    else
    	#Compare files on origin and destination
    	if [ ! -f ${DESTINATION_ABS_DIR}/${LINE_CONTENT} ]
    	then
    	    #Copy new file to destination
            cp -p ${LINE} ${DESTINATION_ABS_DIR}/${LINE_CONTENT%/*}
            echo "New file [${LINE_CONTENT}] created at destination."
        else
        	if [ -f ${DESTINATION_ABS_DIR}/${LINE_CONTENT} ]
        	then
        	    if [ $(stat -c %Y ${LINE}) != $(stat -c %Y ${DESTINATION_ABS_DIR}/${LINE_CONTENT}) ]
        	    then
        	        cp -fp ${LINE} ${DESTINATION_ABS_DIR}/${LINE_CONTENT%/*}
                    echo "Existing file [${LINE_CONTENT}] updated at destination."
                fi
            fi
        fi
    fi
done < ${TEMP_ABS_DIR}/${TEMP_FILE}

rm ${DESTINATION_ABS_DIR}/${TEMP_DIR}/${TEMP_FILE}
rmdir ${DESTINATION_ABS_DIR}/${TEMP_DIR}
echo "Temp file and directory removed"
