#!/bin/bash

echo "========================================="
echo "   SQL Interview Environment Setup"
echo "========================================="

# Step 1: Install SQLite3 for SQLTools
echo "📦 Installing SQLTools dependencies..."
SQLTOOLS_EXT_DIR=$(find ~/.vscode-server/extensions -name "mtxr.sqltools-driver-sqlite-*" -type d 2>/dev/null | head -n1)

if [ -n "$SQLTOOLS_EXT_DIR" ]; then
    cd "$SQLTOOLS_EXT_DIR"
    npm install sqlite3@5.1.7 >/dev/null 2>&1
    echo "✅ SQLTools dependencies installed"
else
    echo "⚠️  SQLTools extension not found yet - you may need to install sqlite3 manually"
fi

# Step 2: Initialize and seed database
cd "$CODESPACE_VSCODE_FOLDER" || cd /workspaces/*/

echo "🗄️  Initializing database..."

# Remove any existing database to ensure clean state
if [ -f database/healthcare.db ]; then
    rm database/healthcare.db
    echo "   Removed existing database"
fi

# Create and seed the database
cd database
sqlite3 healthcare.db < init.sql

# Verify the database was created successfully
if [ -f healthcare.db ]; then
    echo "✅ Database created successfully"
    
    # Show summary statistics
    echo ""
    echo "📊 DATABASE STATISTICS:"
    echo "------------------------"
    sqlite3 healthcare.db <<EOF
.mode column
.headers on
SELECT 'Table Name' as 'Table', 'Row Count' as 'Rows'
UNION ALL
SELECT '----------', '----------'
UNION ALL
SELECT 'patients', printf('%d', COUNT(*)) FROM patients
UNION ALL
SELECT 'appointments', printf('%d', COUNT(*)) FROM appointments
UNION ALL
SELECT 'diagnoses', printf('%d', COUNT(*)) FROM diagnoses
UNION ALL
SELECT 'treatments', printf('%d', COUNT(*)) FROM treatments
UNION ALL
SELECT 'legacy_patients', printf('%d', COUNT(*)) FROM legacy_patients
UNION ALL
SELECT 'new_patients', printf('%d', COUNT(*)) FROM new_patients;
EOF

    echo ""
    echo "🔍 DATA QUALITY ISSUES (Intentional for exercises):"
    sqlite3 healthcare.db <<EOF
.mode list
SELECT '   • Duplicate patients: ' || COUNT(*) FROM (
    SELECT first_name, last_name, dob FROM patients 
    GROUP BY first_name, last_name, dob HAVING COUNT(*) > 1
);
SELECT '   • Patients with missing SSN: ' || COUNT(*) FROM patients WHERE ssn IS NULL OR ssn = '';
SELECT '   • Legacy records with format issues: ' || COUNT(*) FROM legacy_patients;
EOF

else
    echo "❌ Database creation failed!"
    exit 1
fi

cd ..

# Step 3: Create a test query file for easy testing
cat > test_connection.sql <<EOF
-- Test query to verify SQLTools connection
-- Highlight this query and press Ctrl+E to run

SELECT 
    'Connection successful!' as status,
    COUNT(*) as total_patients 
FROM patients;
EOF

echo ""
echo "========================================="
echo "✅ SETUP COMPLETE!"
echo "========================================="
echo ""
echo "NEXT STEPS:"
echo "1. Click on 'Interview DB' in the SQLTools sidebar (database icon)"
echo "2. Open 'test_connection.sql' file"
echo "3. Highlight the query and press Ctrl+E to run"
echo ""