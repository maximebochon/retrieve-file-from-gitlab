#!/usr/bin/env bash
#
# Script to retrieve a file from a project hosted on a GitLab repository.
#
# An access token has to be provided through the following environment variable: GitlabPrivateToken_Api_ReadRepository
# The required GitLab rights are: api, read_repository.
#
# #1 argument: relative local path where to store the file
# #2 argument: relative remote path from where to retrieve the file
#
# Example : ./retrieve-file-from-gitlab.sh src/app/api/openapi-tagada.yaml src/main/resources/api/openapi-tagada.yaml

GITLAB_SERVICE="gitlab.some.where"
PROJECT_ID="1234"
REF_BRANCH="develop"
ACCESS_TOKEN="${GitlabPrivateToken_Api_ReadRepository}"

localFile="$1"
remoteFile="$2"
urlEncodedRemoteFile=$(echo -n $remoteFile | perl -p -e 's/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg')
header="PRIVATE-TOKEN: ${ACCESS_TOKEN}"
fileDownloadUrl="http://${GITLAB_SERVICE}/api/v4/projects/${PROJECT_ID}/repository/files/${urlEncodedRemoteFile}/raw?ref=${REF_BRANCH}"

echo "local file: ${localFile}"
echo "remote file: ${remoteFile}"
echo "URL encoded: ${urlEncodedRemoteFile}"
echo "project ID: ${PROJECT_ID}"

echo

curl --verbose --fail --show-error --header "${header}" --output "${localFile}" "${fileDownloadUrl}"
exit $?
