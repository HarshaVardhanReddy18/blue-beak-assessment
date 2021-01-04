library(plumber)
library(promises)
library(future)
plan(multisession)
pr("C:/Users/H/Documents/RFILES/plumber.R") %>% pr_run(port=8000)

