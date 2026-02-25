Title:  animating regression, part 2

Returning to the question of animating a regression model and its
residuals. [Part
1](http://data.onebiglibrary.net/2014/09/18/animating-regression/) stepped
forward through basic animation with d3 toward a simplistic regression
model and a first view of residuals. Let's take that through two
new views, a Q-Q plot and a plot of potential outliers with Cook's
Distance. In this part we'll complete a full cycle through these four
plots, and in a final piece we'll review and tweak the look of it all
and add some more interesting data into the mix.

Picking up where we left off, we have a regression line transitioning
to a view of residuals. Let's start by emphasizing that those residual
distances are most valuable in the latter view, and remove them from the
model view.

<div id='fig1'></div>
<script>
var width = 400;
var height = 400;
var duration = 2000;
var delay = 2000;

var data = [15, 22, 34, 53, 48, 60, 95, 79, 88, 109, 92];

var slope = 9.036;
var intercept = 18;
function expected(index) {
    return (slope * index) + intercept;
};

var fig1 = d3.select("#fig1").append("svg")
    .attr("width", width)
    .attr("height", height);

var padding = 30;

var x = d3.scale.linear()
    .domain([0, data.length])
    .range([padding, width - padding]);
var y = d3.scale.linear()
    .domain([d3.min(data), d3.max(data)])
    .range([height - padding, padding]);

var g = fig1.selectAll("g")
        .data(data)
        .enter().append("g")
        .attr("class", "object");

fig1.append("line")
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
        .attr("class", "residual-bar")
        .attr("stroke-width", 0)
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
    line = fig1.select("#line").transition()
        .duration(duration)
        .attr("y1", y(intercept))
        .attr("y2", y(expected(11)));

    var c = fig1.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.transition()
            .duration(duration)
            .attr("transform", "translate(0, 0)");
        residual_bars = o.select(".residual-bar").transition()
            .duration(duration)
            .attr("stroke-width", 0);
    });

    setTimeout(residual, delay + duration);
};

function residual() {
    line = fig1.select("#line").transition()
        .duration(duration)
        .attr("y1", height/2)
        .attr("y2", height/2);

    var c = fig1.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.transition()
            .duration(duration)
            .attr("transform", "translate(0, " + (200 - y(expected(i))) + ")");
        residual_bars = o.select(".residual-bar").transition()
            .delay(delay / 2)
            .duration(duration)
            .attr("stroke-width", 3);
    });

    setTimeout(fit, delay + duration);
};
</script>


#### Showing residuals properly

Let's improve on this by showing appropriate axes for each view.
Then, during the transitions, we will re-scale the y-axis to the
residual values and back to the true data points again.


<div id='fig2'></div>
<style>
.axis path,
.axis line {
    fill: none;
    stroke: black;
    shape-rendering: crispEdges;
}
.axis text {
    font-family: sans-serif;
    font-size: 11px;
}
</style>

<script>
// using same data, add in the residuals too this time
var residuals = [];
data.forEach(function(d, i) {
    residuals.push(expected(i) - d);
});
var max_residual = d3.max(residuals, function(d) { return Math.abs(d); });

var fig2 = d3.select("#fig2").append("svg")
    .attr("width", width)
    .attr("height", height);

var x = d3.scale.linear()
    .domain([0, data.length])
    .range([padding, width - padding]);
var y = d3.scale.linear()
    .domain([d3.min(data), d3.max(data)])
    .range([height - padding, padding]);
var y_residuals = d3.scale.linear()
    .domain([-max_residual, max_residual])
    .range([height - padding, padding]);

var x_axis = d3.svg.axis()
    .orient("bottom")
    .scale(x);
var y_axis = d3.svg.axis()
    .orient("left")
    .scale(y);
var y_residuals_axis = d3.svg.axis()
    .orient("left")
    .scale(y_residuals);

var g = fig2.selectAll("g")
    .data(data)
    .enter().append("g")
    .attr("class", "object");

