#!/bin/bash
## Parameters:
##  * pgdata_dpath: The --pgdata directory for this Postgres instance
##  * bin_dpath: The bin directory with pg_ctl
##  * port: The port to run the Postgres instance on
##
## Preconditions:
##  * pgdata_dpath is an empty directory
##  * The right executables are available in bin_dpath
##  * No process is running on the port
##
## Postconditions:
##  * initdb will be called on pgdata_dpath
##  * A postgres instance will be run with the pg_ctl in bin_dpath on port

parse_args() {
  USAGE="usage: $0 pgdata_dpath bin_dpath port"
  if [ "$#" -ne "3" ]; then
    echo >&2 "$USAGE"
    exit 1
  fi
  pgdata_dpath=$1
  bin_dpath=$2
  port=$3
}

check_system() {
  # check tools
  lsof -v &>/dev/null
  if [ "$?" -eq "0" ]; then
    echo "PASS: lsof is installed"
  else
    echo >&2 "FAILURE: lsof is not installed"
    exit 1
  fi

  # check pgdata_dpath
  if [ -d "$pgdata_dpath" ]; then
    echo "PASS: pgdata_dpath ($pgdata_dpath) is an existent directory"
  else
    echo >&2 "FAILURE: pgdata_dpath ($pgdata_dpath) does not exist"
    exit 1
  fi
  if [ "$(ls -A "$pgdata_dpath")" ]; then
    echo >&2 "FAILURE: pgdata_dpath ($pgdata_dpath) is not an empty directory"
    exit 1
  else
    echo "PASS: pgdata_dpath ($pgdata_dpath) is an empty directory"
  fi

  # check bin_dpath
  PG_TOOLS=("pg_ctl")
  for pg_tool in "${PG_TOOLS[@]}"; do
    pg_tool_fpath="$bin_dpath/$pg_tool"
    if [ -f "$pg_tool_fpath" ]; then
      echo "PASS: pg_tool_fpath ($pg_tool_fpath) exists"
    else
      echo >&2 "FAILURE: pg_tool_fpath ($pg_tool_fpath) does not exist"
      exit 1
    fi
  done

  # check port
  if lsof -i :$port &> /dev/null; then
    echo >&2 "FAILURE: another process is running on port ($port)"
    exit 1
  else
    echo "PASS: port ($port) is free"
  fi
}

try_start_instance() {
  initdb --pgdata $pgdata_dpath &>/dev/null
  if [ "$?" -eq "0" ]; then
    echo "PASS: initdb ran successfully"
  else
    echo >&2 "FAILURE: initdb did not run successfully"
    exit 1
  fi

  $bin_dpath/pg_ctl start &>/dev/null
  if [ "$?" -eq "0" ]; then
    echo "PASS: started postgres"
  else
    echo >&2 "FAILURE: pg_ctl start failed. There is likely an existing running instance"
    exit 1
  fi
}


# main
parse_args "$@"
check_system
try_start_instance
echo "SUCCESS: initialization complete"