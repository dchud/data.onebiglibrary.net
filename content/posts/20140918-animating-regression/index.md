Title:      animating regression

When performing a simple linear regression, it's important to review
all the diagnostic plots that come with it. If the residual errors
aren't normally distributed, you will have to rethink your model.
Like I referenced in an [earlier
post](http://data.onebiglibrary.net/2014/08/12/things-to-know-about-data-science/)
you can't just stop at the fit plot, even if it is pretty (here
courtesy of SAS):

![regression plot]({attach}b3-simple-regression-plot.png)

You have to review its diagnostics:

![regression diagnostics]({attach}b3-simple-regression-diag.png)

Typically in a set of diagnostic plots like this, you look first
at the top left chart to see if the residuals balance around 0. The
Q-Q plot below that should be close to the 45&deg; line, the histogram
below that should look normal the way most of us know, and the
Cook's distance plot at middle right should show no outliers near
or above 1. Any of these plots going wrong should be a sign that
there's something amiss with your model. And this is all in addition
to reviewing the numbers that come out of the model, like the p-value
on the F test of the model, the R-square, the p-value on the t test
of the dependent variable, and the p-value of a normality test on
the residual errors.

The trick is, though, it can take time to develop an intuitive feel
for how to read all these numbers and plots, even for a model that's
as (relatively) simple as linear regression.

[D3.js](http://d3js.org/) offers something better, the chance to
animate the relationships between these plots, with [object
constancy](http://bost.ocks.org/mike/constancy/). Maybe it would
be useful to do something like the transitions in the
[showreel](http://bost.ocks.org/mike/constancy/) with the main fit
plot and the diagnostic charts, with constancy among the points in
the dataset to show which lie where in the various plots I mentioned
above from the fit through the diagnostic set. Let's try that.


#### Simple transitions

The first step is to wrap our heads around the timed transitions
in that showreel; I haven't done those before. The key seems to be
the use of `setTimeout(callback_function, delay)` calls at the end
of each function in the [showreel
source](http://bl.ocks.org/mbostock/1256572).  Note that `setTimeout()`
is a [JavaScript timer](http://ejohn.org/blog/how-javascript-timers-work/),
not a D3 function. 

This should be easy to replicate. To try it out, let's just draw a
box, then move it around.

<div id='test1'></div>
<script>
var width = 200;
var height = 200;
var duration = 1000;
var delay = 1000;

var test1 = d3.select("#test1").append("svg")
    .attr("width", width)
    .attr("height", height);

var box = test1.append("rect")
    .attr("id", "box")
    .attr("x", 0)
    .attr("y", 0)
    .attr("width", 100)
    .attr("height", 100)
    .attr("fill", "darkolivegreen");

setTimeout(move_right, duration);

function move_right() {
    test1.select("#box").transition()
        .duration(duration)
        .attr("x", 100);
    setTimeout(move_down, delay + duration);
}

function move_down() {
    test1.select("#box").transition()
        .duration(duration)
        .attr("y", 100);
    setTimeout(move_left, delay + duration);
}

function move_left() {
    test1.select("#box").transition()
        .duration(duration)
        .attr("x", 0);
    setTimeout(move_up, delay + duration);
}

function move_up() {
    test1.select("#box").transition()
        .duration(duration)
        .attr("y", 0);
    setTimeout(move_right, delay + duration);
}

</script>

This is pretty straightforward, we draw a `rect`, then we set the
first timeout to call one of four similar functions that does what
you'd expect:

    setTimeout(move_right, duration);

    function move_right() {
        test1.select("#box").transition()
            .duration(duration)
            .attr("x", 100);
        setTimeout(move_down, delay + duration);
    }

`move_right()` uses d3's `transition()` to shift the `x` over to
100, then sets a time for `move_down()`, which shifts `y` to 100,
then sets a timeout with a similar callback to `move_left()`, then
we go to `move_up()`, which goes back to `move_right()`, and we
have an endless loop of timed transitions.  This might not be a
model for building UI event-driven animations, of course, but we
can settle on this kind of showreel-style series of repeating
transitions to show a cycle of plots.

Note that the `setTimeout` delay on each callback isn't just `delay`
but is rather `delay + duration`. The delay alone runs concurrent
with the transition duration, so if we don't add `duration`, the
delay will end at nearly the same time as the duration! The duration
means the transition will take `duration` milliseconds, but javascript
still executes the following call to `setTimeout` immediately, so
we have to set the delay value to something longer or the box will
never appear to "pause" between transitions.


#### Adding constancy

The next trick is to do the same thing but with multiple moving
points based on data. To do this, we'll expand our model above to
include a simple three-value dataset. We'll still move it right,
down, left, up, then right again, but in each of these quadrants
we'll use a different set of scales to position each element. It's
important to use d3's [data
binding](http://alignedleft.com/tutorials/d3/binding-data) for this
rather than, say, a few `circle` and `rect` elements we could draw
by hand because ultimately we will want to bind real data from a
regression.

We'll use the same structure - four functions with obvious names.
The first time through, we'll place circles using the straight
values as their x and y positions in the upper left quadrant, then
for each of the other functions we'll use different scales to slide
them around inside each following quadrant. I've added lines to 
help distinguish the quadrants.

<div id='test2'></div>
<script>
var width = 200;
var height = 200;
var duration = 1000;
var delay = 1000;

var data = [15, 38, 67, 85];

var test2 = d3.select("#test2").append("svg")
    .attr("width", width)
    .attr("height", height);

var color_scale = d3.scale.ordinal()
    .domain([0, 3])
    .range(["darkgoldenrod", "firebrick", "navajowhite", "slategrey"]);

test2.append("line")
    .attr("x1", 100)
    .attr("y1", 0)
    .attr("x2", 100)
    .attr("y2", 200)
    .attr("stroke", "#bbb");

test2.append("line")
    .attr("x1", 0)
    .attr("y1", 100)
    .attr("x2", 200)
    .attr("y2", 100)
    .attr("stroke", "#bbb");

var g = test2.selectAll("g")
    .data(data)
    .enter().append("g")
        .attr("class", "object");

g.each(function(d, i) {
    var o = d3.select(this);
    o.append("circle")
        .attr("r", 15)
        .attr("cx", d)
        .attr("cy", d)
        .attr("fill-opacity", ".80")
        .attr("fill", color_scale(i));
});

setTimeout(move_right2, duration);

function move_right2() {
    var x = d3.scale.linear()
        .domain([0, 100])
        .range([70, 30]);

    var c = test2.selectAll(".object");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select("circle").transition()
            .duration(duration)
            .attr("cx", x(d))
            .attr("cy", x(d))
            .attr("transform", "translate(100, 0)");
    });

    setTimeout(move_down2, delay + duration);
}

function move_down2() {
    var x = d3.scale.linear()
        .domain([0, 100])
        .range([10, 90]);

    var c = test2.selectAll(".object");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select("circle").transition()
            .duration(duration)
            .attr("cx", x(d))
            .attr("cy", x(d))
            .attr("transform", "translate(100, 100)");
    });
    setTimeout(move_left2, delay + duration);
}

function move_left2() {
    var x = d3.scale.linear()
        .domain([0, 100])
        .range([60, 40]);

    var c = test2.selectAll(".object");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select("circle").transition()
            .duration(duration)
            .attr("cx", x(d))
            .attr("cy", x(d))
            .attr("transform", "translate(0, 100)");
    });
    setTimeout(move_up2, delay + duration);
}

