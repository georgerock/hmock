watch:
	@ghcid --command="stack ghci"

build:
	@stack build

format:
	@find . -path ./.stack-work -prune -o -type f -name "*.hs" \! -regex "^\.stack" -exec hindent {} \;

clean:
	@stack clean

repl:
	@stack repl