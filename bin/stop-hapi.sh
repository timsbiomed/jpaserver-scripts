#!/usr/bin/env bash
set -euo pipefail

# stop-hapi.sh
# Stops the running HAPI instances.
# It sends the  TERM signal, not KILL, so it should be an orderly shutdown.

ps -ef | grep java | grep jpaserver | awk '{print $2}' | xargs kill
