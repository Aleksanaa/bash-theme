#!/usr/bin/env bash

# These are rgb colors from nord palette.
rgb_blue='81a1c1'
rgb_green='a3be8c'
rgb_yellow='ebcb8b'
rgb_red='bf616a'
rgb_orange='d08770'
rgb_purple='b48ead'
rgb_white='e5e9f0'


# We can turn them into ANSI escapes
# For wrapping prompt we need to add \[ and \]
# See unix.stackexchange.com/questions/105958/

_color() {
	local rgb_name=rgb_$1
	local rgb_color=${!rgb_name}
	printf "\[\x1b[38;2;%d;%d;%dm\]" 0x${rgb_color:0:2} 0x${rgb_color:2:2} 0x${rgb_color:4:2}
	printf "\[\033[1m\]"
}

_reset() {
	printf "\[\033[0m\]"
}
