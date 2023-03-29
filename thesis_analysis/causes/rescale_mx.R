"Rescale cause-specific death rates to sum to total death rates."

library(here)
library(tidyverse)
library(tidync)

args <- lst(
  region = "LAD",
  sex = "male",
  model = "car_as_at"
)

nc <- tidync(
  here(
    "data",
    "death_rates",
    str_c(args$region, "_", args$sex, "_", args$model, "_causes.nc")
  )
)
death_rates <- nc |> hyper_array(force = TRUE)
death_rates <- death_rates$`__xarray_dataarray_variable__`

death_rates_total <- tidync(
  here(
    "data",
    "death_rates",
    str_c(args$region, "_", args$sex, "_", args$model, ".nc")
  )
) |> hyper_array(force = TRUE)
death_rates_total <- death_rates_total$`__xarray_dataarray_variable__`

scale_factor <- death_rates_total / apply(death_rates, MARGIN = c(1, 2, 3, 4) , FUN = sum)
scaled_death_rates <- sweep(death_rates, c(1, 2, 3, 4), scale_factor, "*")

dimnames(scaled_death_rates) <- list(
  year = hyper_transforms(nc)$year$year,
  LAD = hyper_transforms(nc)$LAD$LAD,
  age = hyper_transforms(nc)$age$age,
  sample = hyper_transforms(nc)$sample$index,
  cause = hyper_transforms(nc)$cause$cause
)

write_rds(
  scaled_death_rates,
  here("data", "death_rates", str_c(args$region, "_", args$sex, "_", args$model, "_causes_scaled.rds")),
)
