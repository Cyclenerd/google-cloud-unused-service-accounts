#!/usr/bin/env bash

# Copyright 2023 Nils Knieling. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Get last authentications and copy to database

source "0_config.sh" || exit 9

echo
echo "CREATE DATABASE"
echo "---------------"
sqlite3 "$MY_DB" < "create.sql" || exit 9
echo "[OK] Database created successfully."

echo
echo "GET AND COPY SERVICE ACCOUNTS AND SA KEYS"
echo "-----------------------------------------"
MY_WARNING=0
while IFS=',' read -r MY_PROJECT_ID MY_PROJECT_NUMBER || [[ -n "$MY_PROJECT_NUMBER" ]]; do
	echo "» $MY_PROJECT_ID"
	# Get last authentications (serviceAccountLastAuthentication)
	if gcloud policy-intelligence query-activity --quiet \
	--project="$MY_PROJECT_ID" \
	--activity-type="serviceAccountLastAuthentication" \
	--limit="unlimited" \
	--format="json" > "$DIR_SERVICEACCOUNTS/$MY_PROJECT_ID.json"; then
		perl "copy.pl" "$DIR_SERVICEACCOUNTS/$MY_PROJECT_ID.json" "$MY_DB" && \
		echo "[OK] Last authentications successfully queried and copied."
	else
		echo "[!!] Cannot query last authentications!"
		MY_WARNING=1
	fi
	# Get last authentications with key (serviceAccountKeyLastAuthentication)
	if gcloud policy-intelligence query-activity --quiet \
	--project="$MY_PROJECT_ID" \
	--activity-type="serviceAccountKeyLastAuthentication" \
	--limit="unlimited" \
	--format="json" > "$DIR_KEYS/$MY_PROJECT_ID.json"; then
		perl "copy.pl" "$DIR_KEYS/$MY_PROJECT_ID.json" "$MY_DB" && \
		echo "[OK] Last key authentications successfully queried and copied."
	else
		echo "[!!] Cannot query last key authentications!"
		MY_WARNING=1
	fi
	echo
done <"$CSV_PROJECTS"

echo
echo "GET AND COPY KEYS"
echo "-----------------"
sqlite3 -csv \
"$MY_DB" \
"SELECT serviceAccountId, MAX(lastAuthenticatedTime) FROM serviceAccountKeyAuthentications GROUP BY serviceAccountId" > "$CSV_ACCOUNTS" || exit 9

while IFS=',' read -r MY_SERVICE_ACCOUNT_ID MY_LAST_AUTH_TIME || [[ -n "$MY_LAST_AUTH_TIME" ]]; do
	echo "» $MY_SERVICE_ACCOUNT_ID"
	if gcloud iam service-accounts keys list --quiet \
	--iam-account="$MY_SERVICE_ACCOUNT_ID" \
	--format="json" > "$DIR_KEYS/$MY_SERVICE_ACCOUNT_ID.json"; then
		perl "copy.pl" "$DIR_KEYS/$MY_SERVICE_ACCOUNT_ID.json" "$MY_DB" || exit 9
	else
		echo "[!!] Cannot get keys!"
		MY_WARNING=1
	fi
	echo
done <"$CSV_ACCOUNTS"

echo
echo "EXPORT DATABASE"
echo "---------------"
{
	echo 'DROP TABLE IF EXISTS "serviceAccounts";'
	sqlite3 "$MY_DB" '.dump serviceAccounts'
	echo 'DROP TABLE IF EXISTS "serviceAccountKeyAuthentications";'
	sqlite3 "$MY_DB" '.dump serviceAccountKeyAuthentications'
	echo 'DROP TABLE IF EXISTS "serviceAccountKeys";'
	sqlite3 "$MY_DB" '.dump serviceAccountKeys'
} > "$MY_SQL_EXPORT" || exit 9
echo "[OK] Database exported successfully."

echo
if [ "$MY_WARNING" -eq "0" ]; then
	echo "[OK] All keys queried successfully."
else
	echo "[ERROR] Could not query all informations. Please check."
	exit 1
fi