#!/bin/bash

# Check for broken links
build(){
    pushd scripts/pytest/
    py.test test_links.py
    popd
}

# Given path to a markdown file, open its corresponding source.txt
get_source(){
    file=`echo $1 | awk -F'/' '{print $NF}'`
    folder=`echo $1 | awk -F'/' '{print $(NF-1)}'`

    # Checks if file (without the .md extension) is the same string as folder
    if [ "${file%.*}" == "$folder" ] 
    then 
	file_location=`sed -e "s|contents|images|" -e "s|${file}|sources.txt|" <<< $1`
    else
	file_location=`sed -e "s|contents|images|" -e "s|.md|/sources.txt|" <<< $1`
    fi

    vim $file_location
}

# Remove trailing whitespaces
cleanup(){
    for file in `find -name "*.txt" -o -name "*.py" -o -name "*.md"`
    do
        sed -i 's/\s*$//g' $file
    done
}
