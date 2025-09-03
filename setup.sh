#!/bin/bash

echo "Setting up interview database..."

# Check if sqlite3 is installed
if ! command -v sqlite3 &> /dev/null; then
    echo "Installing SQLite..."
    sudo apt-get update && sudo apt-get install -y sqlite3
fi

# Initialize database
cd database
if [ -f healthcare.db ]; then
    echo "Removing old database..."
    rm healthcare.db
fi

echo "Creating new database..."
sqlite3 healthcare.db < init.sql

echo "Database initialized successfully!"
echo ""
echo "Testing database..."
sqlite3 healthcare.db "SELECT 'Setup complete! Found ' || COUNT(*) || ' patients' FROM patients;"