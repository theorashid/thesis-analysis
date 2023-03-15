map_skeleton <- list(
  geom_sf(colour = "white", linewidth = 0.01),
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
