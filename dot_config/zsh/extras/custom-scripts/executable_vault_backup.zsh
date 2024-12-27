#!/usr/bin/env zsh

vault_backup() {
    git add .
    git commit -m "Vault Backup: $(date '+%Y-%m-%d %H:%M:%S')"
    git pull
    git push
}