function move_up2() {
    var x = d3.scale.linear()
        .domain([0, 100])
        .range([0, 100]);

    var c = test2.selectAll(".object");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select("circle").transition()
            .duration(duration)
            .attr("cx", x(d))
            .attr("cy", x(d))
            .attr("transform", "translate(0, 0)");
    });
    setTimeout(move_right2, delay + duration);
}

</script>

This works pretty well once you are clear about the scope of the
object you want to operate on. At first we create a set of svg `g`
[group
objects](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/g), and
place `circle`s inside of each:

    var g = test2.selectAll("g")
        .data(data)
        .enter().append("g")
        .attr("class", "object");

        g.each(function(d, i) {
            var o = d3.select(this);
                o.append("circle")
                .attr("r", 15)
                .attr("cx", d)
                .attr("cy", d)
                .attr("fill-opacity", ".80")
                .attr("fill", color_scale(i));
        });

This sets us up with the basic set of "data points" we'll move around.
Then we just start firing up transitions like before, using 
`setTimeout()`, but with each move function doing a little more:

    function move_left2() {
        var x = d3.scale.linear()
            .domain([0, 100])
            .range([60, 40]);

        var c = test2.selectAll(".object");
            c.each(function(d, i) {
                var o = d3.select(this);
                    o.select("circle").transition()
                        .duration(duration)
                        .attr("cx", x(d))
                        .attr("cy", x(d))
                        .attr("transform", "translate(0, 100)");
            });
        setTimeout(move_up2, delay + duration);
    }

First we define a new scale for each quadrant, changing the output
range; in this case, it reverses the ordering, and places the circles
in a narrow band just 20 pixels wide. Next, we select the `.object`s
we created, which pulls up those `g`s we started with, then loops
through the set of them, firing off a transition the moves the `cx`
and `cy` of each according to the new scale, and also resets the
coordinate space to each quadrant in turn.


