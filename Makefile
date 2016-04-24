all: docs lint

docs:
	@MIX_ENV=docs mix docs

lint:
	@MIX_ENV=lint mix credo --strict

build:
	@mix compile --force

### PUBLISH

publish: publish-code publish-docs

publish-code: build
	@mix hex.publish

publish-docs: docs
	@MIX_ENV=docs mix hex.docs

### DEV

playground:
	@mix do clean, compile
	@iex -r test/playground.exs -S mix
.PHONY: playground

bench:
	@MIX_ENV=prod mix do clean, compile
	@MIX_ENV=prod mix bench -d 10
.PHONY: bench

dev-bench:
	@mix do clean, compile
	@mix bench -d 10
.PHONY: bench
