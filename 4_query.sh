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

# Query database and create export

source "0_config.sh" || exit 9

echo "Query DB and create CSV export '$MY_CSV_EXPORT'..."

sqlite3 -header -csv "$MY_DB" < "select.sql" > "$MY_CSV_EXPORT" || exit 9

echo
echo "[DONE] Export completed successfully!"