fig2.append("line")
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
        .attr("class", "residual-bar")
        .attr("stroke-width", 0)
        .attr("stroke", "gray");
    o.append("circle")
        .attr("r", 5)
        .attr("cx", x(i))
        .attr("cy", y(d))
        .attr("stroke", "black")
        .attr("fill", "darkslategrey");
});

fig2.append("g")
    .attr("id", "x_axis")
    .attr("class", "axis")
    .attr("transform", "translate(0, " + (height - padding) + ")")
    .call(x_axis);
fig2.append("g")
    .attr("id", "y_axis")
    .attr("class", "axis")
    .attr("transform", "translate(" + padding + ", 0)")
    .call(y_axis);

setTimeout(residual2, delay);

function fit2() {
    line = fig2.select("#line").transition()
        .duration(duration)
        .attr("y1", y(intercept))
        .attr("y2", y(expected(11)));

    var c = fig2.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.transition()
            .duration(duration)
            .attr("transform", "translate(0, 0)");
        residual_bars = o.select(".residual-bar").transition()
            .duration(duration)
            .attr("stroke-width", 0);
    });

    fig2.select("#y_axis").transition()
        .duration(duration)
        .call(y_axis);

    setTimeout(residual2, delay + duration);
};

function residual2() {
    line = fig2.select("#line").transition()
        .duration(duration)
        .attr("y1", y_residuals(0))
        .attr("y2", y_residuals(0));

    var c = fig2.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.transition()
            .duration(duration)
            .attr("transform",
                "translate(0, " + (y_residuals(0) - y(expected(i))) + ")");
        residual_bars = o.select(".residual-bar").transition()
            .duration(duration)
            .attr("stroke-width", 3);
    });

    fig2.select("#y_axis").transition()
        .duration(duration)
        .call(y_residuals_axis);

    setTimeout(fit2, delay + duration);
};
</script>


Some quick notes about this:

 * To relocate the residuals and the corresponding scale, the residual
 values are now explicitly calculated:

        var residuals = [];
        data.forEach(function(d, i) {
            residuals.push(expected(i) - d);
            });

 * Then, we look for the maximum residual value to define the domain of
 the y-scale:

        var max_residual = d3.max(residuals, function(d) { return Math.abs(d); });
        var y_residuals = d3.scale.linear()
            .domain([-max_residual, max_residual])
            .range([height - padding, padding]);

 * Finally, whereas in the first version above, I just picked an arbitrary 
 y-location (200) to anchor the residual bars after the transition...
 
        o.transition()
            .duration(duration)
            .attr("transform", "translate(0, " + (200 - y(expected(i))) + ")");
 
 * ...now we can locate these correctly according to the residuals scale.
 We just have to replace the arbitrary location with the exact midpoint
 of the y_residuals scale:

        o.transition()
            .duration(duration)
            .attr("transform",
                "translate(0, " + (y_residuals(0) - y(expected(i))) + ")");


#### Adding Cook's Distance

