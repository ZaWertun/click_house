.PHONY: help

.BUNDLE_GEMFILE:=
.REQUIRE:=./spec/spec_helper

help:
	@echo 'Available targets:'
	@echo '  make dockerize OR make ARGS="--build" dockerize'
	@echo '  make release'

dockerize:
	docker compose up -d ${ARGS}

release:
	bin/release.sh

bundle:
	BUNDLE_GEMFILE=${.BUNDLE_GEMFILE} bundle

rspec:
	BUNDLE_GEMFILE=${.BUNDLE_GEMFILE} rspec --require ${.REQUIRE} spec

