source('./R/webcrawl.R')
require('routr')
require('formattable')

is_invalid <- function(x) {
  if.else(typeof(x) == 'character', x == '', is.na(x) | is.nan(x) | is.null(x))
}

format_plain <- function(x) {
  paste(capture.output(write.table(x, sep = "\t\t\t|")), collapse = '\n')
}

webcrawl <- Route$new()
webcrawl$add_handler('get', '/stocks/:n', function(request, response, keys, ...) {
  response$status <- 200L
  response$type <- 'text/plain'
  response$body <- crawl_stocks(keys$n)
  TRUE
})
webcrawl$add_handler('get', '/stocks', function(request, response, keys, ...) {
  response$status <- 200L
  response$type <- 'text/plain'
  response$body <- crawl_stocks(505)
  TRUE
})
webcrawl$add_handler('get', '/description', function(request, response, keys, ...) {
  response$status <- 200L
  response$type <- 'text/plain'
  response$body <- crawl_stocks() %>% crawl_description()
  TRUE
})
webcrawl$add_handler('get', '/description/:ticker', function(request, response, keys, ...) {
  response$status <- 200L
  response$type <- 'text/plain'
  response$body <- crawl_description(data.frame(ticker = keys$ticker))
  TRUE
})
webcrawl$add_handler('get', '/news/:ticker', function(request, response, keys, ...) {
  response$status <- 200L
  response$type <- 'text/plain'
  response$body <- crawl_news(data.frame(ticker = keys$ticker))
  TRUE
})
webcrawl$add_handler('get', '/news', function(request, response, keys, ...) {
  response$status <- 200L
  response$type <- 'text/plain'
  response$body <- crawl_stocks() %>% crawl_news()
  TRUE
})
webcrawl$add_handler('get', '/*', function(request, response, keys, ...) {
  response$status <- 404L
  response$body <- list(h1 = "No encontrado :'(")
  FALSE
})



parser <- Route$new()
parser$add_handler('all', '/*', function(request, response, keys, ...) {
  request$parse(reqres::default_parsers)
})


formatter <- Route$new()

formats <- reqres::default_formatters
formats$`text/plain` = format_plain
formatter$add_handler('all', '/*', function(request, response, keys, ...) {
  response$format(formats)
})

router <- RouteStack$new()
router$add_route(parser, 'request_prep')
router$add_route(webcrawl, 'app_logic')
router$add_route(formatter, 'response_finish')
router
