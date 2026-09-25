# Problem Solvers Guild Blog

Quarto site published at [blog.problemsolversguild.com](https://blog.problemsolversguild.com).

Posts are markdown files and Jupyter notebooks in `posts/`. Notebook outputs are rendered on your machine and committed. The site build does not re-run them.

## Write and publish

Install [Quarto](https://quarto.org/docs/get-started/) 1.10.18.

```bash
quarto preview
quarto render
```

`quarto render` writes HTML to `docs/`. Commit that folder and push `main`. Cloudflare Pages serves `docs/` with no build command.

`posts/_metadata.yml` sets `freeze: true`. Frozen execution results are not committed, so do not run `quarto render` in CI. A notebook that needs a new output should be executed locally before the render.

## Hosting

This repository is a Cloudflare Pages project, separate from the homepage.

| Setting | Value |
| --- | --- |
| Production branch | `main` |
| Build command | none |
| Build output directory | `docs` |

Preview on the project's `*.pages.dev` URL before changing DNS. `blog.problemsolversguild.com` currently points at GitHub Pages, and `CNAME` is copied into `docs/` on render so that hostname stays attached. Leave that file in place until the hostname is moved to the Cloudflare Pages project. After the preview matches this site, point the hostname at the Pages project and attach it there, then remove `CNAME`. Cloudflare renews the certificate.
