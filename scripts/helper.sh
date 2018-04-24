#!/bin/bash

# Check for broken links
build(){
    pushd scripts/pytest/
    py.test test_links.py
    popd
}

# Given path to a markdown file, open its corresponding source.txt
# Use Case: I have just added a new picture to Python_Reversing.md in
# contents/languages/Python_Reversing.md and I want to open its corresponding
# sources.txt, which can be found in images/languages/Python_Reversing/sources.txt,
# to document where I got that image from
get_source(){
    relative_path=`sed "s|\.\/||" <<< $1`
    absolute_path=`echo $(pwd)`/${relative_path}
    file=`echo ${absolute_path} | awk -F'/' '{print $NF}'`
    folder=`echo ${absolute_path} | awk -F'/' '{print $(NF-1)}'`

    # Checks if file (without the .md extension) is the same string as folder
    if [ "${file%.*}" == "$folder" ] 
    then 
	file_location=`sed -e "s|contents|images|" -e "s|${file}|sources.txt|" <<< ${absolute_path}`
    else
	file_location=`sed -e "s|contents|images|" -e "s|.md|/sources.txt|" <<< ${absolute_path}`
    fi

    vim ${file_location}
}

# Remove trailing whitespaces
cleanup(){
    for file in `find -name "*.txt" -o -name "*.py" -o -name "*.md"`
    do
        sed -i 's/\s*$//g' ${file}
    done
}
