# Libraies to install
suppressPackageStartupMessages({
  library(vroom)
  library(dplyr)
  library(fs)
  library(DataExplorer)
  library(janitor)
  library(jsonlite)
})

# function start
runnerC <- function(project, data, name, description) {
  if (!dir.exists(project)) {
    dir_create(project, recurse = T, mode = "u=rwx,go=rx")
  }
  
  if (!dir.exists(paste(project, name, sep = "/"))) {
    dir.create(paste(project, name, sep = "/"))
    
  }
  
  strr = project
  
  p = paste(strr, name, sep = "/")
  
  t = fs::file_copy(data, new_path = p, overwrite = TRUE)
  
  nr <- round(LaF::laf_open_csv(t,
                                column_types = c("integer", "double", "character")) %>%
                LaF::nrow() * 0.05)
  
  s = vroom(
    t,
    guess_max = nr,
    .name_repair = ~ janitor::make_clean_names(., case = "all_caps")
    
  )
  
  
  p0 = paste(strr, name, "preview.json", sep = "/")
  
  jsonlite::write_json((vroom::vroom(t, n_max = 100)),
                       path = p0)
  
  
  p1 = paste(strr, name, "intro.json", sep = "/")
  
  jsonlite::write_json((DataExplorer::introduce(s)),
                       path = p1)
  
  
  
  p2 = paste(strr, name, "miss.json", sep = "/")
  
  jsonlite::write_json((DataExplorer::profile_missing(s)),
                       path = p2)
  
  
  jsonlite::write_json({
    dir_info(strr, recurse = FALSE) %>%
      mutate(description) %>%
      rename(project_data = path) %>%
      select(project_data, user, size, description, modification_time)
  },
  path = paste(strr, "list.json", sep = "/"))
  
  
}

