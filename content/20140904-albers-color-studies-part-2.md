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
</div>


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
</div>

Each has its own distinct feel, right? Albers suggests using sheets
of paper or your hands to block out smaller sets to look at in turn:
a row, a column, etc., and considering which combinations are your
favorite and why.
