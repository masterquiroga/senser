require('tidyverse')
require('rvest')

news_url <- 'https://www.marketwatch.com/investing/stock'
stocks_url <- 'https://www.slickcharts.com/sp500'

#' Crawl stocks up to the first n best
#'
#' @param n the number of stocks to crawl
#' @return
#' @examples
#' crawl_stocks(10)
#' @export
crawl_stocks <- function(n = 20){
  read_html(stocks_url) %>%
    html_table() %>%
    `[[`(1) %>% slice(1:n) %>% select(1:4) %>%
    `names<-`(c('company_id','company','ticker','weight')) %>% as.tibble()
}

#' Gets news from a stock
#'
#' @param ticker character stock symbol ticker
#' @return character vector with headlines
#' @examples
#' get_news('aapl')
#' @export
get_news <- function(ticker) {
  news_url %>% paste(ticker, sep =  '/') %>%
    read_html() %>% html_nodes(xpath = './/div[contains(@data-type,"MarketWatch")]//h3[contains(@class,"article__headline")]/a') %>%
    html_text()
}

#' Gets description from a stock
#'
#' @param ticker character stock symbol ticker
#' @return
#' @examples
#' get_description('aapl')
#' @export
get_description <- function(ticker) {
  news_url %>% paste(ticker, sep = '/') %>%
    read_html() %>% html_nodes(xpath = './/p[contains(@class, "description__text")]') %>%
    html_text() %>% trimws('both') %>% gsub('\\s*\\(See Full Profile\\)$', '', x = .)
}

#' Crawl news from stocks
#'
#' @param stocks tibble stocks
#' @return tibble with stock news
#' @examples
#' crawl_stocks() %>% crawl_news()
#' @export
crawl_news <- function(stocks) {
  stocks$ticker %>%
    map_dfr( ~ tibble(ticker = .x, text = get_news(.x))) %>%
    rownames_to_column('news_id')
}

#' Crawl description from stocks
#'
#' @param stocks tibble stocks
#' @return tibble stock descriptions
#' @examples
#' crawl_stocks() %>% crawl_description()
#' @export
crawl_description <- function(stocks) {
  stocks$ticker %>% map_dfr( ~ tibble(ticker = .x, description = get_description(.x))) %>%
    rownames_to_column('description_id')
}
