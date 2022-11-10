#!/bin/bash
# Nagios Script
# Check if Files in Folder
#
# Author:       Robert Hess
# Github:       https://github.com/robert2555
# Date:         14.01.2019
#
# 20190128      added function for files
# 20200820      added directory check
# 20200826      added depth parameter
# 20201202      bugfix files wildcard
###########################################

v_folder=$1
v_warn=$2
v_crit=$3
v_period=$4
v_file=$5
[[ -n $6 ]] && v_depth=$6 || v_depth=99

function f_folder {

# Crit
if [[ ( $v_period == "days" && -n $(find $v_folder -type f -mtime +$v_crit) ) || ($v_period == "minutes" && -n $(find $v_folder -type f -cmin +$v_crit) ) ]]; then
        echo "Files older than $v_crit $v_period in $v_folder!"
        exit 2
# Warning
elif [[ ( $v_period == "days" && -n $(find $v_folder -type f -mtime +$v_warn) ) || ($v_period == "minutes" && -n $(find $v_folder -type f -cmin +$v_warn) ) ]]; then
        echo "Files older than $v_warn $v_period in $v_folder!"
        exit 1
# OK
elif [[ ( $v_period == "days" && -z $(find $v_folder -type f -mtime +$v_warn) ) || ($v_period == "minutes" && -z $(find $v_folder -type f -cmin +$v_warn) ) ]]; then
        echo "No files older than $v_warn $v_period in $v_folder."
        exit 0

# If period != days||minutes
else
        v_cfiles=$(find $v_folder -type f | wc -l)

        # Crit
        if [[ -n $(find $v_folder -type f) && $v_cfiles -ge $v_crit ]]; then
                echo "$v_cfiles files in $v_folder!"
                exit 2
        # Warn
        elif [[ -n $(find $v_folder -type f) && $v_cfiles -ge $v_warn ]]; then
                echo "$v_cfiles files in $v_folder!"
                exit 1
        # OK
        else
                echo "$v_cfiles files in $v_folder."
                exit 0
        fi
fi

}

function f_file {

# Crit
if [[ ( $v_period == "days" && -n $(find $v_folder -maxdepth ${v_depth} -name "*${v_file}" -type f -mtime +$v_crit) ) || ($v_period == "minutes" && -n $(find $v_folder -maxdepth ${v_depth} -name "*${v_file}" -type f -cmin +$v_crit) ) ]]; then
        echo "Files ${v_file} older than $v_crit $v_period in $v_folder!"
        exit 2
# Warning
elif [[ ( $v_period == "days" && -n $(find $v_folder -maxdepth ${v_depth} -name "*${v_file}" -type f -mtime +$v_warn) ) || ($v_period == "minutes" && -n $(find $v_folder -maxdepth ${v_depth} -name "*${v_file}" -type f -cmin +$v_warn) ) ]]; then
        echo "Files ${v_file} older than $v_warn $v_period in $v_folder!"
        exit 1
# OK
elif [[ ( $v_period == "days" && -z $(find $v_folder -maxdepth ${v_depth} -name "*${v_file}" -type f -mtime +$v_warn) ) || ($v_period == "minutes" && -z $(find $v_folder -maxdepth ${v_depth} -name "*${v_file}" -type f -cmin +$v_warn) ) ]]; then
        echo "No files older than $v_warn $v_period in $v_folder."
        exit 0
fi

}

if [[ -z ${v_folder} || -z ${v_warn} || -z ${v_crit} || -z ${v_period} ]]; then
        echo "Usage: check_files.sh <folder> <warning> <critical> <period> <opt:file> <opt:depth>"
        echo "Example: check_files.sh /tmp 30 60 minutes .txt"
        echo "         check_files.sh /tmp 1 3 days"
else
 # Directory Check
 ls ${v_folder} >> /dev/null || {
        echo "Error accessing ${v_folder}!"
        exit 2
 }

        if [[ -z ${v_file} ]]; then
                f_folder
        else
                f_file
        fi
fi