#### Simulating a regression

We'll use a more substantial dataset when we put it all together,
but for now let's assemble a small dataset and sketch a fit plot
and residual plot transitioning back and forth. I've made up some
values and used R to generate a regression (`d` is just the same
data as in the javascript below):

    Call:
    lm(formula = d ~ seq(0, 10))

    Coefficients:
    (Intercept)   seq(0, 10)  
         18.000        9.036

We can use this regression line to get a feel for transitioning
more elements together, and for some of the extra elements we'll
want to add to make things pop a bit.

<div id='sim'></div>
<script>
var width = 400;
var height = 400;
var duration = 1000;
var delay = 1000;

var data = [15, 22, 34, 53, 48, 60, 95, 79, 88, 109, 92];

var slope = 9.036;
var intercept = 18;
function expected(index) {
    return (slope * index) + intercept;
};

var sim = d3.select("#sim").append("svg")
    .attr("width", width)
    .attr("height", height);

var padding = 20;

var x = d3.scale.linear()
    .domain([0, data.length])
    .range([padding, width - padding]);
var y = d3.scale.linear()
    .domain([d3.min(data), d3.max(data)])
    .range([height - padding, padding]);

var g = sim.selectAll("g")
    .data(data)
    .enter().append("g")
        .attr("class", "object");

sim.append("line")
    .attr("id", "line")
    .attr("x1", x(0))
    .attr("y1", y(intercept))
    .attr("x2", x(11))
    .attr("y2", y(expected(11)))
    .attr("stroke-width", 2)
    .attr("stroke", "steelblue");

g.each(function(d, i) {
    var o = d3.select(this);
    o.attr("class", "observation");
    o.append("line")
        .attr("x1", x(i))
        .attr("y1", y(d))
        .attr("x2", x(i))
        .attr("y2", y(expected(i)))
        .attr("stroke-width", 2)
        .attr("stroke", "gray");
    o.append("circle")
        .attr("r", 5)
        .attr("cx", x(i))
        .attr("cy", y(d))
        .attr("stroke", "black")
        .attr("fill", "darkslategrey");
});


setTimeout(residual, delay);

function fit() {
    line = sim.select("#line").transition()
        .duration(duration)
        .attr("y1", y(intercept))
        .attr("y2", y(expected(11)));

    var c = sim.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.transition()
            .duration(duration)
            .attr("transform", "translate(0, 0)");
    });

    setTimeout(residual, delay + duration);
};

function residual() {
    line = sim.select("#line").transition()
        .duration(duration)
        .attr("y1", height/2)
        .attr("y2", height/2);

    var c = sim.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.transition()
            .duration(duration)
            .attr("transform", "translate(0, " + (200 - y(expected(i))) + ")");
    });

    setTimeout(fit, delay + duration);
};
</script>

For the regression, we apply the results R gave us to define the
slope, intercept, and a function that returns expected values from
the model:

    var slope = 9.036;
    var intercept = 18;
    function expected(index) {
        return (slope * index) + intercept;
        };

This function lets us put in an index number for a data value and
get back what the model expects the data value to be. We can then
use this whenever we need to plot the residual, here in the original
rendering of the data points and residual lines against the model:

    g.each(function(d, i) {
        var o = d3.select(this);
        o.attr("class", "observation");
        o.append("line")
            .attr("x1", x(i))
            .attr("y1", y(d))
            .attr("x2", x(i))
            .attr("y2", y(expected(i)))
            .attr("stroke-width", 2)
            .attr("stroke", "gray");
        o.append("circle")
            .attr("r", 5)
            .attr("cx", x(i))
            .attr("cy", y(d))
            .attr("stroke", "black")
            .attr("fill", "darkslategrey");
    });

The line is vertical, so the x-scale places it horizontally using
the index number. The vertical line segment representing the residual
error starts at the actual value `d` and ends at the expected value
`expected(i)`, with both adjusted to the y-scale using `y()`. Then,
in the residual view/function, we just have to rotate the model
line to "level" (`height/2`) and translate the `g`-wrapped residual
line and data point to level minus the y-scale-adjusted expected
value from the model:

    .attr("transform", "translate(0, " + (200 - y(expected(i))) + ")");

And when we switch back to the "fit" view, we just translate them
back again to `(0, 0)`, and rotate the model line back to the
original regression slope.

This feels like a good stopping point for today. Next time, we'll
pick up from here, add the additional diagnostic plots, and fill
out each stage with axes and other niceties as appropriate.
