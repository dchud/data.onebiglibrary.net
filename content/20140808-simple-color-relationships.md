Title:      simple color relationships w/d3


I've started reading Josef Albers' [Interaction of
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
