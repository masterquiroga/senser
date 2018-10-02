context('webcrawl')
library('tidyverse')
library('rvest')

test_that('crawl_stocks gets S&P500 components table', {
  n <- 20
  stocks <- crawl_stocks(n)
  stocks %>% nrow() %>% expect_equal(n)
  stocks %>% map_chr(class) %>% expect_equal(c('integer', 'character', 'character', 'numeric'))
  stocks %>% colnames() %>% expect_equal(c('company_id','company', 'ticker', 'weight'))
  stocks$weight %>% diff() %>% `<=`(0) %>% all() %>% expect_true()
})

test_that('crawl_news gets stock news table', {
  n <- 20
  news <- crawl_stocks(n) %>% crawl_news()
  news %>% map_chr(class) %>% expect_equal(c('integer', 'character', 'numeric'))
  news %>% colnames() %>% expect_equal(c('news_id', 'ticker', 'text'))
})


test_that('crawl_description gets stock descriptions table', {
  n <- 20
  news <- crawl_stocks(n) %>% crawl_description()
  news %>% map_chr(class) %>% expect_equal(c('integer', 'character', 'numeric'))
  news %>% colnames() %>% expect_equal(c('description_id', 'ticker', 'text'))
})
