# data.onebiglibrary.net

Pelican-based data blog. Python 3.13+, Pelican 4.11+.

## Setup

```bash
pyenv install 3.13.12
uv venv && uv pip install -e .
# or: uv pip install 'pelican[markdown]>=4.11' pelican-sitemap s3cmd
```

## Writing a new post

Create a directory under `content/posts/` with the naming convention
`YYYYMMDD-slug/`:

```
content/posts/20260224-my-new-post/
  index.md
  hero.jpg
  screenshots/
    screen1.png
```

`index.md` needs a title at minimum:

```markdown
Title: My new post

Post content here.
```

Date and slug are extracted from the directory name automatically.

## Adding media

Place images and data files alongside `index.md` and reference them with
`{attach}`:

```markdown
![screenshot]({attach}screenshots/screen1.png)
![chart]({attach}chart.png)
```

For YouTube embeds, use an iframe directly in the markdown:

```html
<iframe width="560" height="315"
  src="https://www.youtube.com/embed/VIDEO_ID"
  frameborder="0" allowfullscreen></iframe>
```

## Building locally

```bash
make html          # generate the site
make serve         # serve at http://localhost:8000
make devserver     # serve with auto-reload
```

## Deploying to S3

```bash
make s3_upload     # builds with publishconf.py, then syncs to S3
```

Requires s3cmd credentials configured separately (`s3cmd --configure`).

## Legacy content

Old flat articles in `content/` (e.g. `content/20140812-my-post.md`) still
work. New posts should use the `content/posts/` directory structure.
