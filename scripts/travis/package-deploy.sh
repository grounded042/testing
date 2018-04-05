#!/bin/bash

DEPLOY_STAGING_DIR=./deploy-staging
VERSION="$(make echo-version | awk 'match($0, /([0-9]*\.[0-9]*\.[0-9]*)$/) { print substr($0, RSTART, RLENGTH) }')"

# stage-file copies the file $1 with the specified path $2 at /deploy-staging/$2
# if no file exists it will silently continue
function stage-file {
    if [ -f $1 ]; then
        local new_path=$DEPLOY_STAGING_DIR/$2
        echo "Copying $1 to $new_path"
        cp $1 $new_path
    else
        echo "$1 does not exist. Continuing on."
    fi
}

# make needed directories
mkdir deploy
mkdir $DEPLOY_STAGING_DIR
mkdir deploy-staging/darwin
mkdir deploy-staging/windows

# package linux
LINUX_STAGING_DIR=$DEPLOY_STAGING_DIR/linux
mkdir $LINUX_STAGING_DIR
stage-file ./cmd/agent/agent-linux linux/jaeger-agent
stage-file ./cmd/collector/collector-linux linux/jaeger-collector

LINUX_PACKAGE_FILES=$(echo $LINUX_STAGING_DIR/*)

if [ ${#LINUX_PACKAGE_FILES} -gt 0 ]; then
    LINUX_ARCHIVE_NAME="jaeger-"$VERSION"-darwin-amd64.tar.gz"
    echo "Packaging the following files into $LINUX_ARCHIVE_NAME:"
    echo $LINUX_PACKAGE_FILES
    tar -czvf ./deploy/$LINUX_ARCHIVE_NAME $LINUX_PACKAGE_FILES
else
    echo "Will not package or deploy linux files as there are no files to package!"
fi

# package darwin
DARWIN_STAGING_DIR=$DEPLOY_STAGING_DIR/darwin
mkdir $DARWIN_STAGING_DIR
stage-file ./cmd/agent/agent-darwin darwin/jaeger-agent
stage-file ./cmd/collector/collector-darwin darwin/jaeger-collector

DARWIN_PACKAGE_FILES=$(echo $DARWIN_STAGING_DIR/*)

if [ ${#DARWIN_PACKAGE_FILES} -gt 0 ]; then
    DARWIN_ARCHIVE_NAME="jaeger-"$VERSION"-darwin-amd64.tar.gz"
    echo "Packaging the following files into $DARWIN_ARCHIVE_NAME:"
    echo $DARWIN_PACKAGE_FILES
    tar -czvf ./deploy/$DARWIN_ARCHIVE_NAME $DARWIN_PACKAGE_FILES
else
    echo "Will not package or deploy darwin files as there are no files to package!"
fi

# package windows
WINDOWS_STAGING_DIR=$DEPLOY_STAGING_DIR/windows
mkdir $WINDOWS_STAGING_DIR
stage-file ./cmd/agent/agent-windows windows/jaeger-agent.exe
stage-file ./cmd/collector/collector-windows windows/jaeger-collector.exe

WINDOWS_PACKAGE_FILES=$(echo $WINDOWS_STAGING_DIR/*)

if [ ${#WINDOWS_PACKAGE_FILES} -gt 0 ]; then
    WINDOWS_ARCHIVE_NAME="jaeger-"$VERSION"-windows-amd64.tar.gz"
    echo "Packaging the following files into $WINDOWS_ARCHIVE_NAME:"
    echo $WINDOWS_PACKAGE_FILES
    tar -czvf ./deploy/$WINDOWS_ARCHIVE_NAME $WINDOWS_PACKAGE_FILES
else
    echo "Will not package or deploy darwin files as there are no files to package!"
fi
