#!/usr/bin/env bash

source $(dirname $BASH_SOURCE)/colors.sh
source $(dirname $BASH_SOURCE)/icons.sh

# trim function, from dylanaraps
# https://github.com/dylanaraps/pure-sh-bible#trim-all-white-space-from-string-and-truncate-spaces
trim_all() {
    set -f
    set -- $*
    printf '%s\n' "$*"
    set +f
}

# These two functions deal with current directory.
shrink_path() {
	local path=$1
	path="${path/"$HOME"/\~}"
	# shrink paths to one letter each
	# inspiration from powerlevel10k
	if [ ${#path} -gt 32 ]; then
		IFS='/' read -r -a path_array <<< "${path}"
		for entry in "${path_array[@]::${#path_array[@]}-1}"; do
			path="${path/"/$entry/"/"/${entry:0:1}/"}"
		done
	fi
	_color green
	if [[ ${path} == "~" ]]; then
		printf "${ICON_HOME} ~"
	elif [[ ${path} == "~/"* ]]; then
		printf "${ICON_FOLDER} ${path}"
	else
		printf "${ICON_CONTROL} ${path}"
	fi
	_reset
}

# Implements lazy loading on path
# Produce path again only when it changes
get_path() {
	CURRENT_REAL_PATH=$(pwd)
	if [ ! "${CACHED_REAL_PATH}" == "${CURRENT_REAL_PATH}" ]; then
		CACHED_SHRINK_PATH=$(shrink_path "${CURRENT_REAL_PATH}")
		CACHED_REAL_PATH=${CURRENT_REAL_PATH}
	fi
	printf "${CACHED_SHRINK_PATH}"
}

get_hostname() {
	if [[ ${PATH} == /nix/store/* ]]; then
		_color blue
		printf "${ICON_NIX} "
	else
		_color purple
	fi
	printf "\h"
	_reset
}

get_arrow() {
	if [[ $1 == 0 ]]; then
		_color yellow
	else
		_color red
	fi
	printf "${ICON_ARROW}"
	_reset
}

get_gitstatus() {
	if [[ ${HAS_GITSTATUS} == 1 ]]; then
		local output='';
		if gitstatus_query && [[ "$VCS_STATUS_RESULT" == ok-sync ]]; then
			if [[ -n "$VCS_STATUS_LOCAL_BRANCH" ]]; then
				output+=" ${VCS_STATUS_LOCAL_BRANCH//\\/\\\\}"  # escape backslash
			else
				output+=" @${VCS_STATUS_COMMIT//\\/\\\\}"       # escape backslash
			fi
			(( VCS_STATUS_NUM_STAGED )) && output+="${ICON_TICK}${VCS_STATUS_NUM_STAGED}"
			(( VCS_STATUS_NUM_UNSTAGED )) && output+="${ICON_PENCIL}${VCS_STATUS_NUM_UNSTAGED}"
			(( VCS_STATUS_NUM_UNTRACKED )) && output+="${ICON_WARN}${VCS_STATUS_NUM_UNTRACKED}"
			(( VCS_STATUS_COMMITS_AHEAD )) && output+="${ICON_UPARROW}${VCS_STATUS_COMMITS_AHEAD}"
			(( VCS_STATUS_COMMITS_BEHIND )) && output+="${ICON_DOWNARROW}${VCS_STATUS_COMMITS_BEHIND}"

		fi
		printf "${output}"
	fi
}

# source gitstatus plugin
which gitstatusd > /dev/null 2>&1
if [ $? -eq 0 ] && [ -z ${GITSTATUS_PLUGIN_PATH} ]; then
	GITSTATUS_PLUGIN_PATH=$(realpath "$(dirname $(which gitstatusd))/../share/gitstatus")
fi

if [ -n ${GITSTATUS_PLUGIN_PATH} ]; then
	source ${GITSTATUS_PLUGIN_PATH}/gitstatus.plugin.sh
	gitstatus_stop && gitstatus_start
	HAS_GITSTATUS=1
fi
