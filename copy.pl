#!/usr/bin/perl

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

# Copy gcloud CLI JSON export files to SQLite database

use strict;
use JSON::XS; # libjson-xs-perl
use DBI; # libdbd-sqlite3-perl

# Open JSON
my $json_file = $ARGV[0] || "file.json";
open(FH, "$json_file") or die "[ERROR] Cannot open JSON file '$json_file'!\n";
my $json_text = "";
while(<FH>){
	$json_text .= $_;
}
close(FH);
my $json = JSON::XS->new->utf8->decode($json_text);

# Open SQLite DB
my $db_file = $ARGV[1] || "auth.db";
my $db = DBI->connect("dbi:SQLite:dbname=$db_file","","") or die "\n[ERROR] Cannot connect '$DBI::errstr'!\n";

foreach my $item (sort @{$json}) {
	# Service Account Last Authentication
	if ($item->{'activity'} && $item->{'activity'}->{'serviceAccount'}) {
		my $name       = $item->{'activity'}->{'serviceAccount'}->{'fullResourceName'} || "";
		my $last_login = $item->{'activity'}->{'lastAuthenticatedTime'} || "";
		if ($name =~  m/projects\/([\d\w\-]+)\/serviceAccounts\/([\d\w\-\@\.]+)$/) {
			my $project         = "$1";
			my $service_account = "$2";
			my $insert = "INSERT INTO serviceAccounts (serviceAccountId, lastAuthenticatedTime, projectId) " .
			             "VALUES ('$service_account', '$last_login', '$project');";
			#print "$insert\n";
			$db->do("$insert") or die "\n[ERROR] Cannot insert service account '$DBI::errstr'!\n";
		} else {
			die "\n[ERROR] Cannot determine values from service account name '$name'!\n";
		}
	# Service Account Key Last Authentication
	} elsif ($item->{'activity'} && $item->{'activity'}->{'serviceAccountKey'}) {
		my $name       = $item->{'activity'}->{'serviceAccountKey'}->{'fullResourceName'} || "";
		my $last_login = $item->{'activity'}->{'lastAuthenticatedTime'} || "";
		if ($name =~  m/projects\/([\d\w\-]+)\/serviceAccounts\/([\d\w\-\@\.]+)\/keys\/([\d\w]+)$/) {
			my $project         = "$1";
			my $service_account = "$2";
			my $key             = "$3";
			my $insert = "INSERT INTO serviceAccountKeyAuthentications (serviceAccountId, serviceAccountKey, lastAuthenticatedTime, projectId) " .
			             "VALUES ('$service_account', '$key', '$last_login', '$project');";
			#print "$insert\n";
			$db->do("$insert") or die "\n[ERROR] Cannot insert service account key '$DBI::errstr'!\n";
		} else {
			die "\n[ERROR] Cannot determine values from service account key name '$name'!\n";
		}
	# Service Account Key
	} elsif ($item->{'keyType'}) {
		my $name      = $item->{'name'}            || "";
		my $algorithm = $item->{'keyAlgorithm'}    || "";
		my $origin    = $item->{'keyOrigin'}       || "";
		my $type      = $item->{'keyType'}         || "";
		my $created   = $item->{'validAfterTime'}  || "";
		my $expires   = $item->{'validBeforeTime'} || "";
		if ($name =~  m/projects\/([\d\w\-]+)\/serviceAccounts\/([\d\w\-\@\.]+)\/keys\/([\d\w]+)$/) {
			my $project         = "$1";
			my $service_account = "$2";
			my $key             = "$3";
			my $insert = "INSERT INTO serviceAccountKeys (serviceAccountId, serviceAccountKey, ".
			             "keyCreated, keyExpires, keyAlgorithm, keyOrigin, keyType, projectId) " .
			             "VALUES ('$service_account', '$key', ".
						 "'$created', '$expires', '$algorithm', '$origin', '$type', '$project');";
			#print "$insert\n";
			$db->do("$insert") or die "\n[ERROR] Cannot insert key '$DBI::errstr'!\n";
		} else {
			die "\n[ERROR] Cannot determine values from key name '$name'!\n";
		}
	} else {
		die "\n[ERROR] Cannot determine item type!\n";
	}
}