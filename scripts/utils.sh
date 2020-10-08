#! /bin/bash

RED=$'\e[1;31m'
BLU=$'\e[1;32m'
YEL=$'\e[1;33m'
MAG=$'\e[1;35m'
WHI=$'\e[0m'

function info() { echo $'\e[1;32m'INFO:$'\e[0m' $1; }
function warn() { echo $'\e[1;33m'WARN:$'\e[0m' $1; }
function err() { echo $'\e[1;31m'ERR:$'\e[0m' $1; }
function debug() { [[ "$DEBUGGING" == "1" ]] && echo $'\e[1;34m'DEBUG:$'\e[0m' $1; }

function do_work() {
    debug "> $1 ${@:2}"
    $1 ${@:2}
}