### **`exercises/03_migration.md`**

# Exercise 3: Data Migration

## Scenario
You need to migrate data from `legacy_patients` to `new_patients` table.

## Challenges to Address:
1. Date formats are inconsistent in `birth_date`
2. Phone formats need standardization
3. Stage values need conversion (1,2,3,4 → I,II,III,IV)
4. Some records have missing or invalid MRNs

## Task
Write a migration script that:
1. Transforms the data appropriately
2. Handles the format inconsistencies
3. Creates audit log entries for any failures

## Available Tables:
- `legacy_patients`: Source data
- `new_patients`: Target table
- `migration_audit`: For logging issues

## Write your migration script:
