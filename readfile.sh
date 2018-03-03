#!/bin/sh
file="/data/web/leetcode/shell/195/file.txt"

function read_file() {
	cat $file | while read line;
	do
		echo $line
	done
}

#更优雅的读文件
#Add IFS= so that read won't trim leading and trailing whitespace from each line
#Add -r to read to prevent from backslashes from being interpreted as escape sequences.
function read_file_best() {
	while IFS= read -r line;
	do
		echo $line
	done < ${file}
}
	
read_file