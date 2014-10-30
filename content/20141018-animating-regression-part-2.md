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

TBD.
