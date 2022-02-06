---
title: Using Makefile to Create Git Hook
toc: true
layout: post
categories: [technical]
author: Hiromi Suenaga
hide: false
---

In the [previous post](https://blog.problemsolversguild.com/technical/2022/02/05/GitHook_to_clean_notebook.html), we created a Git Hook that will stirip all the superfluous metadata automatically when you commit notebooks. We wanted to make the installation of this hook easier by creating a Makefile target.

Here is what we came up with: 

```bash
SHELL := /bin/bash

.PHONY: hook
hook: 
	@echo -e '#!/bin/sh\nfor file in $$(git diff --diff-filter=d --cached --name-only | grep -E '"'"'\.ipynb$$'"'"')\ndo\n\tjupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace "$$file"\n\tgit add "$$file"\ndone\n'  > .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
```
[[Download]('https://blog.problemsolversguild.com/assets/Makefile')]

Run `make hook` and Voila! You have your Git Hook that will reduce merge conflicts headaches.

---

## My web searches while creating this Makefile

### How to convert multiline file into a string with newline `\n` characters:
```bash
awk '$1=$1' ORS='\\n' file
```
>This is how I converted an existing hook file into a single string. I had to add tabs (`\t`) manually, but this `awk` got me close enough. 

<br />

### How to write a multiline file with `echo`:
```bash
echo -e "Line 1\r\nLine2" >> readme.txt
```

<br />

### How to escape single quotes in single quoted strings:
 `'"'"'` is interpreted as `'`

<br />

### How to escape dollar signs `$` in Makefile:
Escape `$` by adding another `$` (i.e. `$$`)

<br />

### References
- [https://stackoverflow.com/a/26451573](https://stackoverflow.com/a/26451573)
- [https://unix.stackexchange.com/a/219270](https://unix.stackexchange.com/a/219270)
- [https://stackoverflow.com/a/1250279](https://stackoverflow.com/a/1250279)  
- [https://til.hashrocket.com/posts/k3kjqxtppx-escape-dollar-sign-on-makefiles](https://til.hashrocket.com/posts/k3kjqxtppx-escape-dollar-sign-on-makefiles)
   