In simple linear regression models like this, outlier values can
influence the slope model significantly, making predictions based
on resulting model with strong outliers less accurate than desired.
A standard way to evaluate whether any outliers exist in a dataset
is to examine [Cook's
Distance](http://en.wikipedia.org/wiki/Cook's_distance).  It's easy
enough to calculate in R:

        fit <- lm(formula=d ~ seq(0, 10))
        cd <- cooks.distance(fit)

The basic rule of thumb is to look for any Cook's Distance values
of 1 or greater. It's easy enough to plot with this in mind, typical
graphs for Cook's D show the values as vertical bars with a horizontal
line at 1. We'll need to transition the y scale/axis again, and a detail
to notice is that the Cook's D values might all be well below 1, so we
need to make a choice:  if the values are well below 1, leave the line
off completely. If any data points approach or pass 1, show the line. The
risk is that if none of the values are particularly large at all (e.g.
all below 0.10, as in the example diagnostics image at the top of
[part 1](http://data.onebiglibrary.net/2014/09/18/animating-regression/))
then if we scale the y axis all the way to 1, the variation among the
small values will blur down into nothing. To handle this, we'll look 
for a mid-range value like 0.33 or 0.5, and if the max Cook's D is
below that line, we'll scale the axis with the narrower value domain;
otherwise, we'll scale it up through 1.

<div id='fig3'></div>
<style>
.axis path,
.axis line {
    fill: none;
    stroke: black;
    shape-rendering: crispEdges;
}
.axis text {
    font-family: sans-serif;
    font-size: 11px;
}
</style>

<script>
// using same data, add in the residuals too this time
var residuals = [];
data.forEach(function(d, i) {
    residuals.push(d - expected(i));
});
var max_residual = d3.max(residuals, function(d) { return Math.abs(d); });

var cooks = [0.0267, 0.0445, 0.0047, 0.045, 0.0202, 0.0048, 0.2774, 0.0037,
    0.0057, 0.1642, 0.7934];
var max_cooks = d3.max(cooks);
if (max_cooks >= 0.5) {
    if (max_cooks >= 1.1) {
        ;
    } else {
        max_cooks = 1.1;
    }
};

var fig3 = d3.select("#fig3").append("svg")
    .attr("width", width)
    .attr("height", height);

var x = d3.scale.linear()
    .domain([0, data.length])
    .range([padding, width - padding]);
var y = d3.scale.linear()
    .domain([d3.min(data), d3.max(data)])
    .range([height - padding, padding]);
var y_residuals = d3.scale.linear()
    .domain([-max_residual, max_residual])
    .range([height - padding, padding]);
var y_cooks = d3.scale.linear()
    .domain([0, max_cooks])
    .range([height - padding, padding]);

var x_axis = d3.svg.axis()
    .orient("bottom")
    .scale(x);
var y_axis = d3.svg.axis()
    .orient("left")
    .scale(y);
var y_residuals_axis = d3.svg.axis()
    .orient("left")
    .scale(y_residuals);
var y_cooks_axis = d3.svg.axis()
    .orient("left")
    .scale(y_cooks)

var g = fig3.selectAll("g")
    .data(data)
    .enter().append("g")
    .attr("class", "object");

fig3.append("line")
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
        .attr("class", "residual-bar")
        .attr("stroke-width", 0)
        .attr("stroke", "gray");
    o.append("circle")
        .attr("r", 5)
        .attr("cx", x(i))
        .attr("cy", y(d))
        .attr("class", "data-point")
        .attr("stroke", "black")
        .attr("fill", "darkslategrey");
});

fig3.append("g")
    .attr("id", "x_axis")
    .attr("class", "axis")
    .attr("transform", "translate(0, " + (height - padding) + ")")
    .call(x_axis);
fig3.append("g")
    .attr("id", "y_axis")
    .attr("class", "axis")
    .attr("transform", "translate(" + padding + ", 0)")
    .call(y_axis);

setTimeout(residual3, delay);

function fit3() {
    line = fig3.select("#line").transition()
        .duration(duration)
        .attr("y1", y(intercept))
        .attr("y2", y(expected(11)));

    var c = fig3.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select(".residual-bar").transition()
            .duration(duration)
            .attr("y1", y(d))
            .attr("y2", y(expected(i)))
            .attr("stroke-width", 0);
        o.select(".data-point").transition()
            .duration(duration)
            .attr("cy", y(d));
    });

    fig3.select("#y_axis").transition()
        .duration(duration)
        .call(y_axis);

    setTimeout(residual3, delay + duration);
};

