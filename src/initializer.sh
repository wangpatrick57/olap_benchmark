#!/bin/bash

check_tools_installed() {
  PG_TOOLS=("postgres" "psql" "pg_ctl")
  for pg_tool in "${PG_TOOLS[@]}"; do
    $pg_tool --version &>/dev/null
    if [ "$?" -eq "0" ]; then
      echo "PASS: $pg_tool is installed"
    else
      echo >&2 "FAILURE: $pg_tool is not installed"
      exit 1
    fi
  done
}

check_pgdata_clean() {
  if [ -z "$PGDATA" ]; then
    echo >&2 "FAILURE: PGDATA is empty"
    exit 1
  else
    echo "PASS: PGDATA ($PGDATA) is set"
  fi

  # I chose to enforce that PGDATA is an empty directory instead of allowing it to not exist since
  # this makes the script's logic much simpler
  if [ -d "$PGDATA" ]; then
    echo "PASS: PGDATA ($PGDATA) is an existent directory"
  else
    echo >&2 "FAILURE: PGDATA ($PGDATA) does not exist"
    exit 1
  fi

  if [ "$(ls -A "$PGDATA")" ]; then
    echo >&2 "FAILURE: PGDATA ($PGDATA) is not an empty directory"
    exit 1
  else
    echo "PASS: PGDATA ($PGDATA) is an empty directory"
  fi
}

run_initdb() {
  initdb &>/dev/null
  if [ "$?" -eq "0" ]; then
    echo "PASS: initdb ran successfully"
  else
    echo >&2 "FAILURE: initdb did not run successfully"
    exit 1
  fi
}

try_start_postgres() {
  pg_ctl start &>/dev/null
  if [ "$?" -eq "0" ]; then
    echo "PASS: started postgres"
  else
    echo >&2 "FAILURE: pg_ctl start failed. There is likely an existing running instance"
    exit 1
  fi
}

check_tools_installed
check_pgdata_clean
run_initdb
try_start_postgres
echo "SUCCESS: initialization complete"