#!/bin/sh
set -e

APP_NAME="mediam"
VERSION="1.0.1"
TAG="v${VERSION}"
TARBALL_NAME="${APP_NAME}-${VERSION}.tar.gz"
GIT_RELEASE_PATH="https://github.com/s7887177/media-manager/releases/download/${TAG}/${TARBALL_NAME}"

TEMP_DIST_FOLDER_PATH="/tmp/${APP_NAME}/dist"
TEMP_TARBALL_DIRPATH="/tmp/${APP_NAME}/releases/${VERSION}"
TEMP_TARBALL_PATH="${TEMP_TARBALL_DIRPATH}/${TARBALL_NAME}"

INSTALL_DIR="$HOME/.local/share/$APP_NAME"
BIN_PATH="$HOME/.local/bin/$APP_NAME"
PACKAGE_ENV_PATH="$INSTALL_DIR/package.env"

install_from_network() {
  echo "Installing from network..."
  rm -rf "$TEMP_TARBALL_PATH"
  echo "Downloading from ${GIT_RELEASE_PATH} to ${TEMP_TARBALL_PATH}"
  wget -qO "$TEMP_TARBALL_PATH" "$GIT_RELEASE_PATH"
  TARBALL_PATH="$TEMP_TARBALL_PATH"
  try_install_from_tarball
}

try_fill_tarball_path() {
  # Assume $1 is *.tar.gz
  ## check if $1 is file and valid .tar.gz
  if [ ! -f $1 ]; then
    echo "$1 doesn't existed"
    exit 1
  fi
  TARBALL_PATH=$1
}
extract_tarball() {
  # Assume $TARBALL_PATH is an existed tarball file
  rm -rf $TEMP_DIST_FOLDER_PATH
  mkdir -p $TEMP_DIST_FOLDER_PATH
  DIST_FOLDER_PATH=$TEMP_DIST_FOLDER_PATH
  echo "Extracting from ${TARBALL_PATH} to ${DIST_FOLDER_PATH}"
  tar -xzvf $TARBALL_PATH -C $DIST_FOLDER_PATH --strip-component 1  | awk '{print "\033[90m" "- " $0 "\033[0m"}'
}
try_install_from_tarball() {
  # Assume $TARBALL_PATH is an existed tarball file
  echo "Installing from tarball: $TARBALL_PATH"
  extract_tarball
  try_install_from_dist_folder
}
try_fill_dist_folder_path() {
  # Assume $1 is not empty
  # test if $1 is an existed folder
  if [ ! -d $1 ]; then
    echo "$1 is not a folder or no existed."
    exit 1
  fi
  DIST_FOLDER_PATH=$1
}
try_install_from_dist_folder() {
  # Assume DIST_FOLDER_PATH is filled and it's an existed folder
  echo "Installing from folder: $DIST_FOLDER_PATH to $INSTALL_DIR and $BIN_PATH"
  rm -rf $INSTALL_DIR
  cp -r $DIST_FOLDER_PATH $INSTALL_DIR
  ln -sf $INSTALL_DIR/run $BIN_PATH
  echo "INSTALL_DIR=\"$HOME/.local/share/$APP_NAME\"" >$PACKAGE_ENV_PATH
  echo "BIN_PATH=\"$HOME/.local/bin/$APP_NAME\"" >>$PACKAGE_ENV_PATH
  $APP_NAME up
  # cp from dist folder path to
}

handle_args_1() {
  case "$1" in
  "")
    install_from_network
    ;;
  *.tar.gz)
    try_fill_tarball_path $1
    try_install_from_tarball
    ;;
  *)
    try_fill_dist_folder_path $1
    try_install_from_folder
    ;;
  esac
}

check_installed() {
  if [ -f $BIN_PATH ]; then
    echo "$APP_NAME is installed in $BIN_PATH"
    $APP_NAME uninstall
  fi
}

main() {
  # check if mediam is installed
  check_installed
  # check if mediam is running
  handle_args_1 $1
}

main $1
