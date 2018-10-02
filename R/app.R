#! /usr/bin/env Rscript
source('./R/route.R')
require('fiery')

app <- fiery::Fire$new()
app$attach(router)
app$ignite(block = F)# if_else(tolower(Sys.getenv('DETTACH_SERVER')) != 'true', F, T))


app$extinguish()
