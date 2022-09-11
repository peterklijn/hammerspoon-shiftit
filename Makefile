test:
	find . -name "*_test.lua" | xargs sh -c 'lua $$0 -v'

ci-init:
	docker-compose -f .docker/docker-compose.ci.yaml build

ci-lint:
	docker-compose -f .docker/docker-compose.ci.yaml run hammerspoon-shiftit-ci luacheck --globals hs -- .

ci-test:
	docker-compose -f .docker/docker-compose.ci.yaml run hammerspoon-shiftit-ci make test

package:
	rm -rf Spoons
	mkdir -p Spoons/ShiftIt.spoon
	cp init.lua Spoons/ShiftIt.spoon/init.lua
	(cd Spoons && zip -r ShiftIt.spoon.zip ShiftIt.spoon)
	rm -r Spoons/ShiftIt.spoon

.PHONY: ci-init ci-lint ci-test package
