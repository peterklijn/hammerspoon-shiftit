test:
	find . -name "*_test.lua" | xargs sh -c 'lua $$0 -v'

ci-init:
	docker-compose -f .docker/docker-compose.ci.yaml build

ci-lint:
	docker-compose -f .docker/docker-compose.ci.yaml run hammerspoon-shiftit-ci luacheck --globals hs -- .

ci-test:
	docker-compose -f .docker/docker-compose.ci.yaml run hammerspoon-shiftit-ci make test

.PHONY: ci-init ci-lint
