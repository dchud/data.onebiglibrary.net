Title:      testing raw html markup

This is a test of raw html.

### This is a markdown h3.

<h3>This is a raw html h1.</h3>

#### A test of D3 loading / execution

Below this is raw html to load d3 and draw something.

<div id='viz'></div>
<script>
    var width = 400;
    var height = 200;
    var svg = d3.select("#viz").append("svg")
      .attr("width", width)
      .attr("height", height);
    var circle = svg.append("circle")
      .attr("cx", width / 2)
      .attr("cy", height / 2)
      .attr("r", 100)
      .attr("fill", "#5DAAD4");
</script>

Did it work?
