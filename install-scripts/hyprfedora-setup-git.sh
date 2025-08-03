#!/bin/bash
# Configures Git globally and creates a standard .gitignore

# Source color/status variables
source "$(dirname "${BASH_SOURCE[0]}")/Global_functions.sh"

# Verify required env vars are present
if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" ]]; then
    echo "${ERROR} GIT_NAME or GIT_EMAIL is not set. Exiting."
    exit 1
fi

# Apply Git configuration
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
echo "${OK} Git user.name and user.email configured"

# Create a global .gitignore with best practices
cat > ~/.gitignore_global <<EOF
# Compiled source files
*.class
*.o
*.so
*.out

# Packages and archives
*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip

# Logs and databases
*.log
*.sql
*.sqlite

# OS generated files
.DS_Store
Thumbs.db

# Node, Python, Rust
node_modules/
__pycache__/
*.py[cod]
target/

# Editors
*.swp
*.swo
.vscode/
.idea/
EOF

git config --global core.excludesfile ~/.gitignore_global
echo "${OK} Global .gitignore created and configured"

