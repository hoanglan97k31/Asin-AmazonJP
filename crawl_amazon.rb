require 'nokogiri'
require 'pry'
require 'open-uri'
require 'csv'

## Default 
insert_keyword =   "= = = = = = = = = = INSERT KEYWORD = = = = = = = = = = = = = = = ="
insert_last_page = "= = = = = = = = = = INSERT LAST PAGE = = = = = = = = = = = = = = ="
nil_keyword =      "= = = = = = = = = = KEYWORD NILL = = = = = = = = = = = = = = = = ="
not_availability_last_page = "= = = = = = = = = = LAST PAGE NOT AVAILABILITY = = = = = = = = = ="

## Insert Keyword
puts insert_keyword
keyword = gets.chomp.to_s
return puts nil_keyword if keyword.empty? 

## Insert Page
puts insert_last_page
last_page = gets.chomp.to_i
return puts not_availability_last_page if last_page.abs.nil? || last_page.zero?


BASE_URL = "https://www.amazon.co.jp/s?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&i=aps&k=#{keyword}&ref=nb_sb_noss&url=search-alias%3Daps"

raw_page = Nokogiri::HTML(open(BASE_URL))
items = raw_page.css("#a-page > #search > .sg-row > .sg-col > .sg-col-inner > .rush-component > .s-result-list .s-result-item")
asin_array = []
items.each do |item|
  asin = item.attr("data-asin")
  unless asin == nil
    asin_array << asin
  end
end
  puts asin_array

CSV.open('production.csv', 'wb') do |csv|
  csv << asin_array
end
