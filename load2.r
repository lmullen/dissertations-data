# load2.r 
# This script loads the data and cleans it. It is a copy of `load.r`, which was
# used for posts 1-5, but modified to clean the data more rigorously. It is also
# better optimized. I have two load scripts so that results from the earlier
# posts are preserved unmodified.

library(dplyr)

# Read the historical history dissertations data
import <- read.csv("data/history-df.csv", stringsAsFactors=F, comment.char = "")

# Turn import into a tbl_df to make it easier to work with dplyr
import <- tbl_df(import)

# Turn empty strings into NAs
import[import == ""] <- NA

# Limit the data frame to only historical subjects
historical_subjects <- c("Art History.",
                         "Biography.",
                         "Economics, History.",
                         "Education, History of.",
                         "History of Science.",
                         "History, African.",
                         "History, Ancient.",
                         "History, Asia, Australia and Oceania.",
                         "History, Black.",
                         "History, Canadian.",
                         "History, Church.",
                         "History, European.",
                         "History, General.",
                         "History, History of Oceania.",
                         "History, Latin American.",
                         "History, Medieval.",
                         "History, Middle Eastern.",
                         "History, Military.",
                         "History, Modern.",
                         "History, Russian and Soviet.",
                         "History, United States.",
                         "History, World History.",
                         "Religion, History of.")

# It appears that for dissertations after about 1985, ProQuest started giving 
# the subject1 heading to the topic of the dissertation, say religion or 
# physics, and started giving the methodology (some kind of history) to subject 
# 2. So there is a big gap in the data in the 1990s if you filter it only by 
# subject 1. I'm filtering it by all subjects.
historical <- filter(import, subject1 %in% historical_subjects |
                             subject2 %in% historical_subjects |
                             subject3 %in% historical_subjects |
                             subject4 %in% historical_subjects)

# Count the number of each degree
degree_count <- summarise(group_by(import, degree), count = length(id)) 
degree_count <- arrange(degree_count, count)

# Throw away a few data points that have bad years.
historical <- filter(historical, year > 1800)

# Having limited the data frame to historical work, let's limit it to PhDs and MAs
h_all  <- filter(historical, degree == "M.A." | degree == "Ph.D.")
h_ma   <- filter(historical, degree == "M.A.")
h_diss <- filter(historical, degree == "Ph.D.")

