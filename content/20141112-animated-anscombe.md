Title:  animated Anscombe

Using the sketch developed in animating regression parts
[1](http://data.onebiglibrary.net/2014/09/18/animating-regression/) and
[2](http://data.onebiglibrary.net/2014/10/18/animating-regression-part-2/),
let's take a look at [Anscombe's
Quartet](http://en.wikipedia.org/wiki/Anscombe's_quartet). What
makes these datasets useful, as wikipedia points out, is their
near-equivalent stats: the x and y sets share the same mean, sample
variance, correlation and simple linear regression model. It's
instructive as a clear example of what to watch out for.

The challenge here is to use the sketch developed in part 2 four
times. That code is a mess; it reflects my learning process, but
it's not anything I'd want to reuse. The simplest approach to solving
this is to turn the viz element into a [reusable
chart](http://bost.ocks.org/mike/chart/) (to-read also: [Exploring
Reusability with D3.js](http://bocoup.com/weblog/reusability-with-d3/))

I'm under several class deadlines just now, so I won't go as far
as possible in making this nice and cleanly configurable and
modifiable, but I certainly don't want to write the same code out
four times, so I'll look for a middle ground that achieves some
code cleanup and a minimum of reuse.

First off, we need to pull the source data into this page. The
Anscombe datasets and their summary statistics are readily available,
but their linear model residuals and cook's distance values require
a little computing. There are javascript stats libraries that can
handle the regression, but they don't seem to ship with a cook's
distance implementation. (to-do: pull request.) Fortunately R ships
with the data pre-loaded, and it's easy to put all this together
and draw it out as JSON for easy use here:

    library(rjson)
    a1 <- data.frame(anscombe$x1, anscombe$y1)
    names(a1) <- c("x", "y")
    a1fit <- lm(y ~ x, a1)
    a1$cooks <- cooks.distance(a1fit)
    a1$error <- a1fit$residuals
    a1$quantile <- scale(a1$error)
    # repeat for a2, a3, a4
    aout <- vector(mode="list", length=4)
    names(aout) <- c("a1", "a2", "a3", "a4")
    aout$a1 <- a1
    aout$a2 <- a2
    aout$a3 <- a3
    aout$a4 <- a4
    toJSON(aout)

This can be written to a file for later use, like here.

I've made the following changes to the chart:

 * function regcycle() is the reusable chart
 * instead of creating multiple scales and axes, rewrite each within
each plot/view mode function instead
 * move the axis updates to the top of each plot function
 * load the source Anscombe data using a `d3.json()` callback
 * bind the selections and the data to each of the four charts

Let's see how it goes.

<div class="container-fluid">
    <div class="row">
        <div id="a1" class="col-xs-6"></div>
        <div id="a2" class="col-xs-6"></div>
    </div>
    <div class="row">
        <div id="a3" class="col-xs-6"></div>
        <div id="a4" class="col-xs-6"></div>
    </div>
</div>

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
.label {
    font-family: sans-serif;
    font-variant: small-caps;
    font-weight: normal;
    font-size: x-large;
}
</style>

<script>
// Each set in Anscombe's Quartet has the same summary numbers
// Better to use a javascript stats lib to calculate all this
// inside the chart; oh well, a shortcut for now
var xmean = 9;
var ymean = 7.5;
var xsd = 11;
var ysd = 4.1245; // fudging slightly three digits down
var slope = 0.5;
var intercept = 3.0;
var qnorm = [-1.383, -0.967, -0.674, -0.431, -0.210, 0.0, 0.210, 0.431,
    0.674, 0.967, 1.383];

// colorbrewer "spectral" 11
var colors = ["#9e0142", "#d53e4f", "#f46d43", "#fdae61", "#fee08b",
    "#ffffbf", "#e6f598", "#abdda4", "#66c2a5", "#3288bd", "#5e4fa2"];
var color_scale = d3.scale.ordinal()
    .domain([0, 10])
    .range(colors);

function expected(index) {
    return (slope * index) + intercept;
};

function regcycle() {
    var width = 400;
    var height = 400;
    var padding = 30;
    var buffer = 1.1;
    var duration = 2000;
    var delay = 2000;

    function my(sel) {
        // generate a unique id for the named anchors
        var data = [];
        // this seems wrong
        var seldata = sel.data()[0];
        // reshape the data
        for (i=0; i < seldata.x.length; i++) {
            var obs = {
                x: seldata.x[i],
                y: seldata.y[i],
                residual: seldata.error[i], 
                cooks: seldata.cooks[i],
                quantile: seldata.quantile[i],
            };
            data.push(obs); 
        };
        var uid = Math.round(Math.random() * 1024);
        var min_x = d3.min(data, function(d) { return d.x; }) - 1;
        var max_x = d3.max(data, function(d) { return d.x; }) + 1;
        var min_y = d3.min(data, function(d) { return d.y; }) - 1;
        var max_y = d3.max(data, function(d) { return d.y; }) + 1;
        var max_residual = d3.max(data, 
            function(d) { return Math.abs(d.residual); });
        var max_cooks = d3.max(data, function(d) { return d.cooks; })
        var max_quantile = d3.max(data,
            function(d) { return Math.abs(d.quantile); }); 
        var max_qnorm = d3.max(qnorm);

        // if the Cook's values are all low, lower the threshold so
        // we can still discern individual values
        if (max_cooks >= 0.5) {
            if (max_cooks <= 1.1) {
                max_cooks = 1.1;
            };
        };
        // check for NaN values, set a high value if present
        if (seldata.cooks.some(isNaN)) {
            max_cooks = 2;
        };

        var svg = sel.append("svg")
            .attr("width", width)
            .attr("height", height);

        // how much of the setup should be outside of the specific 
        // functions? it's repeating a lot for this first one...

        // x and y scales, axes, for the basic fit plot
        var x = d3.scale.linear()
            .domain([min_x, max_x])
            .range([padding, width - padding]);
        var x_axis = d3.svg.axis()
            .orient("bottom")
            .scale(x);
        var y = d3.scale.linear()
            .domain([min_y, max_y])
            .range([height - padding, padding]);
        var y_axis = d3.svg.axis()
            .orient("left")
            .scale(y);

        // sel contains general data/info like the regression line
        svg.append("line")
            .attr("id", "line" + uid)
            .attr("x1", x(min_x))
            .attr("y1", y(expected(min_x)))
            .attr("x2", x(max_x))
            .attr("y2", y(expected(max_x)))
            .attr("stroke-width", 2)
            .attr("stroke", "steelblue");

        // g binds to the data; this feels like an unneeded two-step
        // when sel is already bound too, perhaps a mistake?
        var g = svg.selectAll("g")
            .data(data)
            .enter().append("g")
            .attr("class", "object");

        // styling elements should be in css, not here
        g.each(function(d, i) {
            var o = d3.select(this);
            o.attr("class", "observation");
            o.append("line")
                .attr("x1", x(d.x))
                .attr("y1", y(d.y))
                .attr("x2", x(d.x))
                .attr("y2", y(expected(d.y)))
                .attr("class", "residual-bar")
                .attr("stroke-width", 0)
                .attr("stroke", "gray");
            o.append("circle")
                .attr("r", 5) // hard-coded!
                .attr("cx", x(d.x))
                .attr("cy", y(d.y))
                .attr("class", "data-point")
                .attr("stroke", "black")
                .attr("fill", color_scale(i));
        });

        // establish initial axes
        svg.append("g")
            .attr("id", "x_axis" + uid)
            .attr("class", "axis")
            .attr("transform", "translate(0, " + (height - padding) + ")")
            .call(x_axis);
        svg.append("g")
            .attr("id", "y_axis" + uid)
            .attr("class", "axis")
            .attr("transform", "translate(" + padding + ", 0)")
            .call(y_axis);

        // initial label
        svg.append("text")
            .attr("id", "label" + uid)
            .attr("class", "label")
            .attr("x", 40) // hard-coded!
            .attr("y", 40) // hard-coded!
            .text("model fit");

        setTimeout(residual, delay);

        // should these be inside this function or one level up?
        // does it matter?
        function fit() {
            // reset scales/axes for fit plot
            x = d3.scale.linear()
                .domain([min_x, max_x])
                .range([padding, width - padding]);
            x_axis = d3.svg.axis()
                .orient("bottom")
                .scale(x);
            y = d3.scale.linear()
                .domain([min_y, max_y])
                .range([height - padding, padding]);
            y_axis = d3.svg.axis()
                .orient("left")
                .scale(y);
            svg.select("#x_axis" + uid).transition()
                .duration(duration)
                .call(x_axis);
            svg.select("#y_axis" + uid).transition()
                .duration(duration)
                .call(y_axis);

            label = svg.select("#label" + uid).transition()
                .duration(duration)
                .text("fit model");

            line = svg.select("#line" + uid).transition()
                .duration(duration)
                .attr("x1", x(min_x))
                .attr("y1", y(expected(min_x)))
                .attr("x2", x(max_x))
                .attr("y2", y(expected(max_x)));

            var c = svg.selectAll(".observation");
            c.each(function(d, i) {
                var o = d3.select(this);
                o.select(".residual-bar").transition()
                    .duration(duration)
                    .attr("x1", x(d.x))
                    .attr("y1", y(d.y))
                    .attr("x2", x(d.x))
                    .attr("y2", y(expected(i)))
                    .attr("stroke-width", 0);
                o.select(".data-point").transition()
                    .duration(duration)
                    .attr("cx", x(d.x))
                    .attr("cy", y(d.y));
            });

            setTimeout(residual, delay + duration);
        };

        function residual() {
            // reset y scale/axis 
            y = d3.scale.linear()
                .domain([-max_residual, max_residual])
                .range([height - padding, padding]);
            y_axis = d3.svg.axis()
                .orient("left")
                .scale(y);
            svg.select("#y_axis" + uid).transition()
                .duration(duration)
                .call(y_axis);

            label = svg.select("#label" + uid).transition()
                .duration(duration)
                .text("residuals");

            line = svg.select("#line" + uid).transition()
                .duration(duration)
                .attr("y1", y(0))
                .attr("y2", y(0));

            var c = svg.selectAll(".observation");
            c.each(function(d, i) {
                var o = d3.select(this);
                o.select(".data-point").transition()
                    .duration(duration)
                    .attr("cy", y(d.residual));
                o.select(".residual-bar").transition()
                    .delay(duration)
                    .attr("x1", x(d.x))
                    .attr("y1", y(d.residual))
                    .attr("x2", x(d.x))
                    .attr("y2", y(0))
                    .attr("stroke-width", 3); // style hard-coded
            });

            setTimeout(cooks, delay + duration);
        };

        function cooks() {
            // reset scale / axis for cooks, x in order, not by value
            x = d3.scale.linear()
                .domain([0, data.length])
                .range([padding, width - padding]);
            x_axis = d3.svg.axis()
                .orient("bottom")
                .scale(x);
            svg.select("#x_axis" + uid).transition()
                .duration(duration)
                .call(x_axis);
            y = d3.scale.linear()
                .domain([0, max_cooks])
                .range([height - padding, padding]);
            y_axis= d3.svg.axis()
                .orient("left")
                .scale(y);
            svg.select("#y_axis" + uid).transition()
                .duration(duration)
                .call(y_axis);

            label = svg.select("#label" + uid).transition()
                .duration(duration)
                .text("cook's distance");

            line = svg.select("#line" + uid).transition()
                .duration(duration)
                .attr("x1", x(0))
                .attr("y1", y(1))
                .attr("x2", x(data.length))
                .attr("y2", y(1));

            var c = svg.selectAll(".observation");
            c.each(function(d, i) {
                var o = d3.select(this);
                o.select(".data-point").transition()
                    .duration(duration)
                    .attr("cx", x(i + 1))
                    .attr("cy", y(isNaN(d.cooks) ? 50 : d.cooks));
                o.select(".residual-bar").transition()
                    .duration(duration)
                    .attr("x1", x(i + 1))
                    .attr("y1", y(isNaN(d.cooks) ? 50 : d.cooks))
                    .attr("x2", x(i + 1))
                    .attr("y2", y(0));
            });

            setTimeout(qq, delay + duration);
        };

        function qq() {
            // reset x scale/axis to normal quantiles
            x = d3.scale.linear()
                .domain([-max_qnorm * buffer, max_qnorm * buffer])
                .range([padding, width - padding]);
            x_axis = d3.svg.axis()
                .orient("bottom")
                .scale(x);
            svg.select("#x_axis" + uid).transition()
                .duration(duration)
                .call(x_axis);

            // reset y scale/axis to observed quantiles
            y = d3.scale.linear()
                .domain([-max_quantile * buffer, max_quantile * buffer])
                .range([height - padding, padding]);
            y_axis= d3.svg.axis()
                .orient("left")
                .scale(y);
            svg.select("#y_axis" + uid).transition()
                .duration(duration)
                .call(y_axis);

            label = svg.select("#label" + uid).transition()
                .duration(duration)
                .text("q-q normal vs. observed");

            line = svg.select("#line" + uid).transition()
                .duration(duration)
                .attr("y1", y(-max_quantile))
                .attr("y2", y(max_quantile));

            // sort the data to align Q-Q
            var quantiles = data.map(function(d) { return d.quantile; });
            var sorted = quantiles.sort(function(a, b) { return a - b; });
            var c = svg.selectAll(".observation");
            c.each(function(d, i) {
                var o = d3.select(this);
                o.select(".data-point").transition()
                    .duration(duration)
                    .attr("cx", x(qnorm[i]))
                    .attr("cy", y(sorted[i]));
                o.select(".residual-bar").transition()
                    .attr("stroke-width", 0);
            });

            setTimeout(fit, delay + duration);
        };
    };

    // add accessors here some other time :)
    return my;
};

// init the four charts
var a1_cycle = regcycle();
var a2_cycle = regcycle();
var a3_cycle = regcycle();
var a4_cycle = regcycle();

// grab data, bind to charts, and render
d3.json("/data/20141112-animating-anscombe.json", function(data) {
    d3.select("#a1")
        .datum(data.a1)
        .call(a1_cycle);
    d3.select("#a2")
        .datum(data.a2)
        .call(a2_cycle);
    d3.select("#a3")
        .datum(data.a3)
        .call(a3_cycle);
    d3.select("#a4")
        .datum(data.a4)
        .call(a4_cycle);
});
</script>

