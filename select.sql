SELECT
	A.serviceAccountId      AS serviceAccountId,
	A.lastAuthenticatedTime AS lastAuthenticatedTime,
	(SELECT MAX(K.lastAuthenticatedTime) FROM serviceAccountKeyAuthentications K WHERE K.serviceAccountId LIKE A.serviceAccountId) AS lastKeyAuthentication,
	(SELECT COUNT(K.serviceAccountKey)   FROM serviceAccountKeyAuthentications K WHERE K.serviceAccountId LIKE A.serviceAccountId) AS authenticationKeys,
	(SELECT COUNT(K.serviceAccountKey)   FROM serviceAccountKeys K               WHERE K.serviceAccountId LIKE A.serviceAccountId) AS serviceAccountKeys,
	(SELECT COUNT(K.serviceAccountKey)   FROM serviceAccountKeys K               WHERE K.keyType LIKE "USER_MANAGED" AND K.serviceAccountId LIKE A.serviceAccountId) AS userManaged,
	(SELECT COUNT(K.serviceAccountKey)   FROM serviceAccountKeys K               WHERE K.keyType LIKE "SYSTEM_MANAGED" AND K.serviceAccountId LIKE A.serviceAccountId) AS systemManaged,
	(SELECT MAX(K.keyExpires)            FROM serviceAccountKeys K               WHERE K.serviceAccountId LIKE A.serviceAccountId) AS maxKeyValid,
	A.projectId
FROM serviceAccounts A;