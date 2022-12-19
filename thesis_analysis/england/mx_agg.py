import argparse
from pathlib import Path

import pandas as pd
import xarray as xr

if __name__ == "main":
    parser = argparse.ArgumentParser(description="Mortality regression model")
    parser.add_argument("--region", default="MSOA", type=str)
    parser.add_argument("--sex", default="male", type=str)
    parser.add_argument("--model", default="nested_as_at", type=str)
    args = parser.parse_args()

    p = Path("../../")
    ds = xr.open_dataset(
        p
        / "data"
        / "death_rates"
        / "{}_{}_{}.nc".format(args.region, args.sex, args.model),
        engine="h5netcdf",
    )
    ds["__xarray_dataarray_variable__"].rename("death_rates")

    lookup = pd.read_csv(
        p / "data" / "covariates" / "LSOA_MSOA_LAD_GOR_CTRY_lookup.csv"
    )
    lookup = (
        lookup[["MSOA2011", "LAD2020"]]
        .rename(columns={"MSOA2011": "MSOA", "LAD2020": "LAD"})
        .drop_duplicates()
    )

    lookup.set_index(["MSOA"]).to_xarray()["LAD"]

    population = xr.open_dataset(
        p / "data" / "population" / "{}_{}_population.nc".format(args.region, args.sex),
        engine="h5netcdf",
    )
    ds["population"] = population["population"]

    ds.groupby(group="LAD").map(
        lambda x: (x["death_rates"] * x["population"]).sum(dim="MSOA")
        / x["population"].sum(dim="MSOA")
    ).to_netcdf(
        p
        / "data"
        / "death_rates"
        / "{}_LAD_{}_{}.nc".format(args.region, args.sex, args.model)
    )

    (
        (ds["death_rates"] * ds["population"]).sum(dim="MSOA")
        / ds["population"].sum(dim="MSOA")
    ).to_netcdf(
        p
        / "data"
        / "death_rates"
        / "{}_GLOBAL_{}_{}.nc".format(args.region, args.sex, args.model)
    )