function residual3() {
    line = fig3.select("#line").transition()
        .duration(duration)
        .attr("y1", y_residuals(0))
        .attr("y2", y_residuals(0));

    var c = fig3.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select(".data-point").transition()
            .duration(duration)
            .attr("cy", y_residuals(residuals[i]));
        o.select(".residual-bar").transition()
            .duration(duration)
            .attr("y1", y_residuals(residuals[i]))
            .attr("y2", y_residuals(0))
            .attr("stroke-width", 3);
    });

    fig3.select("#y_axis").transition()
        .duration(duration)
        .call(y_residuals_axis);

    setTimeout(cooks3, delay + duration);
};

function cooks3() {
    line = fig3.select("#line").transition()
        .duration(duration)
        .attr("y1", y_cooks(1))
        .attr("y2", y_cooks(1));

    var c = fig3.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select(".data-point").transition()
            .duration(duration)
            .attr("cy", y_cooks(cooks[i]));
        o.select(".residual-bar").transition()
            .duration(duration)
            .attr("y1", y_cooks(cooks[i]))
            .attr("y2", y_cooks(0));
    });

    fig3.select("#y_axis").transition()
        .duration(duration)
        .call(y_cooks_axis);

    setTimeout(fit3, delay + duration);
}
</script>


This took some fiddling - ultimately, removing the transform/translate()
bits from the section described earlier made this simpler. Instead
of translating the values, directly setting the y values based on
the appropriate scale functions for each view mode is more direct.
As it turns out, the translation above wasn't even correct, so this
anchors us back in cleaner code with less of a cognitive gap to
verify that the values are accurate. Lesson learned: don't fall
back to SVG translate() when simpler (and higher-order) d3 scales
will do the job.

Once it started working correctly an immediate benefit of this
animation approach became clear. Look at the data point at `x=6`.
It looks as if it's a big outlier, especially when we shift into
the residuals view, where it carries the largest residual error.
But when shifting into the Cook's Distance view, its impact as an
outlier proves to be much less than that of the point at `x=10`,
which is roughly 0.8. This makes intuitive sense when shifting back
to the model fit view; `x=10` drags the slope of the model down
substantially, enough to be wary of, even if not enough to consider
throwing the value out.


#### Adding the Q-Q Plot

