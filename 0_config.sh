#!/usr/bin/env bash

################################################################################
#### Configuration Section
################################################################################

MY_DB="auth.db"
MY_SQL_EXPORT="auth.sql"
MY_CSV_EXPORT="auth.csv"
API_POLICY_ANALYZER="policyanalyzer.googleapis.com"
CSV_PROJECTS="projects.csv"
CSV_ACCOUNTS="accounts.csv"
DIR_SERVICEACCOUNTS="serviceaccounts"
DIR_KEYS="keys"

################################################################################
#### END Configuration Section
################################################################################

echo
echo "SQLite database : $MY_DB"
echo "SQL export : $MY_SQL_EXPORT"
echo "CSV export : $MY_CSV_EXPORT"
echo "CSV with projects : $CSV_PROJECTS"
echo "CSV for service account : $CSV_ACCOUNTS"
echo "Directory for SA information : $DIR_SERVICEACCOUNTS"
echo "Directory for SA key information : $DIR_KEYS"
echo "Policy Analyzer API : $API_POLICY_ANALYZER"
echo

# Check commands

command -v gcloud          >/dev/null 2>&1 || { echo >&2 "!!! Google Cloud CLI 'gcloud' is not installed. Aborting!"; exit 1; }
command -v sqlite3         >/dev/null 2>&1 || { echo >&2 "!!! SQLite database engine 'sqlite3' is not installed. Aborting!"; exit 1; }
command -v perl            >/dev/null 2>&1 || { echo >&2 "!!! Perl programming language 'perl' is not installed. Aborting!"; exit 1; }
# sudo apt install libjson-xs-perl
perl -e 'use JSON::XS;'    >/dev/null 2>&1 || { echo >&2 "!!! Perl module JSON::XS is not installed. Aborting!"; exit 1; }
# sudo apt install libdbd-sqlite3-perl
perl -e 'use DBI;'         >/dev/null 2>&1 || { echo >&2 "!!! Perl module DBI is not installed. Aborting!"; exit 1; }
perl -e 'use DBD::SQLite;' >/dev/null 2>&1 || { echo >&2 "!!! Perl module DBD::SQLite is not installed. Aborting!"; exit 1; }

# Create directories

mkdir -p "$DIR_SERVICEACCOUNTS" || { echo >&2 "!!! Cannot create directory '$DIR_SERVICEACCOUNTS'. Aborting!"; exit 1; }
mkdir -p "$DIR_KEYS"            || { echo >&2 "!!! Cannot create directory '$DIR_KEYS'. Aborting!"; exit 1; }

# Google Cloud CLI login

echo -n "Active Google Cloud Platform user: "
gcloud auth list --quiet \
--filter="status:ACTIVE" \
--format="value(account)" --limit=1 || exit 9
echo