library(tidyverse)
library(scales)
library(colorspace)
library(ggbeeswarm)
library(ggridges)
library(sf)

map_skeleton <- list(
  geom_sf(colour = "white", linewidth = 0.01),
  theme_void(),
  theme(legend.position = "none")
)

map_skeleton_msoa <- list(
  geom_sf(colour = NA, linewidth = 0.01),
  theme_void(),
  theme(legend.position = "none")
)

ridge_skeleton <- list(
  geom_density_ridges_gradient(colour = "#cccccc", size = 0.1),
  scale_y_continuous(expand = c(0, 0)),
  theme_void(),
  theme(
    legend.direction = "horizontal",
    legend.position = "bottom",
    legend.key.width = unit(9, units = "pt"),
    legend.key.height = unit(3, units = "pt"),
    legend.text = element_text(size = 3),
    legend.title = element_text(
      size = 3,
      face = "bold"
    )
  ),
  guides(
    fill = guide_colorbar(
      title.position = "bottom",
      title.hjust = 0
    )
  )
)

jitter_change_skeleton <- list(
  geom_hline(yintercept = 0, linewidth = 0.05, alpha = 0.5),
  geom_beeswarm(size = 0.1, stroke = 0.1, shape = 16, cex = 0.18, side = 1L),
  scale_colour_continuous_divergingx(
    palette = "Zissou",
    name = "Percentile of life expectancy at the start of each time period",
    mid = 0.5,
    rev = TRUE,
    limits = c(0, 1),
    labels = percent
  ),
  labs(
    x = "Time period",
    y = "Life expectancy change during period (years)"
  ),
  theme_thesis(),
  theme(
    axis.ticks.x = element_blank(),
    axis.line = element_blank(),
    panel.border = element_blank(),
    legend.direction = "horizontal",
    legend.position = "bottom",
    legend.key.width = unit(30, units = "pt"),
    legend.key.height = unit(5, units = "pt"),
    legend.title = element_text(
      size = 5,
      face = "bold"
    )
  ),
  guides(
    colour = guide_colourbar(
      title.position = "top",
      title.hjust = 0
    )
  )
)

pair_skeleton <- list(
  scale_fill_continuous_divergingx(
    palette = "BrBG",
    rev = TRUE,
    mid = 0,
    limits = c(-1, 1),
    name = "Correlation"
  ),
  guides(
    fill = guide_colorbar(
      title.position = "top",
      title.hjust = 0
    )
  ),
  theme(
    axis.line = element_blank(),
    legend.direction = "horizontal",
    legend.key.width = unit(15, units = "pt"),
    legend.key.height = unit(5, units = "pt"),
    legend.text = element_text(size = 5),
    legend.title = element_text(
      size = 5,
      face = "bold"
    )
  )
)
