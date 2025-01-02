#!/bin/bash

set -e

rails db:create || true

rails db:migrate

exec "$@"
