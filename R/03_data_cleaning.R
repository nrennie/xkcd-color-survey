# Packages
library(tidyverse)

# Read data
names <- read_csv("data/raw/names.csv")
users <- read_csv("data/raw/users.csv")
answers <- read_csv("data/raw/answers.csv")

# Cleaning

# Users
users_clean <- users |> 
  select(id, monitor, ychrom, colorblind, spamprob) |> 
  rename(spam_prob = spamprob,
         y_chromosome = ychrom,
         user_id = id)
write_csv(users_clean, "data/clean/users.csv")

# Answers
color_lookup <- rgb_ranks |> 
  slice_head(n = 5) |> 
  select(color, rank)
answers_clean <- answers |> 
  filter(colorname %in% rgb_ranks$color[1:5]) |> 
  select(user_id, r, g, b, colorname) |> 
  arrange(user_id) |> 
  mutate(hex = rgb(r, g, b, maxColorValue = 255),
         user_id = as.integer(user_id)) |>
  left_join(color_lookup, by = c("colorname" = "color")) |> 
  select(user_id, hex, rank) 
write_csv(answers_clean, "data/clean/answers.csv")

