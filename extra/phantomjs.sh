#!/bin/sh

set -e

echo "-----> Installing phantomjs."

BUILD_DIR=$1
CACHE_DIR=$2

# config
VERSION="2.0.0-20141016"

# Buildpack URL
ARCHIVE_NAME=phantomjs-${VERSION}
FILE_NAME=${ARCHIVE_NAME}-u1404-x86_64.zip
BUILDPACK_PHANTOMJS_PACKAGE=https://github.com/bprodoehl/phantomjs/releases/download/2.0.0-20141016/${FILE_NAME}
mkdir -p $CACHE_DIR
if ! [ -e $CACHE_DIR/$FILE_NAME ]; then
  echo "-----> Fetching PhantomJS ${VERSION} binaries at ${BUILDPACK_PHANTOMJS_PACKAGE}"
  curl $BUILDPACK_PHANTOMJS_PACKAGE --verbose -L -s -o $CACHE_DIR/$FILE_NAME
fi

echo "-----> Extracting PhantomJS ${VERSION} binaries to ${BUILD_DIR}/vendor/phantomjs"
mkdir -p $BUILD_DIR/vendor
cd $CACHE_DIR
unzip $FILE_NAME
mv $ARCHIVE_NAME $BUILD_DIR/vendor/phantomjs
chmod +x $BUILD_DIR/vendor/phantomjs/bin/phantomjs

echo "-----> exporting PATH and LIBRARY_PATH"
PROFILE_PATH="$BUILD_DIR/.profile.d/phantomjs.sh"
mkdir -p $(dirname $PROFILE_PATH)
echo 'export PATH="$PATH:vendor/phantomjs/bin"' >> $PROFILE_PATH
