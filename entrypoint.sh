#!/bin/bash
set -e

# Remove old server PID if it exists
rm -f /chat_system/tmp/pids/server.pid

cd /chat_system

# Create a new Rails app if it doesn't exist yet
if [ ! -f "config/application.rb" ]; then
  echo "Creating new Rails app..."
  rails new . --force --database=mysql 
fi

bundle install
rails db:migrate
rails elasticsearch:reindex_messages

# Run whatever command is passed to the container (e.g. rails s)
exec "$@"
