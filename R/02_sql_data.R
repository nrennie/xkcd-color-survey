# Download file from https://xkcd.com/color/colorsurvey.tar.gz
# Unzip locally

# Packages
library(RSQLite)
library(DBI)

# Read data
con <- dbConnect(RSQLite::SQLite(), "xkcd_database.db")

# Create connection
sql_dump1 <- readLines("data/colorsurvey/mainsurvey_sqldump.txt")

# Create SQL tables
users_create <- paste(sql_dump1[2:3], collapse = " ")
answers_start <- 152405
for (i in answers_start:(answers_start + 10)) {
  if (grepl(";$", sql_dump1[i])) {
    answers_end <- i
    break
  }
}
answers_create <- paste(sql_dump1[answers_start:answers_end], collapse = " ")
names_create <- sql_dump1[3560443]
dbExecute(con, users_create)
dbExecute(con, answers_create)
dbExecute(con, names_create)

# Get all INSERT statements
insert_lines <- sql_dump1[grepl("^INSERT", sql_dump1)]
start_time <- Sys.time()
for (i in 1:length(insert_lines)) {
  result <- try(dbExecute(con, insert_lines[i]), silent = TRUE)
  if (inherits(result, "try-error")) {
    result2 <- try(dbExecute(con, insert_lines[i]))
    break
  }
}

# Export each table to CSV
tables <- dbListTables(con)
for (table_name in tables) {
  data <- dbReadTable(con, table_name)
  filename <- paste0("data/raw/", table_name, ".csv")
  write.csv(data, filename, row.names = FALSE)
}


# Disconnect
dbDisconnect(con)
