ci-init:
	docker-compose -f .docker/docker-compose.ci.yaml build

ci-lint:
	docker-compose -f .docker/docker-compose.ci.yaml run hammerspoon-shiftit-ci luacheck --globals hs -- hammerspoon-shifit/

.PHONY: ci-init ci-lint