To add the [Q-Q plot](http://en.wikipedia.org/wiki/Q%E2%80%93Q_plot)
we have to calculate the quantile of each value and plot that against
normal quantiles. To make it work with the animation loop, though,
we further have to sort the quantiles and plot them all in the
correct order.

The plot itself should be straightforward, with the normal quantiles
and observed values on the x- and y-axis, respectively, and a normal
line running through it all.

Because the axes and points are moving around so much, we'll add
a simple title label and update it as we switch plots.

<div id='fig4'></div>
<style>
.label {
    font-family: sans-serif;
    font-variant: small-caps;
    font-weight: normal;
    font-size: x-large;
}
</style>
<script>
var data4 = [
    {"cooks": 0.0267, "error": -3.0, "q": -1.522, 
        "index": 0, "raw": 15, "qqindex": 0},
    {"cooks": 0.0445, "error": -5.036, "q": -1.3009, 
        "index": 1, "raw": 22, "qqindex": 1},
    {"cooks": 0.0047, "error": -2.072, "q": -0.9218, 
        "index": 2, "raw": 34, "qqindex": 2},
    {"cooks": 0.045, "error": 7.892, "q": -0.3216,
        "index": 3, "raw": 53, "qqindex": 4},
    {"cooks": 0.0202, "error": -6.144, "q": -0.4796,
        "index": 4, "raw": 48, "qqindex": 3},
    {"cooks": 0.0048, "error": -3.18, "q": -0.1005, 
        "index": 5, "raw": 60, "qqindex": 5},
    {"cooks": 0.2774, "error": 22.784, "q": 1.0051, 
        "index": 6, "raw": 95, "qqindex": 7},
    {"cooks": 0.0037, "error": -2.252, "q": 0.4997, 
        "index": 7, "raw": 79, "qqindex": 8},
    {"cooks": 0.0057, "error": -2.288, "q": 0.784, 
        "index": 8, "raw": 88, "qqindex": 10},
    {"cooks": 0.1642, "error": 9.676, "q": 1.4473, 
        "index": 9, "raw": 109, "qqindex": 6},
    {"cooks": 0.7934, "error": -16.36, "q": 0.9103, 
        "index": 10, "raw": 92, "qqindex": 9}
    ];
var qnorm = [-1.383, -0.967, -0.674, -0.431, -0.210, 0.0, 0.210, 0.431,
    0.674, 0.967, 1.383];
var xbar = 63.182;
var min_raw4 = d3.min(data4, function(d) { return d.raw; });
var max_raw4 = d3.max(data4, function(d) { return d.raw; });
var max_residual4 = d3.max(data4, function(d) { return Math.abs(d.error); });
var max_cooks4 = d3.max(data4, function(d) { return d.cooks; });
var max_q = d3.max(data4, function(d) { return Math.abs(d.q); });
var max_qnorm = d3.max(qnorm);
var buffer = 1.1;

if (max_cooks4 >= 0.5) {
    if (max_cooks4 >= 1.1) {
        ;
    } else {
        max_cooks4 = 1.1;
    }
};

var fig4 = d3.select("#fig4").append("svg")
    .attr("width", width)
    .attr("height", height);

var x4 = d3.scale.linear()
    .domain([0, data4.length])
    .range([padding, width - padding]);
var x_qnorm4 = d3.scale.linear()
    .domain([-max_qnorm * buffer, max_qnorm * buffer])
    .range([padding, width - padding]);
var y4 = d3.scale.linear()
    .domain([min_raw4, max_raw4])
    .range([height - padding, padding]);
var y_residuals4 = d3.scale.linear()
    .domain([-max_residual4, max_residual4])
    .range([height - padding, padding]);
var y_cooks4 = d3.scale.linear()
    .domain([0, max_cooks4])
    .range([height - padding, padding]);
var y_q4 = d3.scale.linear()
    .domain([-max_q * buffer, max_q * buffer])
    .range([height - padding, padding]);

var x_axis4 = d3.svg.axis()
    .orient("bottom")
    .scale(x4);
var x_qnorm_axis4 = d3.svg.axis()
    .orient("bottom")
    .scale(x_qnorm4);
var y_axis4 = d3.svg.axis()
    .orient("left")
    .scale(y4);
var y_residuals_axis4 = d3.svg.axis()
    .orient("left")
    .scale(y_residuals4);
var y_cooks_axis4 = d3.svg.axis()
    .orient("left")
    .scale(y_cooks4);
var y_q_axis4 = d3.svg.axis()
    .orient("left")
    .scale(y_q4);

var g4 = fig4.selectAll("g")
    .data(data4)
    .enter().append("g")
    .attr("class", "object");

fig4.append("line")
    .attr("id", "line4")
    .attr("x1", x4(0))
    .attr("y1", y4(intercept))
    .attr("x2", x4(11))
    .attr("y2", y4(expected(11)))
    .attr("stroke-width", 2)
    .attr("stroke", "steelblue");

g4.each(function(d, i) {
    var o = d3.select(this);
    o.attr("class", "observation");
    o.append("line")
        .attr("x1", x4(i))
        .attr("y1", y4(d.raw))
        .attr("x2", x4(i))
        .attr("y2", y4(expected(i)))
        .attr("class", "residual-bar")
        .attr("stroke-width", 0)
        .attr("stroke", "gray");
    o.append("circle")
        .attr("r", 5)
        .attr("cx", x4(i))
        .attr("cy", y4(d.raw))
        .attr("class", "data-point")
        .attr("stroke", "black")
        .attr("fill", "darkslategrey");
});

fig4.append("g")
    .attr("id", "x_axis4")
    .attr("class", "axis")
    .attr("transform", "translate(0, " + (height - padding) + ")")
    .call(x_axis4);
fig4.append("g")
    .attr("id", "y_axis4")
    .attr("class", "axis")
    .attr("transform", "translate(" + padding + ", 0)")
    .call(y_axis4);

fig4.append("text")
    .attr("id", "label")
    .attr("class", "label")
    .attr("x", 40)
    .attr("y", 40)
    .text("model fit");

setTimeout(residual4, delay);

function fit4() {
    label = fig4.select("#label").transition()
        .duration(duration)
        .text("fit model");

    line = fig4.select("#line4").transition()
        .duration(duration)
        .attr("y1", y4(intercept))
        .attr("y2", y4(expected(11)));

    var c = fig4.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select(".residual-bar").transition()
            .duration(duration)
            .attr("x1", x4(i))
            .attr("y1", y4(d.raw))
            .attr("y2", y4(expected(i)))
            .attr("stroke-width", 0);
        o.select(".data-point").transition()
            .duration(duration)
            .attr("cx", x4(i))
            .attr("cy", y4(d.raw));
    });

    fig4.select("#x_axis4").transition()
        .duration(duration)
        .call(x_axis4);
    fig4.select("#y_axis4").transition()
        .duration(duration)
        .call(y_axis4);

    setTimeout(residual4, delay + duration);
};

