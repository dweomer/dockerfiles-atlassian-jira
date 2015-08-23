#!/bin/sh

JIRA_SERVER_XML="${JIRA_INSTALL}/conf/server.xml"
JIRA_CONNECTOR_SECURE_ATTR="secure"
JIRA_CONNECTOR_SCHEME_ATTR="scheme"
JIRA_CONNECTOR_PROXY_PORT_ATTR="proxyPort"
JIRA_CONNECTOR_PROXY_NAME_ATTR="proxyName"

if [ ! -z "${JIRA_CONNECTOR_PROXY_NAME}" ] && [ -z "$(xmlstarlet sel -t -c '//Connector[@proxyName]' ${JIRA_SERVER_XML})" ]; then
    JIRA_CONNECTOR_SECURE=${JIRA_CONNECTOR_SECURE:-true}
    JIRA_CONNECTOR_SCHEME=${JIRA_CONNECTOR_SCHEME:-https}
    JIRA_CONNECTOR_PROXY_PORT=${JIRA_CONNECTOR_PROXY_PORT:-443}

    echo "+${JIRA_SERVER_XML}://Connector[@port=8080] ${JIRA_CONNECTOR_SECURE_ATTR}=\"${JIRA_CONNECTOR_SECURE}\""
    echo "+${JIRA_SERVER_XML}://Connector[@port=8080] ${JIRA_CONNECTOR_SCHEME_ATTR}=\"${JIRA_CONNECTOR_SCHEME}\""
    echo "+${JIRA_SERVER_XML}://Connector[@port=8080] ${JIRA_CONNECTOR_PROXY_PORT_ATTR}=\"${JIRA_CONNECTOR_PROXY_PORT}\""
    echo "+${JIRA_SERVER_XML}://Connector[@port=8080] ${JIRA_CONNECTOR_PROXY_NAME_ATTR}=\"${JIRA_CONNECTOR_PROXY_NAME}\""

    xmlstarlet ed --inplace \
            --insert '//Connector[@port=8080]' -t attr -n ${JIRA_CONNECTOR_SECURE_ATTR} -v ${JIRA_CONNECTOR_SECURE} \
            --insert '//Connector[@port=8080]' -t attr -n ${JIRA_CONNECTOR_SCHEME_ATTR} -v ${JIRA_CONNECTOR_SCHEME} \
            --insert '//Connector[@port=8080]' -t attr -n ${JIRA_CONNECTOR_PROXY_PORT_ATTR} -v ${JIRA_CONNECTOR_PROXY_PORT} \
            --insert '//Connector[@port=8080]' -t attr -n ${JIRA_CONNECTOR_PROXY_NAME_ATTR} -v ${JIRA_CONNECTOR_PROXY_NAME} \
        ${JIRA_SERVER_XML}
fi

echo "=${JIRA_SERVER_XML}:"
xmlstarlet sel -t -c '//Connector[@port=8080]' ${JIRA_SERVER_XML} | fold -s | sed -e '2,$s/^/    /g' -e 's/^/    /g'
echo
