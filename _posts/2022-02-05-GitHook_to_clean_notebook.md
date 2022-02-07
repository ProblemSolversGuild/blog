---
title: Using Git Hook to Clean Jupyter Notebook on Commit
toc: true
layout: post
categories: [technical]
author: Hiromi Suenaga
hide: false
---


To avoid merge issues and make PR review easier, we wanted a [Git Hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) which will:
- Clear output of Jupyter Notebook
- Only clean the files that were modified for this PR


There are many hook samples in `.git/hooks` folder. You want to create a file called `pre-commit` with the following code:
    
```bash
#!/bin/sh
for file in $(git diff --diff-filter=d --cached --name-only | grep -E 'customers/.+\.ipynb$')
do
    jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace "$file"
    git add "$file"
done

```
[[Download]('https://blog.problemsolversguild.com/assets/files/pre-commit')]

Run `chmod +x pre-commit` to make the file executable.

That's it!

In the next post, we will show you how to create this Git Hook with Makefile.

<br />

---

If the above code gives you the following error:
```
[NbConvertApp] WARNING | Config option `template_path` not recognized by `NotebookExporter`.
```

You need to run `pip install -U nbconvert` to get a newer version (https://github.com/jupyter/nbconvert/issues/1229#issuecomment-608721332).

