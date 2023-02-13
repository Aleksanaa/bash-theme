#!/usr/bin/env bash

source ./colors.sh
source ./icons.sh

# These two functions deal with current directory.
shrink_path() {
	local path=$1
	path="${path/"$HOME"/\~}"
	if [ ${#path} -gt 32 ]; then
		IFS='/' read -r -a path_array <<< "${path}"
		for entry in "${path_array[@]::${#path_array[@]}-1}"; do
			path="${path/"/$entry/"/"/${entry:0:1}/"}"
		done
	fi
	_color green
	if [[ ${path} == "~" ]]; then
		echo "${ICON_HOME} ~"
	else
		echo "${ICON_FOLDER} ${path}"
	fi
	_reset

}

# Implements lazy loading on path
get_path() {
	CURRENT_REAL_PATH=$(pwd)
	if [ "${CACHED_REAL_PATH}" == "${CURRENT_REAL_PATH}" ]; then
		echo "${CACHED_SHRINK_PATH}"
	else
		CACHED_SHRINK_PATH=$(shrink_path "${CURRENT_REAL_PATH}")
		CACHED_REAL_PATH=${CURRENT_REAL_PATH}
		echo "${CACHED_SHRINK_PATH}"
	fi
}
