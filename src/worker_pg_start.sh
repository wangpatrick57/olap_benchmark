#!/bin/bash
## Environment: worker node
##
## Parameters:
##  * pgdata_dpath: The --pgdata directory for this Postgres instance
##  * pgbin_dpath: The bin directory with pg_ctl
##
## Preconditions:
##  * pgdata_dpath has been initialized with initdb
##  * pgbin_dpath is a built Postgres bin
##  * No process running on port 5432
##
## Postconditions:
##  * The postgres in pgbin_dpath will be started with pgdata_dpath as its directory
##
## Notes:
##  * worker_pg_start is separate from worker_pg_init because start happens every time a node crashes and comes back but init only happens once

SCRNAME=$(basename $0)
PGPORT=5432

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
  if [ ! -d "$pgdata_dpath" ]; then
    echo >&2 "$SCRNAME: pgdata_dpath ($pgdata_dpath) does not exist"
    exit 1
  fi

  # check pgbin_dpath
  PG_TOOLS=("pg_ctl")
  for pg_tool in "${PG_TOOLS[@]}"; do
    pg_tool_fpath="$pgbin_dpath/$pg_tool"
    if [ ! -f "$pg_tool_fpath" ]; then
      echo >&2 "$SCRNAME: pg_tool_fpath ($pg_tool_fpath) does not exist"
      exit 1
    fi
  done

  # check lsof installed
  lsof -v &>/dev/null
  if [ "$?" -ne "0" ]; then
    echo >&2 "$SCRNAME: lsof is not installed"
    exit 1
  fi

  # check PGPORT with lsof
  if lsof -i :$PGPORT &> /dev/null; then
    echo >&2 "$SCRNAME: another process is running on PGPORT ($PGPORT)"
    exit 1
  fi
}

try_start() {
  # call pg_ctl start
  $pgbin_dpath/pg_ctl start -D $pgdata_dpath >/dev/null
  if [ "$?" -ne "0" ]; then
    echo >&2 "$SCRNAME: pg_ctl failed. Check logs in pgdata_dpath ($pgdata_dpath)"
    exit 1
  fi
}


# main
parse_args "$@"
check_preconditions
try_start