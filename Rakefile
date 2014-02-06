# Build process for research into historical dissertations

desc "Convert the history MARC file into a CSV"
file "data/history-raw.csv" => "/home/lmullen/research-data/proquest-dissertations/history_utf8.mrc" do |t|
  sh "./marc2csv.py #{t.prerequisites.join(' ')}"
  FileUtils.cp "#{t.prerequisites.join('') + '.csv'}", "#{t.name}"
end

require "rake/clean"
CLOBBER.include("data/history-raw.csv")
