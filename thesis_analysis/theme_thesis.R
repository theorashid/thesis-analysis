library(ggplot2)

theme_thesis <- function(base_size = 5,
                         plot_title_size = 10,
                         plot_title_face = "bold",
                         subtitle_size = 8,
                         subtitle_face = "plain",
                         strip_text_size = 5,
                         strip_text_face = "plain",
                         legend_text_size = 5,
                         legend_text_face = "plain",
                         caption_size = 6,
                         caption_face = "bold",
                         axis_text_size = base_size,
                         axis_title_size = 7,
                         axis_title_face = "bold",
                         axis_title_just = "rt",
                         grid_col = "#cccccc",
                         grid = TRUE,
                         axis_col = "#cccccc",
                         axis = FALSE,
                         ticks = FALSE) {
  ret <- ggplot2::theme_minimal(base_size = base_size)

  ret <- ret + theme(legend.background = element_blank())
  ret <- ret + theme(legend.key = element_blank())
  ret <- ret + theme(legend.text = element_text(size = legend_text_size, face = legend_text_face))

  ret <- ret + theme(panel.grid = element_line(color = grid_col, linewidth = 0.2))
  ret <- ret + theme(panel.grid.major = element_line(color = grid_col, linewidth = 0.2))
  ret <- ret + theme(panel.grid.minor = element_line(color = grid_col, linewidth = 0.15))

  ret <- ret + theme(axis.line = element_line(color = "#2b2b2b", linewidth = 0.15))

  ret <- ret + theme(axis.ticks = element_line(linewidth = 0.15))
  ret <- ret + theme(axis.ticks.x = element_line(linewidth = 0.15))
  ret <- ret + theme(axis.ticks.y = element_line(linewidth = 0.15))
  ret <- ret + theme(axis.ticks.length = grid::unit(5, "pt"))

  xj <- switch(tolower(substr(axis_title_just, 1, 1)),
    b = 0,
    l = 0,
    m = 0.5,
    c = 0.5,
    r = 1,
    t = 1
  )
  yj <- switch(tolower(substr(axis_title_just, 2, 2)),
    b = 0,
    l = 0,
    m = 0.5,
    c = 0.5,
    r = 1,
    t = 1
  )

  ret <- ret + theme(axis.text.x = element_text(size = axis_text_size, margin = margin(t = 0)))
  ret <- ret + theme(axis.text.y = element_text(size = axis_text_size, margin = margin(r = 0)))
  ret <- ret + theme(axis.title = element_text(size = axis_title_size))
  ret <- ret + theme(axis.title.x = element_text(hjust = xj, size = axis_title_size, face = axis_title_face))
  ret <- ret + theme(axis.title.y = element_text(hjust = yj, size = axis_title_size, face = axis_title_face))
  ret <- ret + theme(axis.title.y.right = element_text(hjust = yj, size = axis_title_size, angle = 90, face = axis_title_face))
  ret <- ret + theme(strip.text = element_text(hjust = 0, size = strip_text_size, face = strip_text_face))
  ret <- ret + theme(plot.title = element_text(
    hjust = 0, size = plot_title_size, face = plot_title_face
  ))
  ret <- ret + theme(plot.subtitle = element_text(
    hjust = 0, size = subtitle_size, face = subtitle_face
  ))
  ret <- ret + theme(plot.caption = element_text(
    hjust = 1, size = caption_size, face = caption_face
  ))

  ret
}
