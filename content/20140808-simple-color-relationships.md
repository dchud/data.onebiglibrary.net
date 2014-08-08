Title:      simple color relationships w/d3


I've been reading Josef Albers' [Interaction of
Color](http://yupnet.org/interactionofcolor/) (Yale Press's iPad
edition) and am learning quite a lot from it. I particularly enjoy
his details about what to expect in student reactions to particular
exercises; you know he must have anticipated these reactions each
time, with every class.

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
    .attr("width", width-20)
    .attr("height", height-20)
    .style("fill", "url(#gradient_up)");

var bar_width = (width-20) / 19;

var x_scale = d3.scale.linear()
    .domain([0, 18])
    .range([10, width-10-bar_width]);

// the "foreground"
for(var i=0; i<19; i++) {
    if(i % 2) {
        var barup = svg.append("rect")
            .attr("x", x_scale(i))
            .attr("y", 10)
            .attr("width", bar_width)
            .attr("height", height-20);
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
var bar_height = (height-20) / 17;

var y_scale = d3.scale.linear()
    .domain([0, 16])
    .range([height-20-bar_height, 20]);
var color_scale = d3.scale.linear()
    .domain([0, 16])
    .range(['#222', '#ddd']);

// the panels
for(var i=0; i<17; i++) {
    var panel= svg.append("rect")
        .attr("x", 20)
        .attr("y", y_scale(i))
        .attr("width", bar_width)
        .attr("height", bar_height)
        .style("fill", color_scale(i));
    var panel= svg.append("rect")
        .attr("x", (width/2) + 10)
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
in each rectangle.

To my eye, it seems to be most pronounced in the corners.
