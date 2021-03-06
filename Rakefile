# Build process for research into historical dissertations

KNITR_FILES = FileList["*.rmd"]
OUTPUT_MDS  = KNITR_FILES.ext(".md")

desc "Convert the history MARC file into a CSV"
file "data/history-raw.csv" => "/home/lmullen/research-data/proquest-dissertations/history_utf8.mrc" do |t|
  sh "./marc2csv.py #{t.prerequisites.join(' ')}"
  FileUtils.cp "#{t.prerequisites.join('') + '.csv'}", "#{t.name}"
end

desc "Convert the raw history CSV into a CSV useable as a dataframe"
file "data/history-df.csv" => "data/history-raw.csv" do |t|
  sh "./csv2df.rb"
end

desc "Geocode the universities"
file "location/universities-geocoded-2.csv" => "geocode.r" do |t|
  sh "R --vanilla CMD BATCH geocode.r"
end

rule ".md" => ".rmd" do |t|
  sh %[Rscript --vanilla -e "library(knitr); knit('#{t.source}');"]
end

desc "Run knitr on all the analysis files"
task :analysis => OUTPUT_MDS

task :default => ["data/history-df.csv", :analysis] 

require "rake/clean"
CLEAN.include("figure/*.png", "*.md", "*.html", "*.Rout")
CLOBBER.include("data/history-raw.csv", "data/history-df.csv")

desc "Copy figures to blog directory"
task :copy_to_blog do
  blog_img  = "/home/lmullen/dev/lincolnmullen.com/source/downloads/historical-dissertations/"
  Dir.glob("figure/*.png") {|f| FileUtils.cp File.expand_path(f), blog_img }
  Dir.glob("figure/*.svg") {|f| FileUtils.cp File.expand_path(f), blog_img }
  Dir.glob("figure/*.pdf") {|f| FileUtils.cp File.expand_path(f), blog_img }
end
