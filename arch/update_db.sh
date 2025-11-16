#!/bin/bash

# Check for new updates and add them to the pacman DB.

if [ $# -lt 3 ]; then
    echo "USAGE: watch.sh <DB_FILE> <PKGS_DIR> <REMOTE>"
    exit 1
fi

db="$(realpath "$1")"
pkgs_dir="$(realpath "$2")"
remote="$3"

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

    # Store previous packages and signatures.
    old_pkgs=(./*.pkg.tar.xz)
    old_sigs=(./*.sig)

    # Build package.
    cd "$pkg_dir"
    makepkg -sCc --sign --noconfirm
    exit_code=$?

    # Ignore if package didn't update.
    if [ $exit_code -eq 13 ]; then
        echo "No changes found"
        continue
    elif [ $exit_code -ne 0 ]; then
        echo "Package build failed"
        exit 2
    fi

    # Remove old packages and signatures.
    rm "${old_pkgs[@]}"
    rm "${old_sigs[@]}"

    # Add package(s) and signatures to database.
    for pkg in ./*.pkg.tar.xz; do
        cp "$pkg" "$(dirname "$db")/"
        repo-add -Rs "$db" "$pkg"
    done
    cp ./*.sig "$(dirname "$db")/"

    echo "Updated database"
done

# Update database at christianduerr.com.
rsync -Phav --delete "$(dirname "$db")" "$remote"
