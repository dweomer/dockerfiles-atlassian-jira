#!/bin/sh -e

case "$1" in
    jira)
        if [ -d /srv/jira.d ]; then
            for f in $(find /srv/jira.d -type f | sort); do
                case "$f" in
                    *.sh)   echo "$0: sourcing $f"; . "$f" ;;
                    *)      echo "$0: ignoring $f" ;;
                esac
            done
        fi

        exec ${JIRA_INSTALL}/bin/start-jira.sh -fg
    ;;

    *)
        exec "$@"
    ;;
esac
