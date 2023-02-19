#!/usr/bin/env bash

source ./colors.sh
source ./icons.sh

# source gitstatus plugin
if which gitstatusd > /dev/null 2>&1; then
	GITSTATUS_PLUGIN_PATH=$(realpath "$(dirname $(which gitstatusd))/../share/gitstatus")
	source ${GITSTATUS_PLUGIN_PATH}/gitstatus.plugin.sh
	HAS_GITSTATUS=1
fi

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
	else
		printf "${ICON_FOLDER} ${path}"
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
	if [ $? -eq 0 ]; then
		_color yellow
	else
		_color red
	fi
	printf "${ICON_ARROW}"
	_reset
}

get_gitstatus() {
	if [ -n ${HAS_GITSTATUS} ]; then
		local output='';
		if gitstatus_query && [[ "$VCS_STATUS_RESULT" == ok-sync ]]; then
			if [[ -n "$VCS_STATUS_LOCAL_BRANCH" ]]; then
				output+=" ${VCS_STATUS_LOCAL_BRANCH//\\/\\\\}"  # escape backslash
			else
				output+=" @${VCS_STATUS_COMMIT//\\/\\\\}"       # escape backslash
			fi
			(( VCS_STATUS_HAS_STAGED )) && output+='+'
			(( VCS_STATUS_HAS_UNSTAGED )) && output+="${ICON_PENCIL}"
			(( VCS_STATUS_HAS_UNTRACKED )) && output+='?'
		fi
		printf "${output}"
	fi
}
