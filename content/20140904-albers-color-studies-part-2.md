Title: Albers color studies, part 2


(See also part one, [simple color relationships
w/d3](http://data.onebiglibrary.net/2014/08/08/simple-color-relationships/).)

Picking up where we left off, in the middle of Josef Albers'
[Interaction of Color](http://yupnet.org/interactionofcolor/) (Yale
Press's iPad edition), his study of the "middle mixture" affords a
chance to bring in [D3.js](http://d3js.org/) support for animations
and transitions.

In this study, Albers chooses a trio of colors where the middle is
a mixture in the middle of the other two.  He recommends sliding
the lowest part up slowly, so we can observe how the increased ratio
of the darker color draws out how that darker color contributes to
the mix, and then as you slide it back away again, you can see the
top (lighter) color come through in the middle mixture. Concentrate
on the middle block as the lower one moves up and down, and you can
also see an illusory gradient effect near the top and bottom.

<div id='middle'></div>
<script>
var width = 450, height = 720;
var svg = d3.select("#middle").append("svg")
    .attr("width", width)
    .attr("height", height);

var color_light = '#F5F57F';
var color_middle = '#C4BF7E';
var color_dark = '#918763';

// top block, light
var block_top = svg.append("rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("width", width)
    .attr("height", height / 3)
    .attr("fill", color_light);

// middle block
var block_middle = svg.append("rect")
    .attr("x", 0)
    .attr("y", 240)
    .attr("width", width)
    .attr("height", height / 3)
    .attr("fill", color_middle);

// bottom block, dark
var block_bottom = svg.append("rect")
    .attr("x", 0)
    .attr("y", 480)
    .attr("width", width)
    .attr("height", height / 3)
    .attr("fill", color_dark);

var animate = function() {
    block_bottom
        .transition()
            .delay(1000)
            .duration(5000)
            .attr("y", 280)
            .ease("quad-in-out")
        .transition()
            .duration(5000)
            .attr("y", 480)
            .ease("quad-in-out")
            .each("end", animate);
};
animate();

</script>

<hr />

This study demonstrates how varying the quantity of each color present 
affects the relationships between colors and the overall feeling of a
design even when the structure isn't altered in any other way.  All of
these use the same four colors and the same overall shape.


<div id='juxtaposition'></div>
<script>
var width = 630, height = 600;
var svg = d3.select("#juxtaposition").append("svg")
    .attr("width", width)
    .attr("height", height);

var xpad = 40;
var ypad = 30;

var xscale = d3.scale.linear()
    .domain([0, 4])
    .range([0, width - (xpad * 3)]);
var yscale = d3.scale.linear()
    .domain([0, 6])
    .range([0, height - (ypad * 5)]);

// colors
var pink = '#DEBAD0';
var grey = '#C4C2D1';
var red = '#C95B44';
var green = '#526B5C';
var colors = [pink, grey, red, green];

var interiors = [
    // pink column
    [[red, grey, green],
    [red, green, grey],
    [grey, green, red],
    [grey, red, green],
    [green, grey, red],
    [green, red, grey]],
    // grey column
    [[pink, green, red],
    [pink, red, green],
    [red, pink, green],
    [red, green, pink],
    [green, red, pink],
    [green, pink, red]],
    // red column
    [[pink, grey, green],
    [pink, green, grey],
    [grey, pink, green],
    [grey, green, pink],
    [green, grey, pink],
    [green, pink, grey]],
    // green column
    [[pink, grey, red],
    [pink, red, grey],
    [grey, red, pink],
    [grey, pink, red],
    [red, pink, grey],
    [red, grey, pink]]
    ];



colors.forEach(function(ce, ci, ca) {
    d3.range(0, 6).forEach(function(ye, yi, ya) {
        // outer box
        svg.append("rect")
            .attr("x", xscale(ci))
            .attr("y", yscale(yi))
            .attr("width", 100)
            .attr("height", 63)
            .attr("fill", ce);
        svg.append("rect")
            .attr("x", xscale(ci) + 10)
            .attr("y", yscale(yi) + 12)
            .attr("width", 80)
            .attr("height", 48)
            .attr("fill", interiors[ci][yi][0]);
        svg.append("rect")
            .attr("x", xscale(ci) + 17)
            .attr("y", yscale(yi) + 18)
            .attr("width", 66)
            .attr("height", 24)
            .attr("fill", interiors[ci][yi][1]);
        svg.append("rect")
            .attr("x", xscale(ci) + 23)
            .attr("y", yscale(yi) + 22)
            .attr("width", 54)
            .attr("height", 18)
            .attr("fill", interiors[ci][yi][2]);
    });
});

</script>

Each has its own distinct feel, right? Taken together they seem to
dance chaotically, and it's not particularly pleasant, but its goal
is instructive, of course, not aesthetic. Albers suggests using
sheets of paper or your hands to block out smaller sets to look at
in turn: a row, a column, etc., and considering which combinations
are your favorite and why.

In writing this one up I waffled between writing a routine to
generate the color permutations and laying them out explicitly like
the example in the book, and I ended up matching the book explicitly.
The rest of these exercises have tried to match the book closely,
so it seemed okay to just iterate over an array of arrays that had
been lined up by hand. I also did a lot of pixel-nudging to get the
boxes to line up just so (hence punting on fixing the extra white
space at the bottom).

<hr />

This next study is a similar look at color mixture. The individual 
lines can be laid out with scaling easily enough with D3, but to make
them look uneven/wobbly is a bit of a challenge.


<div id='wobbly'></div>
<script>
var width = 420, height = 720;
var svg = d3.select("#wobbly").append("svg")
    .attr("width", width)
    .attr("height", height);

var padding = 10;

var orange = '#D46D42';
var violet = '#A29BD1';
var grey = '#DCE3E1';
var green = '#476E51';
var colors = [green, orange, violet, grey];

var xscale = d3.scale.linear()
    .domain([0, 18])
    .range([padding, width-(padding * 2)]);
var yscale = d3.scale.linear()
    .domain([0, 4])
    .range([padding, height-(padding * 2)]);

var skewscale = d3.scale.linear()
    .domain([0, 1])
    .range([-1, 1]);
var skewer = function() {
    return skewscale(Math.random());
};

var sizescale = d3.scale.linear()
    .domain([0, 1])
    .range([.96, 1.04]);
var scaler = function() {
    return sizescale(Math.random());
};

var rotatescale = d3.scale.linear()
    .domain([0, 1])
    .range([-2, 2]);
var rotater = function() {
    return rotatescale(Math.random());
};

// backgrounds
colors.forEach(function(ce, ci, ca) {
    svg.append("rect")
        .attr("x", padding)
        .attr("y", yscale(ci))
        .attr("width", width - (padding * 2))
        .attr("height", (height - (padding * 2)) / 4)
        .attr("fill", ce);
});

var transformer = function() {
    return "scale(" + scaler() + ") rotate(" + rotater() + ")"; // skewX(" + skewer() + ") skewY(" + skewer() + ")";
};

[violet, grey, green, orange].forEach(function(ce, ci, ra) {
    svg.append("rect")
        .attr("x", 0)
        .attr("y", yscale(ci))
        .attr("width", width / 17 - 8)
        .attr("height", height / 4)
        .attr("fill", ce);
});

[grey, green, orange, violet].forEach(function(ce, ci, ra) {
    svg.append("rect")
        .attr("x", xscale(18))
        .attr("y", yscale(ci))
        .attr("width", width / 17 - 8)
        .attr("height", height / 4)
        .attr("fill", ce);
});

[green, grey, violet, orange].forEach(function(ce, ci, ra) {
    d3.range(0, 18).forEach(function(re, ri, ra) {
        svg.append("rect")
            .attr("x", 0)
            .attr("y", 0)
            .attr("transform", "translate(" + (xscale(re) + 2) + ", " + yscale(3 - ci) + ") scale(" + scaler() + ") skewX(" + skewer() + ") skewY(" + skewer() + ") rotate(" + rotater() + ", " + width/36 + ", " + height/8 + ")")
            .attr("width", width / 17 - 8)
            .attr("height", height / 4)
            .attr("fill", ce);
    })
});

</script>

This mostly recreates the effect of the study in the book but is
unsatisfying on a few counts. The "wobble" of the individual patches
is decent, but they should scale and skew a little more. The ordering
of the stacking throws off the effect, and the y-skew is a little
too great. Perhaps the biggest issue is the use of `translate()`
to locate each strip in its place sets the top-left `(x,y)` to too
fixed of a point; it needs to vary more. There is a lot going on
in the [SVG transform
attributes](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/transform)
that I don't fully understand, largely around the shift in coordinate
systems, and that's holding me back from developing the right
approach to skewing and placing each strip correctly. I'll have to
revisit this to wrap my head around it more fully.

This is definitely the most disappointing recreation of studies
from the book I've done so far.

<hr />

#### The Weber-Fechner Law

Wikipedia points out [discrepancies in the term "Weber-Fechner
law"](http://en.wikipedia.org/wiki/Weber%E2%80%93Fechner_law) but
as that's how Albers referred to the difference between the
quantitative and perceptual effect of layering color: linear additions
seem to lead to logarithmic effects, and exponential additions seem
to lead to linear effects. In the book this study uses translucence,
so I'll stick with SVG's opacity support to recreate it.

Arithmetic increases in application of color here, by way of stacking,
lead to only slight shifts in the perceived color.


<div id='yellow-stack'></div>
<script>
var width = 600, height = 600;
var svg = d3.select("#yellow-stack").append("svg")
    .attr("width", width)
    .attr("height", height);

var yellow = '#D7E650';
var opacity = '0.75';

// two horizontals
svg.append("rect")
    .attr("x", 0)
    .attr("y", 300)
    .attr("width", 500)
    .attr("height", 175)
    .attr("fill-opacity", opacity)
    .attr("fill", yellow);
svg.append("rect")
    .attr("x", 50)
    .attr("y", 220)
    .attr("width", 500)
    .attr("height", 175)
    .attr("fill-opacity", opacity)
    .attr("fill", yellow);

// two verticals
svg.append("rect")
    .attr("x", 100)
    .attr("y", 50)
    .attr("width", 175)
    .attr("height", 500)
    .attr("fill-opacity", opacity)
    .attr("fill", yellow);
svg.append("rect")
    .attr("x", 180)
    .attr("y", 130)
    .attr("width", 175)
    .attr("height", 500)
    .attr("fill-opacity", opacity)
    .attr("fill", yellow);

</script>


Ah, this recreates the effect of the study in the book much more
effectively than the previous one (a relief). With 75% `fill-opacity`
we can trace the distinct shades of color as 2, 3, and 4 patches
are overlaid in different spots. The difference from one to two is
much greater than the difference from three to four.

<hr />

This next study repeats a similar process, showing off the difference
between linear and exponential layer addition. At left, each succeding
strip from top to bottom has one additional layer beyond the one above
it; at right, the difference is a power of two. So at left, it is 
{1, 2, 3, 4, 5} layers, and at right, {1, 2, 4, 8, 16}.


<div id='red-stacks'></div>
<script>
var width = 600, height = 600;
var svg = d3.select("#red-stacks").append("svg")
    .attr("width", width)
    .attr("height", height);

var red = '#871315';
var black = '#000';
var opacity = '0.12';

// left
svg.append("rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("width", 260)
    .attr("height", height)
    .attr("fill", red);
// right
svg.append("rect")
    .attr("x", 340)
    .attr("y", 0)
    .attr("width", 260)
    .attr("height", height)
    .attr("fill", red);

// layer two, just like the first, but smaller
// left
svg.append("rect")
    .attr("x", 0)
    .attr("y", 120)
    .attr("width", 260)
    .attr("height", height)
    .attr("fill-opacity", opacity)
    .attr("fill", black);
// right
svg.append("rect")
    .attr("x", 340)
    .attr("y", 120)
    .attr("width", 260)
    .attr("height", height)
    .attr("fill-opacity", opacity)
    .attr("fill", black);

// layer three, repeating on right
// left
svg.append("rect")
    .attr("x", 0)
    .attr("y", 240)
    .attr("width", 260)
    .attr("height", height)
    .attr("fill-opacity", opacity)
    .attr("fill", black);
// right
d3.range(0, 2).forEach(function(e, i, a) {
    svg.append("rect")
        .attr("x", 340)
        .attr("y", 240)
        .attr("width", 260)
        .attr("height", height)
        .attr("fill-opacity", opacity)
        .attr("fill", black);
});

// layer four, repeating on right
// left
svg.append("rect")
    .attr("x", 0)
    .attr("y", 360)
    .attr("width", 260)
    .attr("height", height)
    .attr("fill-opacity", opacity)
    .attr("fill", black);
// right
d3.range(0, 4).forEach(function(e, i, a) {
    svg.append("rect")
        .attr("x", 340)
        .attr("y", 360)
        .attr("width", 260)
        .attr("height", height)
        .attr("fill-opacity", opacity)
        .attr("fill", black);
});

// layer five, repeating on right
// left
svg.append("rect")
    .attr("x", 0)
    .attr("y", 480)
    .attr("width", 260)
    .attr("height", height)
    .attr("fill-opacity", opacity)
    .attr("fill", black);
// right
d3.range(0, 8).forEach(function(e, i, a) {
    svg.append("rect")
        .attr("x", 340)
        .attr("y", 480)
        .attr("width", 260)
        .attr("height", height)
        .attr("fill-opacity", opacity)
        .attr("fill", black);
});
</script>

I misread this one, getting it completely wrong at first. The ground
is a red, and the added layers are blacks, using SVG `fill-opacity`.
I had thought at first that the layers were all red, but the part
at right never converged to black until I re-read that they are
indeed black layers added on top, on both sides.

I haven't been able to recreate the subtlety of the shift to barely
imperceptable on the left, but this is fairly close.


<hr />

This final study is a look at near-equality of light intensity, the
difficulty of choosing examples for which Albers warns us carefully.
If chosen correctly, when the two saw-tooths come together, two
colors with similar light intensity should start to blend into each
other, even though they are dissimilar otherwise.

<div id='sawtooth'></div>
<script>
var width = 300, height = 600;
var svg = d3.select("#sawtooth").append("svg")
    .attr("width", width)
    .attr("height", height);

var c1 = '#D9C1A0';
var c2 = '#E3BABA';

var y = d3.scale.linear()
    .domain([0, 6])
    .range([0, height]);

d3.range(1, 6).forEach(function(e, i, a) {
    svg.append("rect")
        .attr("class", "left")
        .attr("x", 70)
        .attr("y", 0)
        .attr("width", 80)
        .attr("height", 100)
        .attr("transform", "translate(0, " + y(e) + ") skewX(-10)")
        .attr("fill", c1);
});

d3.range(0, 5).forEach(function(e, i, a) {
    svg.append("rect")
        .attr("class", "right")
        .attr("x", 168)
        .attr("y", 0)
        .attr("width", 80)
        .attr("height", 100)
        .attr("transform", "translate(0, " + y(e) + ") skewX(-10)")
        .attr("fill", c2);
});

var animate = function() {
    var left = svg.selectAll('.left'); 
    left.transition()
        .delay(1000)
        .duration(3000)
        .attr("x", 79)
        .ease("quad-in-out")
        .transition()
        .duration(3000)
        .attr("x", 70)
        .ease("quad-in-out");
    var right = svg.selectAll('.right');
    right.transition()
        .delay(1000)
        .duration(3000)
        .attr("x", 157)
        .ease("quad-in-out")
        .transition()
        .duration(3000)
        .attr("x", 168)
        .ease("quad-in-out")
        .each("end", animate);
};
animate();

</script>

This works nicely - for that brief instant when the two sides touch
it seems like the sawtooth pattern at their mutual boundary disappears
and the colors start to merge. 

This has been a great exercise, both in learning about color
relativity and digging deeper into the basics of D3. Just makes me
want to do more. There a lot of code in the studies I replicated
here and in part one that could be much clearner, but I gave up on
writing clean code in service of getting it done and keeping things
simple.  In future posts I'll be working with real datasets more
often than not, and cleaner code will always help there. I aimed
for staying true to the exact studies in the book, too, to have a
target to aim towards, rather than taking the opportunity to do the
exercises for myself, finding colors that would be a good match,
because I wanted to learn about D3 at the same time, and reproduction
is easier than original work. The app version of the book allows
for creating your own studies, and I've played around with that
some, so I don't feel like I'm missing out too much.

I hope you'll stay tuned, it feels like it's just getting started.
