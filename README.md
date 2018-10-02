senser
================

[![R\_Version\_Badge](https://img.shields.io/badge/R-3.4.4-blue.svg)]() [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/senser)](https://cran.r-project.org/package=senser)

Fiery app that senses stocks, forex and crypto scores, based on the sentiment analysis of trends and topics in news.

How to install this
-------------------

Install the development version directly from GitHub using `devtools`:

``` r
# install.packages('devtools')
devtools::install_github('masterquiroga/senser')
```

Design
------

A REST API that fetches news and posts, and then behind the courtains just does the data-science pipeline modeling through sentiment analysis.
