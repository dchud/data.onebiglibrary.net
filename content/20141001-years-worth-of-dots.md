Title:      year's worth of dots

For a project at work we've collected a year's worth of samples
from a major non-US social media site. The samples are taken every
30 seconds, a snapshot of the most recent 200 public posts from all
users. This created a lot of files, and along the way we missed
some in chunks for various reasons (network outage, service error,
reboot, etc.). The researcher we're supporting has happily taken a
copy of the 100+ GB (compressed) of data to start poring through,
but asked that we help prepare a simple visualization of the data
that's present - or more importantly, what's missing.

Because it's natural to miss a few files here and there over a
year's time, it's not a problem unless there are big chunks missing
or patterns of errors that make sampling from this data problematic.
An image of what's there and what's not there needs to hit a few key
points:

 * cover the entire collection period (actually ~13 months)
 * show missing files
 * show empty files
 * easily spot large gaps 
 * easily spot significant patterns

In addition to the immediate use (the researcher's own knowledge
of what they have) this visualization needs to work for their
advisors and others interested in the work, so it should be readily
digested, by which I mean:

 * should fit on one screen
 * shouldn't require much explanation

To give a sense of volume, this set of files should be roughly `365
day/yr * 24 hr/day * 120 files/hr = 1,051,200` files. It's a good
number. It's too many to read from disk in realtime, so this will
require preprocessing.


#### First sketch

Let's start with a rough picture of what it will take to fit the
dots onto one screen. One day's worth is `24 * 120 = 2880` dots,
which is too much for one screen width of pixels, but if we can
divide it at least in half, we're getting closer. The 365-day year
is easier; we can multiply it by two or three and still fit a good
number of pixels in. So with this in mind, here's a `1440x730` grid.

<div id='sketch1'></div>
<script>
var width = 1440;
var height = 730;
var sketch1 = d3.select("#sketch1").append("svg")
    .attr("width", width)
    .attr("height", height);

var y = d3.scale.linear()
    .domain([0, 365])
    .range([0, height]);

d3.range(0, 365).forEach(function(ye, yi, ya) {
    sketch1.append("line")
        .attr("x1", 0)
        .attr("y1", y(ye))
        .attr("x2", width)
        .attr("y2", y(ye))
        .attr("stroke", "cadetblue")
        .attr("stroke-width", 1);
    }
);
</script>

Yah ok that's too wide.

Let's try again, but half again as wide, but just for fun (and because
vertical scrolling isn't so hard) let's make it taller.

<div id='sketch2'></div>
<script>
var width = 720;
var height = 1095;
var sketch2 = d3.select("#sketch2").append("svg")
    .attr("width", width)
    .attr("height", height);

var y = d3.scale.linear()
    .domain([0, 365])
    .range([0, height]);

d3.range(0, 365).forEach(function(ye, yi, ya) {
    sketch2.append("line")
        .attr("x1", 0)
        .attr("y1", y(ye))
        .attr("x2", width)
        .attr("y2", y(ye))
        .attr("stroke", "cadetblue")
        .attr("stroke-width", 1);
    }
);
</script>

One more time, with a grid and some date scales to shape it all out better:

<div id='sketch3'></div>
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
var padding = 40;
var width = 720 + padding;
var height = 1095 + padding;
var sketch3 = d3.select("#sketch3").append("svg")
    .attr("width", width)
    .attr("height", height);

var x = d3.scale.linear()
    .domain([0, 720])
    .range([padding, width]);
var y = d3.scale.linear()
    .domain([0, 365])
    .range([padding/2, height - padding/2]);

var x_hours = d3.scale.linear()
    .domain([0, 23])
    .range([padding, width]);
var y_months = d3.scale.linear()
    .domain([0, 12])
    .range([padding/2, height - padding/2]);

d3.range(0, 24).forEach(function(he, hi, ha) {
    sketch3.append("line")
        .attr("x1", x_hours(he))
        .attr("y1", y(0))
        .attr("x2", x_hours(he))
        .attr("y2", y(365))
        .attr("stroke", "#ccc")
        .attr("stroke-width", 2);
    }
);

d3.range(0, 13).forEach(function(me, mi, ma) {
    sketch3.append("line")
        .attr("x1", x(0))
        .attr("y1", y_months(me))
        .attr("x2", x(720))
        .attr("y2", y_months(me))
        .attr("stroke", "#ccc")
        .attr("stroke-width", 2);
    }
);

d3.range(0, 365).forEach(function(ye, yi, ya) {
    sketch3.append("line")
        .attr("x1", x(0))
        .attr("y1", y(ye))
        .attr("x2", x(720))
        .attr("y2", y(ye))
        .attr("stroke", "cadetblue")
        .attr("stroke-width", 1);
    }
);

var x_axis1 = d3.svg.axis()
    .scale(x_hours)
    .orient("bottom");
var x_axis2 = d3.svg.axis()
    .scale(x_hours)
    .orient("top");
sketch3.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(0, " + y(365 + 1) + ")")
    .call(x_axis1);
sketch3.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(0, " + y(0 - 1) + ")")
    .call(x_axis2);

var y_axis = d3.svg.axis()
    .scale(y_months)
    .orient("left");
sketch3.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(" + x(0 - 3) + ", 0)")
    .call(y_axis);

</script>


#### Adding real data

Okay, now we're getting somewhere.  It's time to work with some
real data and place it onto the scales using dates and times. As a
first cut, I've extracted a file count for each hour in the dataset.
This resulted in a json file with content like this:

    ...    
    "2014-09-29 08:00:00Z": 120, 
    "2014-09-29 09:00:00Z": 120, 
    "2014-09-29 10:00:00Z": 119, 
    "2014-09-29 11:00:00Z": 120, 
    "2014-09-29 12:00:00Z": 120, 
    "2014-09-29 13:00:00Z": 120, 
    ...

