DROP TABLE IF EXISTS "serviceAccounts";
CREATE TABLE "serviceAccounts" (
	'serviceAccountId'             TEXT NOT NULL DEFAULT '',
	'lastAuthenticatedTime'        TEXT NOT NULL DEFAULT '',
	'projectId'                    TEXT NOT NULL DEFAULT '',
	PRIMARY KEY("serviceAccountId", "lastAuthenticatedTime")
);

DROP TABLE IF EXISTS "serviceAccountKeyAuthentications";
CREATE TABLE "serviceAccountKeyAuthentications" (
	'serviceAccountId'             TEXT NOT NULL DEFAULT '',
	'serviceAccountKey'            TEXT NOT NULL DEFAULT '',
	'lastAuthenticatedTime'        TEXT NOT NULL DEFAULT '',
	'projectId'                    TEXT NOT NULL DEFAULT '',
	PRIMARY KEY("serviceAccountKey", "lastAuthenticatedTime")
);

DROP TABLE IF EXISTS "serviceAccountKeys";
CREATE TABLE "serviceAccountKeys" (
	'serviceAccountId'             TEXT NOT NULL DEFAULT '',
	'serviceAccountKey'            TEXT NOT NULL DEFAULT '',
	'keyCreated'                   TEXT NOT NULL DEFAULT '',
	'keyExpires'                   TEXT NOT NULL DEFAULT '',
	'keyAlgorithm'                 TEXT NOT NULL DEFAULT '',
	'keyOrigin'                    TEXT NOT NULL DEFAULT '',
	'keyType'                      TEXT NOT NULL DEFAULT '',
	'projectId'                    TEXT NOT NULL DEFAULT '',
	PRIMARY KEY("serviceAccountKey")
);