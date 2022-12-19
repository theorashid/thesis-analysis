"Convert all-cause death rates to e0."

library(here)
library(future.apply)
library(tidyverse)
library(tidync)

source(here("thesis_analysis", "england", "period_life_table.R"))

print(availableCores())
plan(multisession(workers = 16))
options(future.globals.maxSize = +Inf)

args <- lst(
  region = "MSOA",
  sex = "male",
  model = "nested_as_at"
)

nc <- tidync(
  here(
    "data",
    "death_rates",
    str_c(args$region, "_", args$sex, "_", args$model, ".nc")
  )
)

death_rates <- nc |> hyper_array(force = TRUE)
death_rates <- death_rates$`__xarray_dataarray_variable__`

system.time(
  death_rates <- future_apply(
    X = death_rates,
    MARGIN = c(1, 2, 4),
    FUN = PeriodLifeTable,
    age = hyper_transforms(nc)$age$age,
    ax = rep(NA, length(hyper_transforms(nc)$age$age)),
    sex = 1
  )
)

dimnames(death_rates) <- list(
  year = hyper_transforms(nc)$year$year,
  MSOA = hyper_transforms(nc)$MSOA$MSOA,
  sample = hyper_transforms(nc)$sample$index
)

write_rds(
  death_rates,
  here("data", "life_table", str_c(args$region, "_", args$sex, "_", args$model, "_e0.rds")),
)
