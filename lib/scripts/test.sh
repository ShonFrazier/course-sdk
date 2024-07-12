#!/bin/sh
set -e
set -o pipefail

CODECRAFTERS_SUBMISSION_DIR=/app

test -d /app-cached && cp -p -R /app-cached/. "$CODECRAFTERS_SUBMISSION_DIR"

if [ -f "${CODECRAFTERS_SUBMISSION_DIR}/.codecrafters/compile.sh" ]; then
    echo ""
    /bin/sh "${CODECRAFTERS_SUBMISSION_DIR}/.codecrafters/compile.sh" | sed $'s/^/\x1b[33m[compile]\x1b[0m /' || exit 1
    echo ""
elif [ -f /codecrafters-precompile.sh ]; then
    echo ""
    /bin/sh /codecrafters-precompile.sh | sed $'s/^/\x1b[33m[compile]\x1b[0m /' || exit 1
    echo ""
fi

# Move .codecrafters/run.sh --> your_program.sh if present
if [ -f "${CODECRAFTERS_SUBMISSION_DIR}/.codecrafters/run.sh" ]; then
    cp "${CODECRAFTERS_SUBMISSION_DIR}/.codecrafters/run.sh" "${CODECRAFTERS_SUBMISSION_DIR}/your_program.sh"
fi

exec /tester/test.sh
