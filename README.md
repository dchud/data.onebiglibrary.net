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

Old flat articles in `content/` (e.g. `content/20140812-my-post.md`) still
work. New posts should use the `content/posts/` directory structure.
