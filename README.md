# ONCO SQL Interview Environment

## Quick Start for Candidates

1. **Fork this repository** to your GitHub account
2. **Open in GitHub Codespaces**:
   - Click the green "Code" button
   - Select "Codespaces" tab  
   - Click "Create codespace on main"
3. **Wait for setup** (~1 minute - you'll see "Database initialized successfully!")

## Running SQL Queries - Three Options

### Option 1: Command Line (Recommended for Interview)
```bash
# Interactive mode
sqlite3 database/healthcare.db

# Then type your SQL queries
SELECT * FROM patients LIMIT 5;

# Type .exit to quit
```

### Option 2: Run SQL Files
```bash
# Create a file with your query
echo "SELECT * FROM patients LIMIT 5;" > test.sql

# Run it
sqlite3 database/healthcare.db < test.sql
```

### Option 3: VS Code SQLite Viewer
1. Navigate to database/healthcare.db in the file explorer
2. Click on it to open the database viewer
3. Click "Run Query" and write your SQL