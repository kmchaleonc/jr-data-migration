# ONCO SQL Interview Environment

## Quick Start for Candidates

1. **Fork this repository** to your GitHub account
2. **Open in GitHub Codespaces**:
   - Click the green "Code" button
   - Select "Codespaces" tab
   - Click "Create codespace on main"
3. **Wait for environment setup** (about 1-2 minutes)
   - The database will be automatically initialized
   - VS Code will open with SQLite extension configured

## How to Run SQL Queries

### Option 1: Using SQLTools Extension (Recommended)
1. Click the database icon in the left sidebar
2. Click "Interview DB" connection
3. Write queries in any `.sql` file
4. Highlight your query and press `Ctrl+E` (or `Cmd+E` on Mac)

### Option 2: Using Command Line
```bash
sqlite3 database/healthcare.db