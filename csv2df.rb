#!/usr/bin/env ruby

# Convert CSVs generated from Proquest MARC files into useable CSV to read 
# as a dataframe in R.

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

require "csv"

dataframe = Array.new

current_id = "AAI0000059"
current_record = {:id => current_id}

CSV.foreach("data/history-raw.csv") do |row|
    if row[0] == current_id 
        case 
        when row[1] == "1" 
            current_record[:id] = row[7]
        when row[1] == "020"
            current_record[:isbn] = row[7]
        when row[1] == "100"
            current_record[:author] = row[7]
        when row[1] == "245"
            current_record[:title] = row[7]
        when row[1] == "300"
            current_record[:pages] = /\d+/.match(row[7]).to_s
        when row[1] == "500" && row[2] == "1"
            match = /Source:\s/.match(row[7])
            current_record[:source] = match.post_match.to_s if match
        when row[1] == "500" && row[2] == "2"
            # Apparently a field with all the advisers (or only one) listed.
            # Takes the form "Adviser(s): names"
            match = /Adviser(s?):\s+/.match(row[7])
            current_record[:committee] = match.post_match.to_s if match
        when row[1] == "502" 
            current_record[:year] = /\d+/.match(row[7]).to_s
        when row[1] == "520" && row[2] == "1"
            current_record[:abstract1] = row[7]
        when row[1] == "520" && row[2] == "2"
            current_record[:abstract2] = row[7]
        when row[1] == "520" && row[2] == "3"
            current_record[:abstract3] = row[7]
        when row[1] == "520" && row[2] == "4"
            current_record[:abstract4] = row[7]
        when row[1] == "520" && row[2] == "5"
            current_record[:abstract5] = row[7]
        when row[1] == "520" && row[2] == "6"
            current_record[:abstract6] = row[7]
        when row[1] == "590" 
            current_record[:schoolcode] = /\d+/.match(row[7]).to_s
        when row[1] == "650" && row[2] == "1"
            current_record[:subject1] = row[7]
        when row[1] == "650" && row[2] == "2"
            current_record[:subject2] = row[7]
        when row[1] == "650" && row[2] == "3"
            current_record[:subject3] = row[7]
        when row[1] == "650" && row[2] == "4"
            current_record[:subject4] = row[7]
        when row[1] == "710" && row[5] == "a"
            current_record[:university] = row[7]
        when row[1] == "710" && row[5] == "b"
            current_record[:department] = row[7]
        when row[1] == "790" && row[2] == "1" && row[5] == "a"
            # Explicitly listed as adviser
            current_record[:adviser1] = /\D+/.match(row[7]).to_s
        when row[1] == "790" && row[2] == "2" && row[5] == "a"
            # Explicitly listed as committee member
            current_record[:adviser2] = /\D+/.match(row[7]).to_s
        when row[1] == "790" && row[2] == "3" && row[5] == "a"
            # Explicitly listed as committee member
            current_record[:adviser3] = /\D+/.match(row[7]).to_s
        when row[1] == "790" && row[2] == "4" && row[5] == "a"
            # Explicitly listed as committee member
            current_record[:adviser4] = /\D+/.match(row[7]).to_s
        when row[1] == "790" && row[2] == "5" && row[5] == "a"
            # Explicitly listed as committee member
            current_record[:adviser5] = /\D+/.match(row[7]).to_s
        when row[1] == "791"
            current_record[:degree] = row[7]
        when row[1] == "856"
            current_record[:url] = row[7]
        end
    else 
        dataframe.push current_record
        current_record = Hash.new
        current_id = row[0]
        current_record[:id] = row[0]
    end
end

dataframe.push current_record

# Now make the CSV

column_names = [:id, :isbn, :author, :title, :pages, :year, :source, :advisers,
                :abstract1, :abstract2, :abstract3, :abstract4, :abstract5,
                :abstract6, :schoolcode, :subject1, :subject2, :subject3,
                :subject4, :university, :department, :adviser1, :adviser2, 
                :adviser3, :adviser4, :adviser5, :degree, :url]

CSV.open("data/history-df.csv", "w") do |csv|
    csv << column_names
    dataframe.each do |record| 
        csv << column_names.map do |h| 
            record[h]
        end
    end
end

