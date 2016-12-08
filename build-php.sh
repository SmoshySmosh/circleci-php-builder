#!/bin/sh
# Detect Architecture
SYSTEM_ARCHITECTURE=$(dpkg --print-architecture)

# Define Package Name
PACKAGE_NAME="circleci-phpenv-php-$PHP_VERSION-$SYSTEM_ARCHITECTURE"

# Define Package Folder
PACKAGE_FOLDER="$HOME/build/$PACKAGE_NAME"

# Define PHPENV Versions location
PHPENV_VERSION_FOLDER="$HOME/.phpenv/versions"

# Define CircleCI PHPENV Versions Folder
CIRCLE_PHPENV_FOLDER="/opt/circleci/php"

# Enable PEAR
BUILD_CONFIG="$HOME/.phpenv/plugins/php-build/share/php-build/default_configure_options"
tail -n +2 "$BUILD_CONFIG" > "$BUILD_CONFIG.tmp" && mv "$BUILD_CONFIG.tmp" "$BUILD_CONFIG"

# Install PHP Version
phpenv install $PHP_VERSION

# Make directory for package
mkdir $PACKAGE_FOLDER

# Make directory for files
mkdir -p $PACKAGE_FOLDER$CIRCLE_PHPENV_FOLDER

# Copy php to package
cp -R $PHPENV_VERSION_FOLDER/$PHP_VERSION $PACKAGE_FOLDER$CIRCLE_PHPENV_FOLDER/

# Make control folder
mkdir -p $PACKAGE_FOLDER/DEBIAN

# Make control file
cat <<EOF > $PACKAGE_FOLDER/DEBIAN/control
Package: $PACKAGE_NAME
Version: $PHP_VERSION
Section: devel
Installed-Size: $(du -s | cut -f1)
Priority: extra
Architecture: $SYSTEM_ARCHITECTURE
Maintainer: Ethan Pursley <ethan.k.pursley@gmail.com>
Description: PHP $PHP_VERSION package for Circle CI (Builder Version 14.04)
EOF

# Generate md5sums
find $PACKAGE_FOLDER -path '*/DEBIAN' -prune -o -type f -exec md5sum {} \; | awk '{ print $1 "  " substr($2, 53) }' > $PACKAGE_FOLDER/DEBIAN/md5sums

# Make DEB Package
dpkg-deb --build $PACKAGE_FOLDER $PACKAGE_FOLDER.deb

# Remove Temporary Folder
rm -rf $PACKAGE_FOLDER
