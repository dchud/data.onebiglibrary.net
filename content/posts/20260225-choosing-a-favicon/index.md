Title:      Choosing a Favicon
Tags:       design, meta
Status:     published

This [Pelican](https://getpelican.com/) blog has sat still since about 2014.
I used to publish it to an S3 bucket with static hosting turned on. I've been
thinking about establishing a new place to write lately, then remembered this
was already here, and the domain kinda covers my professional interests still,
so I went with it. But retconning it into contemporary versions of things wasn't
a straightforward task. Not an overwhelmingly hard task, or very large, but it
was a bunch of stuff that had to change a little all at once.

Then there's Claude.

I'm not going to go on about Claude itself a lot, there are plenty of people
doing that already. But suffice it to say that while I'm not employed
I have a lot of time on my hands and a lot of experience managing
software teams. Tools this good - at least in terms of performance
in building software systems, setting aside the much bigger questions
at play - are really still brand-spanking new. They weren't this
good more than three months ago. They just let me build pretty much
whatever I feel like building, as if I had my own team that works
really quickly and lets me operate in the plan/scope/refine/review
mode I've been in professionally for a while now.

So while I have this time available and this ridiculous toolkit and
before it all crumbles somehow or the prices go sky-high (both of
which will probably happen sooner than we expect) and I have a bunch of ideas of
stuff to build, I'm building stuff.

Fiddly tiny blog migration project? I know a thing that will help me get that
done a lot faster than I could myself. It created [this pull
request](https://github.com/dchud/data.onebiglibrary.net/pull/1) to modernize
the environment, and [this pull
request](https://github.com/dchud/data.onebiglibrary.net/pull/2) to retcon old
posts into the new structure. It coached me on getting migrated to a new hosting
platform and updating DNS. Darned thing just worked, dang it all.

I was testing the retconned content and noticed a warning about lacking
a favicon. What to do? I asked for proposals. Thoughtfully it reached into my
older content and came up with good ideas, so I asked it to draft the rest of
this post for content.

I went with "four patch grid" because it looked best as a favicon,
and there was something familiar about it, beyond just the color
choices (see Albers color study posts from 2014). Took a few minutes
to figure it out, but it's basically the same design as the old
[del.icio.us icon](https://en.wikipedia.org/wiki/Delicious_(website)),
just with the Albers study colors taken from those prior posts.
Seemed like a good fit. I don't know if joshu is still out there, but I hope
he's been good, and I hope he doesn't mind.

Everything below this sentence was bot-generated.

## The Brief

The site needed a favicon. Given that so much of the early content here
is built around Josef Albers' color studies rendered in D3, it made
sense to draw from that same visual language: simple geometric shapes,
deliberate color choices, and the interplay between them.

The constraint is severe. A favicon lives at 16x16 or 32x32 pixels.
Whatever we choose has to read clearly at those sizes, in a browser tab
alongside a dozen others, often against both light and dark chrome. That
rules out anything with fine detail or subtle gradation. What survives
is flat color and strong shape.

With that in mind, here were four candidates, each inspired by a
different Albers study from the earlier posts.


## Option 1: Nested Squares

<img src="{attach}favicon-nested.svg" width="128" height="128" alt="nested squares at 128px" /> <img src="{attach}favicon-nested.svg" width="64" height="64" alt="nested squares at 64px" /> <img src="{attach}favicon-nested.svg" width="32" height="32" alt="nested squares at 32px" /> <img src="{attach}favicon-nested.svg" width="16" height="16" alt="nested squares at 16px" />

Three concentric squares: deep purple, red-orange, yellow. This echoes
the very first Albers exercise on the site —
[placing one color inside another]({filename}/posts/20140808-simple-color-relationships/index.md)
to see how the surround changes your perception of the inner
color. The nesting reads well at small sizes because the contrast
between the three layers is high. At 16px the innermost square is
only a few pixels across, but the warm-to-cool progression still
registers.


## Option 2: Offset Overlap

<img src="{attach}favicon-overlap.svg" width="128" height="128" alt="offset overlap at 128px" /> <img src="{attach}favicon-overlap.svg" width="64" height="64" alt="offset overlap at 64px" /> <img src="{attach}favicon-overlap.svg" width="32" height="32" alt="offset overlap at 32px" /> <img src="{attach}favicon-overlap.svg" width="16" height="16" alt="offset overlap at 16px" />

Two overlapping rectangles — teal and yellow — with a mint intersection
zone. This one references the
[transparency and optical mixture studies]({filename}/posts/20140808-simple-color-relationships/index.md),
where Albers demonstrated that you can simulate the appearance of
overlapping translucent layers using nothing but flat, opaque color.
The intersection is the key: it's a third color that your eye reads
as the blend of the other two, even though it's just a solid fill.

At 128px this tells the richest story of any of the options. At 16px
the three-zone structure starts to muddy — the intersection becomes
hard to distinguish from its neighbors, and the asymmetric layout
loses its spatial logic. The idea is stronger than its execution at
favicon scale.


## Option 3: Four-Patch Grid

<img src="{attach}favicon-grid.svg" width="128" height="128" alt="four-patch grid at 128px" /> <img src="{attach}favicon-grid.svg" width="64" height="64" alt="four-patch grid at 64px" /> <img src="{attach}favicon-grid.svg" width="32" height="32" alt="four-patch grid at 32px" /> <img src="{attach}favicon-grid.svg" width="16" height="16" alt="four-patch grid at 16px" />

A 2x2 grid of colored squares: pink, red, green, grey. These are
the four colors from the juxtaposition study in the
[second Albers post]({filename}/posts/20140904-albers-color-studies-part-2/index.md),
where every permutation of layering was laid out in a grid to show
how quantity and ordering affect the feel of a color combination.

This one holds up the best at small sizes. Four equal quadrants is
about the simplest spatial structure you can have beyond a single
block, and the four colors are different enough in both hue and value
that they stay distinct even at 16px. The 2x2 grid also has a nice
visual rhythm — it reads as a deliberate pattern, not a smudge.


## Option 4: Stacked Bands

<img src="{attach}favicon-bands.svg" width="128" height="128" alt="stacked bands at 128px" /> <img src="{attach}favicon-bands.svg" width="64" height="64" alt="stacked bands at 64px" /> <img src="{attach}favicon-bands.svg" width="32" height="32" alt="stacked bands at 32px" /> <img src="{attach}favicon-bands.svg" width="16" height="16" alt="stacked bands at 16px" />

Four horizontal bands progressing from dark olive to bright yellow.
This references the
[middle mixture and light intensity studies]({filename}/posts/20140904-albers-color-studies-part-2/index.md),
where Albers explored how adjacent colors of similar value seem to merge
while colors with strong value contrast maintain their boundaries.

The bands are clean and simple, but at 16px the four-step gradient
compresses into something that reads more like a generic color swatch
than a distinctive mark. The progression is too smooth — there's no
focal point for the eye to grab.


## The Choice

The four-patch grid won. It has the clearest identity at the sizes
that matter, the colors are directly drawn from the Albers work on
the site, and the 2x2 structure is simple enough to be iconic without
being generic. It's the one you're seeing in your browser tab right
now.
