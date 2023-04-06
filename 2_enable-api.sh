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

# Enable Policy Analyzer API (policyanalyzer.googleapis.com)

source "0_config.sh" || exit 9

echo
echo "Enable API '$API_POLICY_ANALYZER'..."

MY_WARNING=0

while IFS=',' read -r MY_PROJECT_ID MY_PROJECT_NUMBER || [[ -n "$MY_PROJECT_NUMBER" ]]; do
	echo "» $MY_PROJECT_ID"
	if gcloud services enable "$API_POLICY_ANALYZER" --quiet --project="$MY_PROJECT_ID"; then
		echo "[OK] Service successfully activated."
	else
		echo "[!!] Could not activate service!"
		MY_WARNING=1
	fi
done <"$CSV_PROJECTS"

echo

if [ "$MY_WARNING" -eq "0" ]; then
	echo "[OK] All projects set up successfully."
	exit 0
else
	echo "[ERROR] Service could not be activated in all projects. Please check."
	exit 1
fi

