all:
	@echo "Nothing to do."

playground:
	@mix do clean, compile
	@iex -r test/playground.exs -S mix
.PHONY: playground

bench:
	@MIX_ENV=prod mix do clean, compile
	@MIX_ENV=prod mix bench -d 5
.PHONY: bench

dev-bench:
	@mix do clean, compile
	@mix bench -d 10
.PHONY: bench
