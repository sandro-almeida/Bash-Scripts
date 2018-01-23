###############################################################################
# renameFiles.sh
# Purpose: rename all files from a folder using a new pattern name. A number
#          starting from 1 will be used as a suffix for the renamed files.
#
# Usage: $0 '<OriginDirectory>' <NewFilePatternName> <ApplyChanges>
# 
# Arguments:
#  <OriginDirectory>: name of the folder where the files will be renamed.
#  <NewFilePatternName>: new pattern name to be applied to the files.
#  <ApplyChanges>: if set to 'Y', then the changes will be applied, otherwise
#     only indicates the changes to be made but not apply them.
###############################################################################

echo "Starting script ${0} at $(date +'%Y-%m-%d %H:%M:%S.%3N')"

#Read the arguments
if [ $# -ne 3 ] 
then
    echo "Number of arguments required is 3"
    echo "Usage: $0 '<OriginDirectory>' <NewFilePatternName> <ApplyChanges>"
    exit 1
fi

ORIGIN_DIR=$1
FILE_PATTERN=$2
APPLY_CHANGES=$3

NOW=$(date +'%Y%m%d%H%M')
TEMP_DIR=./temp-${NOW}
TEMP_FILE=${NOW}-tempFile.txt

I=0
echo "Origin directory is: [${ORIGIN_DIR}]"
echo "File pattern name is: [${FILE_PATTERN}]"
echo "Apply changes? [${APPLY_CHANGES}]"

#Validate origin directory
if [ ! -d ${ORIGIN_DIR} ]
then
    echo "Origin directory does not exist! Please inform a valid directory name."
    exit 1
fi

cd ${ORIGIN_DIR}
pwd

#Create a temp dir
if [ ! -d ${TEMP_DIR} ] 
then
    mkdir ${TEMP_DIR}
else
    echo "Temporary directory ${TEMP_DIR} has to be created but it already exists. Please try again in a minute."
    exit 1
fi

#List all files, except directories
ls -p | grep -v / > ${TEMP_DIR}/${TEMP_FILE}
NUMBER_OF_FILES=$(cat ${TEMP_DIR}/${TEMP_FILE} | wc -l)
SUFFIX_LENGTH=${#NUMBER_OF_FILES}
echo "Number of files listed is [${NUMBER_OF_FILES}]"
echo "Suffix length is [${SUFFIX_LENGTH}]"


#Rename the files
while read LINE
do 
    #Count the number of characters of the file name
    #echo -n $LINE | wc -c
    #echo ${#LINE}

    EXTENSION=${LINE##*.}
    I=$(($I+1))
    SUFFIX=$(printf "%0${SUFFIX_LENGTH}.0f" ${I})
    NEW_NAME=${FILE_PATTERN}${SUFFIX}.${EXTENSION}

    if [ ${APPLY_CHANGES} == "Y" ]
    then
        mv ${LINE} ${NEW_NAME}
    fi
    echo "${LINE} -> ${NEW_NAME}"

done < ${TEMP_DIR}/${TEMP_FILE}

if [ ${APPLY_CHANGES} != "Y" ]
then
    echo "Changes NOT applied !!!"
fi

rm ${TEMP_DIR}/${TEMP_FILE}
rmdir ${TEMP_DIR}
echo "Temp files and directory removed"

echo "Finishing script ${0} at $(date +'%Y-%m-%d %H:%M:%S.%3N')"
exit 0
