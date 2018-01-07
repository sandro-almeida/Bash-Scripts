#Read the arguments
if [ $# -ne 2 ] 
then
    echo "Number of arguments required is 2"
    echo "Expected arguments: $0 <OriginDirectory> <NewFilePatternName>"
    exit 1
fi

TEMP_DIR=./temp
ORIGIN_DIR=$1
FILE_PATTERN=$2
I=0
echo "Origin directory is: [${ORIGIN_DIR}]"
echo "File pattern name is: [${FILE_PATTERN}]"

#Validate origin directory
if [ ! -d ${ORIGIN_DIR} ]
then
    echo "Origin directory does not exist! Please inform a valid directory name."
    exit 1
fi

#Create a temp dir
if [ ! -d ${TEMP_DIR} ] 
then
    mkdir ${TEMP_DIR}
fi

cd ${ORIGIN_DIR}
pwd

#List all files, except directories
ls -p | grep -v / > ${TEMP_DIR}/tempFiles.txt
NUMBER_OF_FILES=$(cat ${TEMP_DIR}/tempFiles.txt | wc -l)
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

    mv ${LINE} ${NEW_NAME}
    echo "${LINE} -> ${NEW_NAME}"

done < ${TEMP_DIR}/tempFiles.txt

rm ${TEMP_DIR}/tempFiles.txt
rmdir ${TEMP_DIR}
echo "Temp files and directory removed"

