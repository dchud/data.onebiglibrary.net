Title:      Formally verifying mrrc
Summary:    Using agents to improve engineering rigor for experimental MARC library
Tags:       marc21, mrrc, format methods, rust, python
Status:     published

One of my experiments these past few months has been developing a Rust-based
MARC21 record library with
a [Pymarc](https://pymarc.readthedocs.io/en/latest/)-compatible Python wrapper.
It started as something of a lark when I was on a call with a few people in
mid-December, showing them how I was using various agentic tools. One of those
people was [Ed](https://inkdroid.org/), who knows a few things about building
MARC tools in new languages (see
[MARC/Perl](https://github.com/perl4lib/marc-perl) and, well, Pymarc). So I said
"what if we try writing a MARC library in Rust?" I had noticed a few efforts out
there, but the joke was that I don't even know Rust other than to recognize it
by sight. The idea was to show how we could get something basic working
surprisingly quickly.

And, well, now there's [mrrc](https://github.com/dchud/mrrc).

It might be useable already as a general-purpose MARC library, though I'm not
sure quite yet. At first I just wanted to see if I could get it to do something
useful quickly. I could, it did. Going from nothing to parsing thousands of binary
MARC records happened faster than we could believe at first. Maybe it was 20-30
minutes? In a language I didn't know.

We spent a little more time on that call discussing tooling and
prompts as I was getting to know
[beads](https://github.com/steveyegge/beads) at the time (and am
still happy with it, though I've cut over to the [Rust
port](https://github.com/Dicklesworthstone/beads_rust)).

Then afterward I noticed some frontier model news and thought "well let's see if
it can wrap this Rust API with Python and have a Pymarc-like API" and of course
it could. Then I thought "well can we make it go faster" and the answer was yes.
You get the point.

Suffice it to say that at this point, mrrc has a lot of useful features built
around the core MARC standards its obvious related standards like MARCXML, MODS,
and BIBFRAME. Have a look at [the mrrc
documentation](https://dchud.github.io/mrrc/) to see for yourself. What mrrc
lacks is users, though. I mentioned it on the [code4lib
slack](https://dchud.github.io/mrrc/) #python channel a few weeks ago and some
people were supportive, but I haven't heard back. It's okay, I know there are
other tools that already do all this. And this is just an experiment.

And as it turns out, some of them might have taken a look at it and dismissed it
quickly, because it wasn't quite what it claimed to be just yet. In particular,
it didn't support [MARCXML](https://www.loc.gov/standards/marcxml/), it actually
supported "MARC XML", which was the XML encoding it apparently made up itself.
It was *like* MARCXML, but it wasn't actually MARCXML. When I realized this (by actually trying to use mrrc
through Python myself for something practical) it immediately errored out that
it couldn't handle the MARCXML namespace and that was that. Have a look at [the
ticket filed on this](https://github.com/dchud/mrrc/issues/15) for some details
on where it went wrong, and keep reading  for a laugh about the absurd workaround it
gamely figured out (points for getting it to work, but that was not what I had
in mind).

There have been a few other bumps in the road. The bot (which I won't name here)
made up some benchmark numbers. A few times. At one point I was playing with
trying different binary encodings using more common/contemporary formats like
[flatbuffers](https://flatbuffers.dev/) and [protobuf](https://protobuf.dev/) to
see if there might be some clear payoff over the stalwart [ISO
2709](https://www.iso.org/standard/41319.html) binary format (upshot:
marginally, yes; performance, not for basic use cases; practically, there's no
demand, and initial respondents noticed how much they bloated the dependency
chain, so I scrapped it all, although the notes and discarded code are still in
another repo). Anyway in that process I templated out a per-format evaluation
approach and after building test implementations of 2-3 of the formats on my
list I noticed that the Nth one got built and tested suspiciously quickly. What
happened? That bot just looked at the other evaluations based on the same
template and made up its own evaluation using the same template without writing
any code. So there's that.

If you're paying close attention, though, you'll know that something really
spiked in frontier model quality right around the end of 2025 and in early 2026
I upgraded and suddenly I had thoughts of making this library truly useful. And
at this point, I think it's really quite close to that.

This is all still an experiment in learning, but I've shifted goals
from wanting to understand "how do I build things this way at all?"
to "how can I build something good?" And after listening to the
[Oxide and Friends show about
rigor](https://oxide-and-friends.transistor.fm/episodes/engineering-rigor-in-the-llm-age)
(thanks Ed for the tip!) now I want to know "how can I build something
*reliably* good?"

So the latest round of work - apart from squashing the embarrassing
bugs as I find them - is to bring in formal methods for verification,
to help specify how the library should behave and confirm that it
does, rather than just to test whether it does certain specific
things the right way with specific examples. I'm building out a [testbed for the
library](https://github.com/dchud/mrrc-testbed) to make it easy to throw piles
of real-world data at it, and then using that environment to start layering in
verification tools for both Rust and Python. You can see [the overall
strategy](https://github.com/dchud/mrrc-testbed/blob/main/formal-methods-verification-strategy.md)
I'm working from and [the implementation
plan](https://github.com/dchud/mrrc-testbed/blob/main/formal-methods-implementation-plan.md)
I'm working from.

To be 100% clear, those documents, as was the whole [testbed
proposal](https://github.com/dchud/mrrc-testbed/blob/main/testbed-proposal.md)
that started mrrc-testbed, are largely bot-generated, but I had
particular goals in mind while prompting those proposals, and have
learned a bit more about refining things until they have the right
shape. For example, I over-engineered the heck out of the testbed
proposal, and one morning I recognized that, and asked "have we
over-engineered this?" Thoughtfully, the bot replied "Yes, and
here's how I would simplify it." So we simplified. Still, I don't
feel quite right saying I wrote them, because I didn't.  Honestly,
I don't have any practical experience and only a little education
in formal methods, so I couldn't have written them myself. But
this is something I want to learn, and mrrc seems like a perfect
tool to learn them on.

And then there's the wonderfully helpful [learning-opportunities Claude
skill](https://github.com/DrCatHicks/learning-opportunities) by [Dr. Cat
Hicks](https://www.drcathicks.com/), which I learned about via [this episode of
Change,
Technically](https://www.changetechnically.fyi/2396236/episodes/18692591-you-can-learn-with-ai).
Not only does it work very well, it's exactly the kind of tool that I like to
learn with, developed by somebody who obviously knows a lot about how we learn
with tools. I'm working with it as I go, with a whole learning plan on the side
(it's for me, not the repo, so it's not in there) and getting it to ask me
questions and assess my understanding as I progress. I recommend this skill
highly if you're using these bots, or even (maybe especially) if you're new to
them and want to try some new things out.

Progress so far includes finishing setting up the testbed, refining
the test workflow, and working through "[Wave
A](https://github.com/dchud/mrrc-testbed/blob/main/formal-methods-implementation-plan.md#wave-a-low-hanging-fruit-phases-1--beginning-of-3)"
from the implementation plan, incorporating
[proptest](https://docs.rs/proptest/latest/proptest/) and
[Miri](https://github.com/rust-lang/miri) for Rust and
[Hypothesis](https://hypothesis.readthedocs.io/en/latest/) for
Python. The testbed immediately caught something, too! And now there
are even more nightly jobs to run and the start of better assurance
that things like round-tripping data from one serialization to
another will be reliable.

On to Wave B...
