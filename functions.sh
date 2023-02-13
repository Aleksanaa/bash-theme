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
		printf "${ICON_HOME} ~"
	else
		printf "${ICON_FOLDER} ${path}"
	fi
	_reset
}

# Implements lazy loading on path
get_path() {
	CURRENT_REAL_PATH=$(pwd)
	if [ ! "${CACHED_REAL_PATH}" == "${CURRENT_REAL_PATH}" ]; then
		CACHED_SHRINK_PATH=$(shrink_path "${CURRENT_REAL_PATH}")
		CACHED_REAL_PATH=${CURRENT_REAL_PATH}
	fi
	printf "${CACHED_SHRINK_PATH}"
}

get_hostname() {
	[ -z ${HOSTNAME} ] && HOSTNAME=$(cat /proc/sys/kernel/hostname)
	_color purple
	printf "${HOSTNAME}"
	_reset
}

get_nixshell() {
	_color blue
	if [[ ${PATH} == /nix/store/* ]]; then
		printf "${ICON_NIX}"
	fi
	_reset
}

get_arrow() {
	if [ $? -eq 0 ]; then
		_color yellow
	else
		_color red
	fi
	printf "${ICON_ARROW}"
	_reset
}