function residual4() {
    label = fig4.select("#label").transition()
        .duration(duration)
        .text("residuals");

    line = fig4.select("#line4").transition()
        .duration(duration)
        .attr("y1", y_residuals4(0))
        .attr("y2", y_residuals4(0));

    var c = fig4.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select(".data-point").transition()
            .duration(duration)
            .attr("cy", y_residuals4(d.error));
        o.select(".residual-bar").transition()
            .duration(duration)
            .attr("y1", y_residuals4(d.error))
            .attr("y2", y_residuals4(0))
            .attr("stroke-width", 3);
    });

    fig4.select("#y_axis4").transition()
        .duration(duration)
        .call(y_residuals_axis4);

    setTimeout(cooks4, delay + duration);
};

function cooks4() {
    label = fig4.select("#label").transition()
        .duration(duration)
        .text("cook's distance");

    line = fig4.select("#line4").transition()
        .duration(duration)
        .attr("y1", y_cooks4(1))
        .attr("y2", y_cooks4(1));

    var c = fig4.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select(".data-point").transition()
            .duration(duration)
            .attr("cy", y_cooks4(d.cooks));
        o.select(".residual-bar").transition()
            .duration(duration)
            .attr("y1", y_cooks4(d.cooks))
            .attr("y2", y_cooks4(0));
    });

    fig4.select("#y_axis4").transition()
        .duration(duration)
        .call(y_cooks_axis4);

    setTimeout(qq4, delay + duration);
}

function qq4() {
    label = fig4.select("#label").transition()
        .duration(duration)
        .text("q-q normal vs. observed");

    line = fig4.select("#line4").transition()
        .duration(duration)
        .attr("y1", y_q4(-max_q))
        .attr("y2", y_q4(max_q));

    var sorted = data4.sort(function(a, b) { return a.q - b.q; });
    var c = fig4.selectAll(".observation");
    c.each(function(d, i) {
        var o = d3.select(this);
        o.select(".data-point").transition()
            .duration(duration)
            .attr("cx", x_qnorm4(qnorm[i]))
            .attr("cy", y_q4(sorted[i].q));
        o.select(".residual-bar").transition()
            .duration(duration)
            .attr("stroke-width", 0);
    });

    fig4.select("#x_axis4").transition()
        .duration(duration)
        .call(x_qnorm_axis4);
    fig4.select("#y_axis4").transition()
        .duration(duration)
        .call(y_q_axis4);

    setTimeout(fit4, delay + duration);
}
</script>

That rounds out the sketch.

Now: to clean this up enough to be able to use it to render multiple
regressions side-by-side. Stay tuned...
