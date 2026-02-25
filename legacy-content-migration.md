# Legacy Content Migration Plan

Migrate the 7 legacy flat markdown files in `content/` to the
`content/posts/YYYYMMDD-slug/index.md` directory structure, moving
associated media alongside each post.

## Guiding Principles

- Published URLs must not change. Pelican derives URLs from article
  metadata (date + slug), not file paths, so reorganizing files is safe.
- Each post should be self-contained: `index.md` plus any media it
  references, all in one directory.
- Image references change from `{static}images/...` to `{attach}...`
  (relative to `index.md`).
- Shared images get duplicated into each post that uses them. The files
  are small PNGs and duplication keeps posts independent.
- Data files referenced by hardcoded `/data/...` paths in inline
  JavaScript need special handling (see below).

## Posts by Complexity

### Tier 1: No media (just move + wrap in directory)

These three posts use only inline D3 code and have no local file
references.

1. **`20140808-simple-color-relationships.md`**
   - Move to `posts/20140808-simple-color-relationships/index.md`

2. **`20140904-albers-color-studies-part-2.md`**
   - Move to `posts/20140904-albers-color-studies-part-2/index.md`

3. **`20141018-animating-regression-part-2.md`**
   - Move to `posts/20141018-animating-regression-part-2/index.md`

### Tier 2: Local images only

4. **`20140812-things-to-know-about-data-science.md`**
   - Move to `posts/20140812-things-to-know-about-data-science/index.md`
   - Copy the 6 referenced files from `images/20140812-things/` into the
     post directory (flatten — no subdirectory needed). Note:
     `b3-simple-regression-residuals-a.png` also exists in that directory
     but is not referenced by any post — skip it.
   - Update 6 image references:
     - `{static}images/20140812-things/csvlook.png` → `{attach}csvlook.png`
     - `{static}images/20140812-things/b3-simple-regression-table.png` → `{attach}b3-simple-regression-table.png`
     - `{static}images/20140812-things/b3-simple-regression-plot.png` → `{attach}b3-simple-regression-plot.png`
     - `{static}images/20140812-things/b3-simple-regression-diag.png` → `{attach}b3-simple-regression-diag.png`
     - `{static}images/20140812-things/b3-simple-regression-residuals-b.png` → `{attach}b3-simple-regression-residuals-b.png`
     - `{static}images/20140812-things/ts-decomp.png` → `{attach}ts-decomp.png`
   - Note: also references 4 external image URLs (squarespace, theorsociety,
     morganfranklin, mu-sigma). Several of these are likely dead. Consider
     replacing with local copies or removing if the images are gone.

5. **`20140918-animating-regression.md`**
   - Move to `posts/20140918-animating-regression/index.md`
   - Copy 2 files from `images/20140812-things/` into the post directory:
     - `b3-simple-regression-plot.png`
     - `b3-simple-regression-diag.png`
   - Update 2 image references:
     - `{static}images/20140812-things/b3-simple-regression-plot.png` → `{attach}b3-simple-regression-plot.png`
     - `{static}images/20140812-things/b3-simple-regression-diag.png` → `{attach}b3-simple-regression-diag.png`

6. **`20141112-animated-anscombe-quartet-regression-diagnostics.md`**
   - Move to `posts/20141112-animated-anscombe-quartet-regression-diagnostics/index.md`
   - Copy `images/20141112-anscombe-error.png` into the post directory
   - Update 1 image reference:
     - `{static}images/20141112-anscombe-error.png` → `{attach}20141112-anscombe-error.png`
   - Also has a data file — see Tier 3

### Tier 3: Data files loaded by JavaScript

Two posts load JSON files via `d3.json("/data/...")` in inline
`<script>` blocks. Pelican's `{attach}` syntax doesn't work inside
JavaScript, so we can't simply move these files next to `index.md` and
use a relative reference.

**Options (pick one):**

**Option A: Keep `/data/` as a shared static directory (recommended)**

Leave `content/data/` in place. Pelican copies it to `output/data/`
and the hardcoded `/data/...` paths in the JavaScript continue to work.
This is the simplest approach — no code changes needed.

- `20141001-years-worth-of-dots.md` uses `/data/20141001-filecounts.json`
- `20141112-animated-anscombe-quartet-regression-diagnostics.md` uses
  `/data/20141112-animating-anscombe.json`

**Option B: Move data files and update JS paths**

Move each JSON file into its post directory and change the `d3.json()`
calls to use a path relative to the article URL. For example, in the
`years-worth-of-dots` post (published at `/2014/10/01/years-worth-of-dots/`),
you'd use `{attach}` to get Pelican to copy the file, but the JS path
would need to be the final output path. This is fragile and couples the
JS to Pelican's URL scheme. Not recommended.

**Option C: Move data files and use a Pelican template variable**

Embed the data file path using a Jinja2 expression in the inline JS.
This only works if the JS is in the markdown content and Pelican
processes it (it doesn't — markdown content is not Jinja2-templated).
Not viable.

**Recommendation:** Go with Option A. The `/data/` directory stays put,
the two posts that reference it continue to work, and the rest of the
migration proceeds cleanly.

7. **`20141001-years-worth-of-dots.md`**
   - Move to `posts/20141001-years-worth-of-dots/index.md`
   - No local image references
   - Keep `content/data/20141001-filecounts.json` in place (Option A)

8. **`20141112-animated-anscombe-quartet-regression-diagnostics.md`**
   (also listed in Tier 2 for its image)
   - Move to `posts/20141112-animated-anscombe-quartet-regression-diagnostics/index.md`
   - Copy image as noted in Tier 2
   - Keep `content/data/20141112-animating-anscombe.json` in place (Option A)

## Execution Order

1. Create all 7 post directories under `content/posts/`
2. Move each `.md` file to its directory as `index.md`
3. Copy referenced images into the appropriate post directories
4. Update `{static}images/...` → `{attach}...` in each post
5. Build and verify: `just html` — confirm no warnings or broken references
6. Spot-check each post in the browser with `just devserver`
7. Verify published URLs haven't changed by comparing `output/` structure
8. Delete `content/images/` (the moved files plus the unreferenced
   `b3-simple-regression-residuals-a.png`)
9. Keep `content/data/` as-is (Option A)
10. Update `pelicanconf.py`: remove `'images'` from `STATIC_PATHS` and
    `''` from `ARTICLE_PATHS` (no articles remain at the content root)

## Verification Checklist

- [ ] All 7 articles appear in the site index
- [ ] Each article's URL is unchanged
- [ ] All local images render correctly
- [ ] D3 visualizations load their JSON data and render
- [ ] Atom feeds validate and include all articles
- [ ] No Pelican build warnings about missing files
