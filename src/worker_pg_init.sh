#!/bin/bash
## Environment: worker node
##
## Parameters:
##  * pgdata_dpath: The --pgdata directory for this Postgres instance
##  * pgbin_dpath: The bin directory with initdb
##
## Preconditions:
##  * pgdata_dpath is non-existent
##  * pgbin_dpath is a built Postgres bin
##
## Postconditions:
##  * initdb will be called on pgdata_dpath

SCRNAME=$(basename $0)

parse_args() {
  USAGE="usage: $SCRNAME pgdata_dpath pgbin_dpath"
  if [ "$#" -ne "2" ]; then
    echo >&2 "$USAGE"
    exit 1
  fi
  pgdata_dpath=$1
  pgbin_dpath=$2
}

check_preconditions() {
  # check pgdata_dpath
  if [ -d "$pgdata_dpath" ]; then
    echo >&2 "$SCRNAME: pgdata_dpath ($pgdata_dpath) should not exist"
    exit 1
  fi

  # check pgbin_dpath
  PG_TOOLS=("initdb")
  for pg_tool in "${PG_TOOLS[@]}"; do
    pg_tool_fpath="$pgbin_dpath/$pg_tool"
    if [ ! -f "$pg_tool_fpath" ]; then
      echo >&2 "$SCRNAME: pg_tool_fpath ($pg_tool_fpath) does not exist"
      exit 1
    fi
  done
}

try_init() {
  # create directory
  mkdir -p $pgdata_dpath >/dev/null
  if [ "$?" -ne "0" ]; then
    echo >&2 "$SCRNAME: mkdir did not run successfully"
    exit 1
  fi

  # run initdb
  $pgbin_dpath/initdb -D $pgdata_dpath >/dev/null
  if [ "$?" -ne "0" ]; then
    echo >&2 "$SCRNAME: initdb did not run successfully"
    exit 1
  fi
}


# main
parse_args "$@"
check_preconditions
try_init