# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

# Data Import
Adata_tbl <- read_delim("../data/Aparticipants.dat", delim = "-", col_names = c("casenum", "parnum","stimver", "datadate", "qs"))
Anotes_tbl <-read_csv("../data/Anotes.csv", col_names = T)
Bdata_tbl <- read_delim("../data/Bparticipants.dat", delim = "\t", col_names = c("casenum", "parnum","stimver", "datadate", paste0("q", 1:10))) #I had to chatgpt the \t for tab seperated values, I should have done it with read_tsv but it's fine
Bnotes_tbl <- read_tsv("../data/Bnotes.txt",col_names = T) #wanted to be fancy and different

# Data Cleaning
Aclean_tbl <- Adata_tbl %>%
  separate(qs, into=paste0("q",1:5)) %>% #i feel like this technically is two verbs/commands in one line (seperate & paste0)
  mutate(datadate=mdy_hms(datadate)) %>%
  mutate(across(starts_with("q"), function(x) as.integer(x))) %>% # I first did it like this,mutate(across(starts_with("q"), as.integer)), I got the right answer, but it's not the way we talked about it in class, is it right?
  left_join(Anotes_tbl,by="parnum") %>%
  filter(is.na(notes))
ABclean_tbl <- Bdata_tbl %>%
  mutate(datadate=mdy_hms(datadate)) %>%
  mutate(across(q1:q10, function(x) as.integer(x))) %>% #I also did this the first time like this:mutate(across(q1:q10,as.integer)). got the same answer,but unsure if we're supposed to do it that way or not.
  left_join(Bnotes_tbl,by="parnum") %>% 
  filter(is.na(notes)) %>%
  bind_rows(Aclean_tbl, .id= "lab") %>%
  select(-notes)
