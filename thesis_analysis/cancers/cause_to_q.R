"Convert cause-specific death rates to nqx."

library(here)
library(future.apply)
library(tidyverse)
library(tidync)

source(here("thesis_analysis", "cancers", "nqx.R"))

print(availableCores())
plan(multisession(workers = 16))
options(future.globals.maxSize = +Inf)

args <- lst(
  region = "LAD",
  sex = "female",
  model = "car_as_at"
)

nc <- tidync(
  here(
    "data",
    "death_rates",
    str_c(args$region, "_", args$sex, "_", args$model, "_cancers.nc")
  )
)

death_rates <- nc |> hyper_array(force = TRUE)
death_rates <- death_rates$`__xarray_dataarray_variable__`

system.time(
  death_rates <- future_apply(
    X = death_rates,
    MARGIN = c(1, 2, 4, 5),
    FUN = nqx,
    age = hyper_transforms(nc)$age$age,
    ax = rep(NA, length(hyper_transforms(nc)$age$age)),
    n = 80,
    x = 0
  )
)

dimnames(death_rates) <- list(
  year = hyper_transforms(nc)$year$year,
  LAD = hyper_transforms(nc)$LAD$LAD,
  sample = hyper_transforms(nc)$sample$index,
  cause = hyper_transforms(nc)$cause$cause
)

write_rds(
  death_rates,
  here("data", "life_table", str_c(args$region, "_", args$sex, "_", args$model, "_cancers_80q0.rds")),
)
