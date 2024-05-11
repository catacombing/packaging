#!/bin/bash

# Check for new updates and add them to the pacman DB.

if [ $# -lt 2 ]; then
    echo "USAGE: watch.sh <DB_FILE> <PKGS_DIR>"
    exit 1
fi

db="$(realpath $1)"
pkgs_dir="$(realpath $2)"

# Revert changes to PKGBUILD versions.
cd "$pkgs_dir"
git reset --hard

# Update package manifests.
git pull origin master || (echo "Failed git update"; exit 1)

echo "Checking for updates in $pkgs_dir…"

for file in $(ls $pkgs_dir); do
    # Skip directories without PKGBUILD.
    pkg_dir="$pkgs_dir/$file"
    if [ ! -f "$pkg_dir/PKGBUILD" ]; then
        continue
    fi

    echo "Checking $pkg_dir…"

    # Build package.
    cd "$pkg_dir"
    makepkg -sCc --noconfirm
    exit_code=$?

    # Ignore if package didn't update.
    if [ $exit_code -eq 13 ]; then
        echo "No changes found"
        continue
    elif [ $exit_code -ne 0 ]; then
        echo "Package build failed"
        exit 2
    fi

    # Add package to database.
    pkg=$(ls --sort=time *.pkg.tar.* | head -n 1)
    cp "$pkg" "$(dirname $db)/"
    repo-add "$db" *.pkg.tar.*

    # Delete old versions from repo.
    for file in *.pkg.tar.*; do
        if [ "$file" != "$pkg" ]; then
    	echo "Removing $file from repo"
            rm -f "$file"
        fi
    done

    echo "Updated database"
done