Loading this into a sketch is easy with `d3.json()`. The keys are
sorted, but just to be thorough I'll also use `d3.min()` and
`d3.max()` to get the first and last date/times from the set.

The next piece of all this is to set the scales to use the dates.
I created that data file knowing that javascript should be able to
parse the dates cleanly; hopefully this will feed right into the
[d3 time scaling
functions](https://github.com/mbostock/d3/wiki/Time-Scales).

Finally, it'll all come together with line segments drawn in for
each hour. The percentage of files available (should be 120 total
for each hour) will feed into a color scale. To see the contrast
of missing files well, the scale will have to be exponential rather
than linear (earlier discussion of which via Albers is written up
[in this
post](http://data.onebiglibrary.net/2014/09/04/albers-color-studies-part-2/)).
Once again, d3 helps us out, with the `d3.scale.pow()` exponential
scaling function. To scale the input domain to the output range using
a power of two, we just set the exponent on the scale as well, and
use colors as the range:

    var color_scale = d3.scale.pow()
        .exponent(2)
        .domain([0, 120])
        .range(["#fff", "#000"]);

This should make missing files lighter, with a missing file or two 
barely noticeable, but more than a dozen or so should be noticeable.

<div id="sketch4"></div>
<style>
.hour line {
    shape-rendering: crispEdges;
}
</style>
<script>
var padding = 70;
var width = 1200 + padding;
var height = 1600 + padding;
var sketch4 = d3.select("#sketch4").append("svg")
    .attr("width", width)
    .attr("height", height);

// 120 is max number of files per hour
var color_scale = d3.scale.pow()
    .exponent(2)
    .domain([0, 120])
    .range(["lightsteelblue", "midnightblue"]);


d3.json("/data/20141001-filecounts.json", render);

var dataset;
var mindate;
var maxdate;

function render(e, json) {
    if (e) return console.warn(e);
    dataset = json;
    dataset.forEach(function(de, di, da) {
        // construct a correct Date object
        dataset[di].push(new Date(de[0]));
        // construct a UTC-midnight-anchored Date for y-positioning
        dataset[di].push(new Date(de[0].slice(0, 10)));// + " 00:00:00Z"));
    });

    // adjust hours to anchor extremes at UTC-midnight
    mindate = new Date(d3.min(dataset, function(d) { return d[2]; }));
    maxdate = new Date(d3.max(dataset, function(d) { return d[2]; }));

    var x = d3.scale.linear()
        .domain([0, 24])
        .range([padding, width - padding/4]);

    var y = d3.time.scale()
        .domain([mindate, maxdate])
        .nice(d3.time.day)
        .rangeRound([padding/2, height - padding/2]);

    var hours = sketch4.selectAll(".hour")
        .data(dataset)
      .enter().append("line")
        .attr("class", "hour")
        .attr("x1", function(d, i) { return x(d[2].getHours()); })
        .attr("y1", function(d, i) { return y(d[3]); })
        .attr("x2", function(d, i) { return x(d[2].getHours() + 1); })
        .attr("y2", function(d, i) { return y(d[3]); })
        .attr("stroke", function(d) { return color_scale(d[1]); })
        .attr("title", function(d) { return d[0] + ": " + d[1] + " files";})
        .attr("stroke-width", 3.5);

    hours.append("svg:title")
        .attr("class", "hourtext")
        .text(function(d) { return d[0] + ": " + d[1] + " files"; });

    // vertical gridlines for hours
    d3.range(0, 24).forEach(function(he, hi, ha) {
        sketch4.append("line")
            .attr("x1", x(he))
            .attr("y1", y(mindate))
            .attr("x2", x(he))
            .attr("y2", y(maxdate))
            .attr("stroke", "#ccc")
            .attr("stroke-width", 2);
        }
    );

    var x_axis1 = d3.svg.axis()
        .scale(x)
        .orient("bottom");
    sketch4.append("g")
        .attr("class", "axis")
        .attr("transform", "translate(0, " + y(maxdate) + ")")
        .call(x_axis1);
    var x_axis2 = d3.svg.axis()
        .scale(x)
        .orient("top");
    sketch4.append("g")
        .attr("class", "axis")
        .attr("transform", "translate(0, " + y(mindate) + ")")
        .call(x_axis2);

    var y_axis = d3.svg.axis()
        .scale(y)
        .orient("left");
    sketch4.append("g")
        .attr("class", "axis")
        .attr("transform", "translate(" + x(0) + ", 0)")
        .call(y_axis);

};

</script>

That's the trick. This meets the purpose, but has two problems:

 * The time zones are off. See the way the first day starts at 00:00
 but stops at 20:00? That's the four-hour adjustment for eastern (US)
 time, which is happening in a way I'm not controlling properly. You can
 see this for yourself by mousing over a 00:00 block; it will show 04:00
 as the hour. It doesn't make sense to do that because it introduces a
 discontinuity. More importantly, it's unclear what time we're looking at
 for any given block, and for this particular case the data was collected
 from a Chinese service, so it's doubly annoying for the researcher to
 have to correct for two offsets. Looks wrong, is wrong.
 * Not working outside of chrome. Need to debug.

For now I have to leave this aside to get back to other projects. It
will be good to circle back around to these to figure out how to get it
right. Can't leave it hanging.

Fyi, I posted this up as a gist with similar text to be visible at
[bl.ocks.org/dchud](http://bl.ocks.org/dchud/5b6f902d410e1e5253a1).
If you want to poke at the code without futzing with the rest of
all this text, follow that link through or go right to [the original
gist](https://gist.github.com/dchud/5b6f902d410e1e5253a1).
