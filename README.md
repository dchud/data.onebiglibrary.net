# data.onebiglibrary.net

Pelican-based data blog. Python 3.13+, Pelican 4.11+.

## Setup

```bash
pyenv install 3.13.12
uv sync
```

## Writing a new post

```bash
just new My Cool Post
```

This creates a directory under `content/posts/` using today's date and a
slugified title (e.g. `content/posts/20260224-my-cool-post/`) with a
templated `index.md` ready to edit. Date and slug are extracted from the
directory name automatically.

The resulting structure looks like:

```
content/posts/20260224-my-cool-post/
  index.md
  hero.jpg
  screenshots/
    screen1.png
```

`index.md` needs a title at minimum:

```markdown
Title: My Cool Post

Post content here.
```

## Adding media

Place images and data files alongside `index.md` and reference them with
`{attach}`:

```markdown
![screenshot]({attach}screenshots/screen1.png)
![chart]({attach}chart.png)
```

For posts with many screenshots, drop the images in the post directory and
run:

```bash
just images $(just latest)    # add markup for the latest draft
just images 20260225-my-post  # or specify a post slug directly
```

This appends `![name]({attach}filename)` lines for any images not already
referenced in the post.

`just latest` prints the slug of the most recent draft post.

For YouTube embeds, use an iframe directly in the markdown:

```html
<iframe width="560" height="315"
  src="https://www.youtube.com/embed/VIDEO_ID"
  frameborder="0" allowfullscreen></iframe>
```

## Building locally

```bash
just html          # generate the site
just serve         # serve at http://localhost:8000
just devserver     # serve with auto-reload
```

Pass extra pelican flags as needed: `just html -D` for debug mode.

## Deploying to Amplify

```bash
cp .env.example .env   # then fill in your AMPLIFY_APP_ID
just deploy            # builds with publishconf.py, then deploys to Amplify
```

Requires AWS CLI configured (`aws configure`) with Amplify permissions.

## Legacy content

All posts now use the `content/posts/YYYYMMDD-slug/` directory structure.
Two JSON data files remain at `content/data/` for legacy D3 visualizations
that reference them via hardcoded `/data/...` paths in inline JavaScript.
