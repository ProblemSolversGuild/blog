SHELL := /bin/bash

.PHONY: hook
hook: 
	@echo -e '#!/bin/sh\nfor file in $$(git diff --diff-filter=d --cached --name-only | grep -E '"'"'\.ipynb$$'"'"')\ndo\n\tjupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace "$$file"\n\tgit add "$$file"\ndone\n'  > .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
