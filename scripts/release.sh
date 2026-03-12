set -e
APP_NAME=mediam
VERSION=1.0.1
TAG="v${VERSION}"
TARBALL_PATH="${PWD}/releases/$VERSION/${APP_NAME}-${VERSION}.tar.gz"
INSTALL_SCRIPT_PATH="${PWD}/scripts/install.sh"
if gh release view "$TAG" >/dev/null 2>&1; then
  gh release delete "$TAG" --yes
fi
gh release create -t "" -n "" -p "$TAG" "$TARBALL_PATH" "$INSTALL_SCRIPT_PATH"