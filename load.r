# Read the historical history dissertations data
import <- read.csv("data/history-df.csv", stringsAsFactors=F)

# Turn empty strings into NAs
import[import == ""] <- NA

# Figure out the top subjects
subject_count <- summarise(group_by(import, subject1), count = length(id)) 
subject_count <- arrange(subject_count, count)

# Limit the data frame to only historical subjects
historical_subjects <- c("History, Modern.",
                         "History, United States.",
                         "History, European.",
                         "Religion, History of.",
                         "Biography.",
                         "History, Asia, Australia and Oceania.",
                         "Art History.",
                         "History, Canadian.",
                         "Education, History of.",
                         "History, General.",
                         "History, Latin American.",
                         "History, Black.",
                         "History, African.",
                         "Economics, History.",
                         "History, Middle Eastern.",
                         "History, Medieval.",
                         "History, Ancient.",
                         "History of Science.",
                         "History, Church.",
                         "History, Russian and Soviet.",
                         "History, World History.",
                         "History, Military.",
                         "History, History of Oceania.")
historical <- filter(import, match(subject1, historical_subjects))

# Count the number of each degree
degree_count <- summarise(group_by(import, degree), count = length(id)) 
degree_count <- arrange(degree_count, count)

# Having limited the data frame to historical work, let's limit it to PhDs and MAs
h_ma   <- filter(historical, degree == "M.A.")
h_diss <- filter(historical, degree == "Ph.D.")
