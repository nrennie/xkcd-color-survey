library(xkcdcolors)
library(dplyr)
library(readr)

rgb_ranks <- xcolors() |>
  data.frame(color = _) |>
  as_tibble() |>
  mutate(
    rank = row_number(),
    hex = name2color(color)
  )

write_csv(rgb_ranks, "data/clean/color_ranks.csv")
