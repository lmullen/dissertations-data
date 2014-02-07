# Read the historical history dissertations data; hd = historical dissertations
hd <- read.csv("data/history-df.csv", stringsAsFactors=F)

# Turn empty strings into NAs
hd[hd == ""] <- NA
