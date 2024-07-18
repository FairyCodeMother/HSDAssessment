#!/bin/bash
set -e

# Ensure the correct environment is set for the test database
bin/rails db:environment:set RAILS_ENV=test

# Run migrations for the test database
bin/rails db:migrate RAILS_ENV=test

# Remove a potentially pre-existing server.pid for Rails.
rm -f /HopSkipChallenge/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

