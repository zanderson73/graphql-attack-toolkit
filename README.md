# GraphQL Red Team Toolkit

An all-in-one command-line toolkit for performing **GraphQL enumeration and exploitation**, including:

- SQL Injection (SQLi)
- SS Reflection Testing
- IDOR Enumeration
- Column/Table Extraction
- GraphQL-specific query automation

---

## Toolkit Contents

| Script Name                         | Purpose                                |
|--------------------------------------|----------------------------------------|
| `graphql_attack_toolkit.sh`          | Main interactive launcher menu         |
| `graphql_enum_schema.sh`             | Perform introspection on GraphQL schema |
| `graphql_fuzz_fields.sh`             | Fuzz GraphQL fields for unauthenticated access |
| `graphql_sqli_exfil.sh`              | SQL injection-based data exfiltration  |
| `graphql_injection_test_enhanced.sh` | Test for SQLi and XSS vulnerabilities   |

---

## Setup

Clone the repository:
```bash
git clone https://github.com/zanderson73/graphql-attack-toolkit.git
cd graphql-attack-toolkit


# Make the scripts executable:

chmod +x *.sh

# Run the main launcher script:

./graphql_attack_toolkit.sh

#Dependencies

curl for making HTTP requests
jq for JSON parsing

bash (preferred) for running the scripts

# Menu Options
# SQLi Column Extractor
# Get column names from a target table.

[+] Enter GraphQL endpoint URL: http://target/graphql
[+] Enter table name to extract columns from: users

# Expected Output:

[+] Column names for "users": id, username, password

# SQLi Data Exfiltrator
# Dump real values using column names.

[+] Enter GraphQL endpoint URL: http://target/graphql
[+] Enter table name to extract from: users
[+] Enter comma-separated column names: id,username,password

# Expected Output:

[+] Extracted data from "users":
id: 1, username: admin, password: password123

# XSS/SQLi Recon Scanner
# Launch pre-defined SQLi and XSS payloads and analyze backend behavior.

[+] Enter GraphQL endpoint URL: http://target/graphql

# Sample Commands (Standalone Use)

# Dump table names
./graphql_sqli_exfil.sh http://target/graphql information_schema.tables table_name

# Dump columns from "flag" table
./graphql_get_columns.sh http://target/graphql flag

# Dump flag column data
./graphql_sqli_exfil.sh http://target/graphql flag flag


👤 Author
Zane Anderson
Red Team Toolkit Builder
Contact: zanderson@iscsecurity.org

# For educational and ethical penetration testing purposes only.


This `README.md` includes all the necessary sections: overview, toolkit contents, setup instructions, script usage, and example commands.

You can copy this into the `README.md` file in your project folder, and it should be ready for GitHub. Once you're set, you can proceed with uploading the whole toolkit to your GitHub repository. Let me know if you need further help!
