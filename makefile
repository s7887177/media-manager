APP_NAME=mediam
VERSION=1.0.1
.PHONY: build
build: 
	@scripts/build.sh
pack: build
	@mkdir -p releases/${VERSION}
	@tar -czvf releases/${VERSION}/${APP_NAME}-${VERSION}.tar.gz dist
install: pack
	@cat scripts/install.sh | sh -s -- releases/${VERSION}/${APP_NAME}-${VERSION}.tar.gz