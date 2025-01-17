# Define a list of packages and their versions
packages <- c("tidyverse", "readxl", "rmarkdown", "ggtext", 
              "RColorBrewer", "formattable", "knitr", "gifski")
versions <- c("2.0.0", "1.4.3", "2.25", "0.1.2", "1.1.3", "0.2.1", "1.44", "1.12.2")

# Loop through the packages and install each one with the specified version

install.packages(packages[length(packages)], version = versions[length(versions)])

#devtools::install_github("r-rust/gifski")
for (i in seq_along(packages)) {
  install.packages(packages[i], version = versions[i], dependencies = TRUE)
  print(paste0(packages[i], " Installation Completed"))
}