Title:      simple color relationships w/d3


I've been reading Josef Albers' [Interaction of
Color](http://yupnet.org/interactionofcolor/) (Yale Press's iPad
edition) and am learning quite a lot from it. I particularly enjoy
his details about what to expect in student reactions to particular
exercises; you know he must have anticipated and savored these
reactions each time, with every class.

The basic principles of the first few chapters should be easy to
demonstrate using [d3](http://d3js.org/).

In "Chapter IV: A color has many faces" we see the first of several
color plates and we are quickly drawn into what he has to teach us
about the relativity of color, that "color is the most relative
medium in art." Let's mimic the first experiment, making one color
look different from itself, using different background colors. I'm
guessing (poorly!) at colors somewhat close to those in the prepared
studies in the text itself, using [this color
picker](http://www.colorpicker.com/).

<div id='basic'></div>
<script>
var width = 700, height = 800;
var svg = d3.select("#basic").append("svg")
    .attr("width", width)
    .attr("height", height);
var outer1 = svg.append("rect")
    .attr("x", 50)
    .attr("y", 50)
    .attr("width", 600)
    .attr("height", 300)
    .attr("fill", "#4C0A73");
var inner1 = svg.append("rect")
    .attr("x", 100)
    .attr("y", 100)
    .attr("width", 500)
    .attr("height", 200)
    .attr("fill", "#5A6E5E");
var outer2 = svg.append("rect")
    .attr("x", 50)
    .attr("y", 450)
    .attr("width", 600)
    .attr("height", 300)
    .attr("fill", "#9DD1CE");
var inner2 = svg.append("rect")
    .attr("x", 100)
    .attr("y", 500)
    .attr("width", 500)
    .attr("height", 200)
    .attr("fill", "#5A6E5E");
</script>

This use of d3 demonstrates several features which make it an
appealing toolkit, even for a beginner:

* it's just javascript
* it's just [SVG](http://en.wikipedia.org/wiki/Scalable_Vector_Graphics)
* you can do simple things very simply

I learned SVG many years ago, back in 2004, when it was still a
fairly new web standard and had very few useable implementations.
The good news is that it is much more widely implemented now, and
that it hasn't changed much since back then (there's only been one
new revision, a "second edition" of the first version), so if you
know a few SVG basics then it's easy to see that d3 just uses an
API defined in javascript to generate SVG.  This is a *lot* easier
than generating SVG by hand yourself; I know from first-hand
experience a decade ago.

Another way to think of d3 is as a "domain specific language" for
dynamic documents on the web.  It's just javascript, but it's a
flavor of types and techniques specific to generating SVG using
javascript that lends itself well to visualizing data.

In any case, this copied "plate" demonstrates the basic principle
well: the inner color is exactly the same in both rectangles, and
it is the interaction between this color and the differing surrounding
/ background colors that makes it look different from itself from
one to the next.


#### Changing colors

To make this a little more dynamic (it is the web after all) let's
add the ability to change colors by clicking on the inner boxes.
The code will be the same, but with the "click" method defined on
each.

Click on the top inner box to make both inner boxes lighter.  Click
on the bottom inner box to make both inner boxes darker.

<div id='changing-colors'></div>
<script>
var width = 700, height = 800;
var innercolor = "#5A6E5E";
var svg = d3.select("#changing-colors").append("svg")
    .attr("width", width)
    .attr("height", height);
var outer1 = svg.append("rect")
    .attr("x", 50)
    .attr("y", 50)
    .attr("width", 600)
    .attr("height", 300)
    .attr("fill", "#4C0A73");
var inner1 = svg.append("rect")
    .attr("x", 100)
    .attr("y", 100)
    .attr("width", 500)
    .attr("height", 200)
    .attr("fill", innercolor)
    .on("click", function(){
        brighten();
    });
var outer2 = svg.append("rect")
    .attr("x", 50)
    .attr("y", 450)
    .attr("width", 600)
    .attr("height", 300)
    .attr("fill", "#9DD1CE");
var inner2 = svg.append("rect")
    .attr("x", 100)
    .attr("y", 500)
    .attr("width", 500)
    .attr("height", 200)
    .attr("fill", innercolor)
    .on("click", function(){
        darken();
    });

function brighten () {
    [inner1, inner2].forEach(function(item) {
        item.style("fill", d3.hsl(item.style("fill")).brighter(.1));
    });
}

function darken () {
    [inner1, inner2].forEach(function(item) {
        item.style("fill", d3.hsl(item.style("fill")).darker(.1));
    });
}
</script>


This further reinforces the effect; at some points as you click to
ratchet the intensity up or down the two inner boxes look like
wholly different colors, and at other points (especially the extremes)
it is clear that they are the same.

Of course this isn't quite what Albers had in mind with the lovely
physical interactions designed into his text (which the Yale Press' folks
very creatively transposed to the iPad app) but perhaps we can use the
dynamic aspect of the web, made so easy by d3, usefully to embody some
of the same lessons he taught.


#### Lighter and/or darker

To focus us in on light intensity, Albers presents several exersizes
in subtle and not-so-subtle gradations of light. SVG's gradient support
should help to recreate them.

<div id='light-stripes'></div>
<script>
var width = 450, height = 700;
var svg = d3.select("#light-stripes").append("svg")
    .attr("width", width)
    .attr("height", height);
// basic gradient
var gradient_up = svg.append("svg:defs")
    .append("svg:linearGradient")
        .attr("id", "gradient_up")
        .attr("x1", "0%")
        .attr("y1", "0%")
        .attr("x2", "0%")
        .attr("y2", "100%");
gradient_up.append("svg:stop")
    .attr("offset", "0%")
    .attr("stop-color", "#222")
    .attr("stop-opacity", 1);
gradient_up.append("svg:stop")
    .attr("offset", "100%")
    .attr("stop-color", "#ddd")
    .attr("stop-opacity", 1);
// now the opposite; perhaps a transform instead?
var gradient_down = svg.append("svg:defs")
    .append("svg:linearGradient")
        .attr("id", "gradient_down")
        .attr("x1", "0%")
        .attr("y1", "100%")
        .attr("x2", "0%")
        .attr("y2", "0%");
gradient_down.append("svg:stop")
    .attr("offset", "0%")
    .attr("stop-color", "#222")
    .attr("stop-opacity", 1);
gradient_down.append("svg:stop")
    .attr("offset", "100%")
    .attr("stop-color", "#ddd")
    .attr("stop-opacity", 1);

// the frame
var outer = svg.append("rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("width", width)
    .attr("height", height)
    .attr("fill", "#888");
// the inner "background"
var inner = svg.append("rect")
    .attr("x", 10)
    .attr("y", 10)
    .attr("width", width - 20)
    .attr("height", height - 20)
    .style("fill", "url(#gradient_up)");

var bar_width = (width-20) / 19;

var x_scale = d3.scale.linear()
    .domain([0, 18])
    .range([10, width - 10 - bar_width]);

// the "foreground"
for(var i=0; i<19; i++) {
    if(i % 2) {
        var barup = svg.append("rect")
            .attr("x", x_scale(i))
            .attr("y", 10)
            .attr("width", bar_width)
            .attr("height", height - 20);
        barup.style("fill", "url(#gradient_down)");
    }
}
</script>

This really comes alive as the intensity of the two gradients pass
each other on the way up/down. It all seems to merge!  And little
shadows seem to appear around the frame at the top and bottom just
past the strips' ends.

The gradients above are explicit. In this next example from Albers,
the gradients are illusions.

<div id='gradations'></div>
<script>
var width = 300, height = 700;
var svg = d3.select("#gradations").append("svg")
    .attr("width", width)
    .attr("height", height);

// the frame
var outer = svg.append("rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("width", width)
    .attr("height", height)
    .attr("fill", "#888");

var bar_width = (width - 60) / 2;
var bar_height = (height - 20) / 17;

var y_scale = d3.scale.linear()
    .domain([0, 16])
    .range([height - 20 - bar_height, 20]);
var color_scale = d3.scale.linear()
    .domain([0, 16])
    .range(['#222', '#ddd']);

// the panels
for(var i=0; i<17; i++) {
    var panel = svg.append("rect")
        .attr("x", 20)
        .attr("y", y_scale(i))
        .attr("width", bar_width)
        .attr("height", bar_height)
        .style("fill", color_scale(i));
    var panel = svg.append("rect")
        .attr("x", (width / 2) + 10)
        .attr("y", y_scale(i))
        .attr("width", bar_width)
        .attr("height", bar_height)
        .style("fill", color_scale(i));
}
</script>


Every one of the individual rectangles above is a solid color, even
though it looks like each has its own gradient. It's the effect of the 
proximity to slightly lighter and darker colors above and below that
makes the contrasts between them appear to form two ends of a gradient
in each rectangle. It seems to be most pronounced in the corners.


#### Transparence and Optical Mixture

Albers teaches that we can simulate transparency and the apparent
ordering/stacking of layers with color mixtures; SVG allows for
specific opacity settings. Let's try it both ways, first with
explicit color changes:

<div id='transparency'></div>
<script>
var width = 450, height = 700;
var svg = d3.select("#transparency").append("svg")
    .attr("width", width)
    .attr("height", height);

// the frame
var outer = svg.append("rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("width", width)
    .attr("height", height)
    .attr("fill", "#ADA0BA");

// black "foreground"
var foreground = svg.append("rect")
    .attr("x", 210)
    .attr("y", 50)
    .attr("width", 200)
    .attr("height", 600)
    .attr("fill", "#111");

// white strips, left side
var strip1 = svg.append("rect")
    .attr("x", 60)
    .attr("y", 110)
    .attr("width", 150)
    .attr("height", 120)
    .attr("fill", "#eee");

var strip2 = svg.append("rect")
    .attr("x", 60)
    .attr("y", 290)
    .attr("width", 150)
    .attr("height", 120)
    .attr("fill", "#eee");

var strip3 = svg.append("rect")
    .attr("x", 60)
    .attr("y", 470)
    .attr("width", 150)
    .attr("height", 120)
    .attr("fill", "#eee");

// "white" strips, right side
var strip4 = svg.append("rect")
    .attr("x", 210)
    .attr("y", 110)
    .attr("width", 120)
    .attr("height", 120)
    .attr("fill", "#333");

var strip5 = svg.append("rect")
    .attr("x", 210)
    .attr("y", 290)
    .attr("width", 120)
    .attr("height", 120)
    .attr("fill", "#888");

var strip3 = svg.append("rect")
    .attr("x", 210)
    .attr("y", 470)
    .attr("width", 120)
    .attr("height", 120)
    .attr("fill", "#ccc");
</script>


Note that none of the transparent-seeming sections are actually
transparent; it is only simulated by shifting the color mix. Even
so, it appears that the one at top is "behind" the black, and the
one at bottom is "in front of" the black.

Let's try doing it again, but this time with SVG opacity variations.


<div id='transparency2'></div>
<script>
var width = 450, height = 700;
var svg = d3.select("#transparency2").append("svg")
    .attr("width", width)
    .attr("height", height);

// the frame
var outer = svg.append("rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("width", width)
    .attr("height", height)
    .attr("fill", "#ADA0BA");

// black "foreground"
var foreground = svg.append("rect")
    .attr("x", 210)
    .attr("y", 50)
    .attr("width", 200)
    .attr("height", 600)
    .attr("fill", "#111");

// white strips, left side
var strip1 = svg.append("rect")
    .attr("x", 60)
    .attr("y", 110)
    .attr("width", 150)
    .attr("height", 120)
    .attr("fill", "#eee");

var strip2 = svg.append("rect")
    .attr("x", 60)
    .attr("y", 290)
    .attr("width", 150)
    .attr("height", 120)
    .attr("fill", "#eee");

var strip3 = svg.append("rect")
    .attr("x", 60)
    .attr("y", 470)
    .attr("width", 150)
    .attr("height", 120)
    .attr("fill", "#eee");

// "white" strips, right side
var strip4 = svg.append("rect")
    .attr("x", 210)
    .attr("y", 110)
    .attr("width", 120)
    .attr("height", 120)
    .attr("fill-opacity", 0.15)
    .attr("fill", "#eee");

var strip5 = svg.append("rect")
    .attr("x", 210)
    .attr("y", 290)
    .attr("width", 120)
    .attr("height", 120)
    .attr("fill-opacity", 0.5)
    .attr("fill", "#eee");

var strip3 = svg.append("rect")
    .attr("x", 210)
    .attr("y", 470)
    .attr("width", 120)
    .attr("height", 120)
    .attr("fill-opacity", 0.85)
    .attr("fill", "#eee");
</script>

Looks very similar, right?

If you look at the source, you'll see that the structure of this
second version is exactly the same. Only two things change: first,
the right halves of the strips are set to the same initial color
as the left halves, `#eee`, whereas in the first version each is
set to an explicitly different color on the grey scale; second, the
`fill-opacity` is varied for each of these three from `0.15` at the
top (so more of the background black comes through) to `0.85` at the
bottom (so more of the white stays "on top"). Just like the first
version, each of the "strips" are actually rendered as two separate
`rect` elements.

So there it is, you can truly simulate transparency and ordering /
stacking just by varying colors, and achieve results almost exactly
like using actual transparency, as demonstrated by the second
diagram.

One more example from the book exhibiting the effects of "optical
mixture". There are four colors in this example: white, blue, olive,
and mint (for lack of better terms). The individual circles and 
their "donut holes" are all the same size, but the color mixing
makes it appear otherwise. Also, changing contrast in the background
colors relative to the foreground create their own effects, shifting
the sense of what's foreground and background.


<div id='circles'></div>
<script>
var width = 380, height = 800;
var svg = d3.select("#circles").append("svg")
    .attr("width", width)
    .attr("height", height);

// colors
var white = "#eee",
    olive = "#8A8049",
    blue = "#248591",
    mint = "#9BC9B2";

// the frame
var outer = svg.append("rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("width", width)
    .attr("height", height)
    .attr("fill", olive);

// padding elements
var padding = 40;

// scales for placing the circles
var dia = 30;
var x = d3.scale.linear()
    .domain([0, 9])
    .range([padding + dia/2, width - (padding + dia/2)]);

var ydia = (height - (padding * 2)) / 24;
var y = d3.scale.linear()
    .domain([0, 23])
    .range([padding + dia/2, height - (padding + dia/2)]);

// ranges for counting the circles
var xrange = d3.range(0, 10);
var yrange = d3.range(0, 8);

// draw outer circles, want to repeat per color
var outer_circles = function(range_factor, color) {
    xrange.forEach(function (xe, xi, xa) {
        yrange.forEach(function (ye, yi, ya) {
            svg.append("circle")
                .attr("cx", x(xe))
                .attr("cy", y(ye + range_factor))
                .attr("r", dia/2)
                .attr("fill", color);
        });
    });
};

outer_circles(0, white);
outer_circles(8, mint);
outer_circles(16, blue);

// draw inner circles, arbitrary sets of y-lines and color
var inner_circles = function(ystart, ystop, color) {
    xrange.forEach(function (xe, xi, xa) {
        d3.range(ystart, ystop).forEach(function (ye, yi, ya) {
            svg.append("circle")
                .attr("cx", x(xe))
                .attr("cy", y(ye))
                .attr("r", dia/5)
                .attr("fill", color);
        });
    });
};

inner_circles(2, 4, mint);
inner_circles(4, 6, olive);
inner_circles(6, 10, blue);
inner_circles(10, 12, olive);
inner_circles(14, 18, white);
inner_circles(18, 20, mint);
inner_circles(20, 22, olive);
</script>

Wow, that turned out better than I thought, but it took a while.
This was a good exercise in framing scaled elements with padding
in d3. I had tried to eyeball the inner frame shape and circle
diameters based on calculations based on padding, width, and height,
but it didn't line up right until I realized it's just an exact 10
x 24 grid.

Once I reset the scaling to use that grid (worked right away), I
rewrote the outer/inner circle rendering bits using one function
for each; it could be taken a step further with one function for
both that would allow the diameter as a parameter too, and the rows
and colors could just be one simple data structure to loop over,
but it's good enough as is.

Finally, the colors were a bear to get right. I eyeballed a match
to the colors in the iPad app but the contrast just didn't pop the
way it does in the Yale-produced ebook. After playing with the
colors a lot I remembered: I use the [flux app](https://justgetflux.com/)
on my desktop, and was working on this at night, so everything was
completely wrong! After turning flux off I was able to get a lot
closer, though the ebook version is still much better.


#### Summary

This has been a great exercise in working with the lessons in color 
Albers lays out so elegantly in his book. If this interests you at
all I recommend you get a copy for yourself (the iPad ebook is worth
every penny). A colleague at our library told me we have an early
print edition with all the fold-outs and flaps, so I will have to
take a look at that as well.

It's also been a good lesson in using d3 to render simple shapes
and colors, and remembering to look in the d3 docs for a cleanly
defined function I'd have otherwise more awkwardly wired up myself
in javascript. Even something as simple to do by hand as what
`d3.range()` [offers](https://github.com/mbostock/d3/wiki/Arrays#d3_range)
has a familiar feel and semantic specificity that makes d3 just
make all the more sense.

I am about halfway through the text and could use a lot more d3
practice, so before I move on to rendering data more explicitly I
might take a stab at a "part two" post along these same lines.

If any of the specifics interest you I'd suggest you look at the 
source directly in your browser or using the github links to view
or edit the full markdown+javascript file I'm writing here and
feeding into [pelican](http://blog.getpelican.com/). Pull requests
welcome, especially if you spot mistakes or just plain bad ideas,
I know I still have a lot to learn.

(See also part two, [Albers color studies in D3.js, part
2](http://data.onebiglibrary.net/2014/09/04/albers-color-studies-part-2/))
