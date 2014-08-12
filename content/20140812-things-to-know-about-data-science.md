Title:      7±2 things to know about data science

<em>For a talk given at code4lib DC 2014.</em>


## Background

I am a professional librarian and software developer with 17 years
in the job post master's. I studied at a strong school, worked at
some great institutions and worked with many great people and between
all this I've learned a lot about being a hacker / librarian, enough
that the good people at GW Libraries saw fit to hire me to manage
a team exactly three years ago.

I am a student of data science, halfway through a two-year program
at [GW School of Business](http://gwanalytics.org/).  So far I have
learned enough to understand a fair amount about what it is I need
to be able to do to apply data science, but I am not yet very good
at doing that.

As a manager in tech in a research library, my job is to work to
ensure that our team and our library do meaningful work well,
reliably.  I intend to develop my professional skill at working
with data to meet this same goal:  do meaningful work reliably well.
With that in mind, I have a rough sense of what librarian and
archivist colleagues might need to know about data science means,
but I still have an awful lot to learn.


## Defining "data science" and "business analytics"

Like many aspects of data science, this is best communicated visually.

Here is a canonical industry view of required skills many of us like:

![Data Science Venn Diagram](http://static.squarespace.com/static/5150aec6e4b0e340ec52710a/t/51525c33e4b0b3e0d10f77ab/1364352052403/Data_Science_VD.png?format=1500w) 

<cite>by Drew Conway, see [http://drewconway.com/zia/2013/3/26/the-data-science-venn-diagram](http://drewconway.com/zia/2013/3/26/the-data-science-venn-diagram)</cite>

A layer-cake view of analytics tasks that is also helpful:

![Categories of Analytics](http://www.theorsociety.com/Media/Images/Users/CaraQuinton01011978/ActualSize/17_05_2012-16_06_56.jpg) 

<cite>by Gavin Blackett, see [http://www.theorsociety.com/Media/Images/Users/CaraQuinton01011978/ActualSize/17_05_2012-16_06_56.jpg](http://www.theorsociety.com/Media/Images/Users/CaraQuinton01011978/ActualSize/17_05_2012-16_06_56.jpg)</cite>

The questions we ask at these levels, phrased simply:

![Types of Business Analytics Capabilities](http://www.morganfranklin.com/website/assets/uploads/weblog/_658_370/4TypesofBusinessAnalyticsCapabilities_658x370px.jpg)

<cite>by MorganFranklin Consulting, see [http://www.morganfranklin.com/insights/article/4-types-of-business-analytics-capabilities](http://www.morganfranklin.com/insights/article/4-types-of-business-analytics-capabilities)</cite>

Lisa Kurt defined a helpful paradigm for this view at code4lib 2012
in Seattle:

![DIPP Framework](http://www.mu-sigma.com/analytics/images/dipp.png)

<cite>by Mu Sigma, see [http://www.mu-sigma.com/analytics/ecosystem/dipp.html](http://www.mu-sigma.com/analytics/ecosystem/dipp.html)</cite>

Most simply, we can speak of data science as the application of
statistics to support decisions, to understand patterns in data,
and to reduce or at least clarify uncertainty in a wide range of
domains.


## Applying data science

From where I sit (halfway through a degree program) the ability to
apply data science techniques meaningfully comes down to something
more like this:

<div id='skill-venn'></div>
<script>
var width = 800, height = 600;
var svg = d3.select("#skill-venn").append("svg")
    .attr("width", width)
    .attr("height", height);
svg.append("svg:circle")
    .attr("cx", 300)
    .attr("cy", 200)
    .attr("r", 200)
    .style("fill", "#1b9e77")
    .style("fill-opacity", ".5");
svg.append("svg:circle")
    .attr("cx", 500)
    .attr("cy", 200)
    .attr("r", 200)
    .style("fill", "#d95f02")
    .style("fill-opacity", ".5");
svg.append("svg:circle")
    .attr("cx", 400)
    .attr("cy", 400)
    .attr("r", 200)
    .style("fill", "#7570b3")
    .style("fill-opacity", ".5");
svg.append("svg:text")
    .attr("x", 160)
    .attr("y", 160)
    .style("font-size", "36px")
    .style("fill", "black")
    .text("Science");
svg.append("svg:text")
    .attr("x", 550)
    .attr("y", 160)
    .style("font-size", "36px")
    .style("fill", "black")
    .text("Skill");
svg.append("svg:text")
    .attr("x", 300)
    .attr("y", 480)
    .style("font-size", "36px")
    .style("fill", "black")
    .text("Good sense");
</script>

Can you identify the Danger Zone?

I am weak on Science, but improving. I am confident in the hacking
side of my Skill, but not yet in applying statistical models. I
would like to believe I have good sense, but there is an art to
applying it here.


## Asking the right questions

Much of this work comes down to knowing which questions to ask and
being steadfast in attempting to answer them honestly:

* What goal do we wish to achieve?
* What data do we have to work with?
* What gaps in data do we need to fill, and how can we fill them?
* What assumptions are we working under, and are they acceptable?
* Which of the many available models fits our data and goals well?
* What bias is inherent in our data, and what bias are we introducing?
* With what level of certainty can we make a claim?

It is particularly risky to learn one model (e.g. linear regression)
and one tool (e.g. R) and take whatever data you have and only ever
attempt linear regressions with R without asking and answering these
other questions.  It's not about R (or SAS or Python or SPSS or
Julia or Stata or Excel or ...) being a magic tool, and linear
regression might be a poor fit for your data.


## Data context switching, aka munging

> <strong>There is no such thing as a clean data set.</strong>

This is important.

Any data you start with will have been collected or prepared with
a particular purpose. That purpose might or might not have anything
to do with your goals. You will most likely need to reframe the
data you start with to fit your needs. This might involve ETL
pipeline processing, recontextualizing, extracting, summarizing,
merging, splitting, and otherwise reshaping data.

Any decent data person will need to become proficient at some or
all of these tasks.

There are even style guides for data, such as Hadley Wickham's
[Tidy Data](http://vita.had.co.nz/papers/tidy-data.pdf), which 
proposed the following principles of tidiness:

> * Each variable forms a column.
> * Each observation forms a row.
> * Each type of observational unit forms a table.

Some tools have their own preferences; in SAS, some procedures like
"wide form" (each variable a column) and others "long form" (variable
names parameterized). All the more reason to develop munging skills.

Data munging is often the most time-consuming part of statistics
work.

Sound familiar?


## Applying models

There are many, many types of models. Different models can be used
for different tasks as shown in the diagram above.  Some, like
simple regression, are widely applicable and easy to understand.
Many are narrowly applicable and hard to understand, but prove to
be far more effective for certain use cases.

Work with most models require similar steps:

* Prep sample data to apply the model
* Use 2-3 visualizations to explore the data
* Re-munge data to apply the model
* Run the model, evaluating results
* Review residuals/errors
* Check model assumptions, bias
* Lather, rinse, repeat

After all that, you'll probably want to try all of the above again
with another model. Or two or three.

Half of understanding a model is understanding what to look for in
results, and how to evaluate assumptions and results. It is easy
to think you might have a great model, but if you don't know how
to evaluate residuals and check basic model assumptions, your work
might not be meaningful.

Here is an example of what this might look like, using SAS.

First, we import data in an attempt to find a relationship between
age and weight. The data looks like this (thanks,
[csvkit](https://csvkit.readthedocs.org/en/0.8.0/)!):

![a few lines of data]({filename}images/20140812-things/csvlook.png)

A simple regression offers these results:

![regression results]({filename}images/20140812-things/b3-simple-regression-table.png)

Every stats app has a report format like this; SAS likes HTML tables.
Important details in here are the p-value of the F test result, the
R-Square, and the p-value of the t test on the dependent variable age.

The plot is pretty:

![regression plot]({filename}images/20140812-things/b3-simple-regression-plot.png)

But we have to review its diagnostics:

![regression diagnostics]({filename}images/20140812-things/b3-simple-regression-diag.png)

And check residuals precisely:

![regression residuals]({filename}images/20140812-things/b3-simple-regression-residuals-b.png)

To be a good data scientist, you have to work any model through all
of these steps, knowing which tests to run on results. Every model
has its own characteristics.


## Applying tools

In some cases, there are straightforward models that can be applied
with straightforward tools. For example, this is a time series of 
the amount of recent airline travel in the US. In just a few lines 
of R, you can produce this decomposition of seasonal and trend lines:

![time series decomposition]({filename}images/20140812-things/ts-decomp.png)

This is wonderful, but keep in mind that there is always more to the
story. The simplest-seeming models and tools often require a lot of
subtlety to wield reliably well.

For more on this particular example, see [Using R for Time Series
Analysis](http://a-little-book-of-r-for-time-series.readthedocs.org/en/latest/src/timeseries.html).



## Learning the craft

On this part I'm shaky, but my hunch is that like learning to be a
competent programmer, applying meaningful data science reliably
well is a craft that takes time to learn. It took me a good five
years to learn many basic lessons about programming that no CS prof
ever taught me (granted, I don't have a CS degree, but I've taken
many of the basic courses in formal settings). After five years, I
was a good enough programmer to get a job on a great team, where I
really started to learn the craft - all the details you need to
attend to if you want to build systems that scale up, and if you
want to sustain projects over years, through staff turnover and
changing technologies.

Like with CS, the science is critical, but it seems like it will
take me several years and a lot of repetition to develop the kind
of intuitive feel for choosing models, checking assumptions, and
explaining results. It's that "good sense" I know I need to strive
for, but I don't have it yet. Before I start applying any of this
on data in my workplace, I'll be sure to find someone more experienced
than me to run ideas by, someone who knows the craft well already.


## What can we do to help?

* Fill in gaps on campus
* Support critical thinking in data selection, munging, and application
* Encourage a well-rounded view, especially with Ethics
* Apply our experience with workflows and conventions
* Learn and apply for ourselves


## What next?

* [Probability and statistics](https://www.khanacademy.org/math/probability) on Khan Academy
* [Johns Hopkins Data Science Specialization](https://www.coursera.org/specialization/jhudatascience/1) on Coursera
* Leek et al., [How to share data with a statistician](https://github.com/jtleek/datasharing)
* Provost and Fawcett, [Data Science for Business](http://www.data-science-for-biz.com/)
