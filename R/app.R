#! /usr/bin/env Rscript
source('./R/route.R')
require('fiery')

app <- fiery::Fire$new()
app$attach(router)
app$ignite(block = if_else(tolower(Sys.getenv('DETTACH_SERVER')) != 'true', T, F))
# In Terminal (or visit in browser)
# curl http://127.0.0.1:8080/hello/mars/
# <h1>Hello Mars!</h1>
# app$extinguish()
