#! /bin/bash

function info() { echo $'\e[1;32m'$1$'\e[0m'; }
function warn() { echo $'\e[1;33m'$1$'\e[0m'; }
function error() { echo $'\e[1;31m'$1$'\e[0m' && exit 1; }
function debug() { [[ "$DEBUGGING" == "1" ]] && echo $'\e[1;35m'$1$'\e[0m'; }

function do_work() {
   debug ">> $1 ${@:2}"
   $1 ${@:2}
}