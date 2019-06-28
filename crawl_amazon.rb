require 'nokogiri'
require 'open-uri'
require 'pry'
require 'csv'

class NoticeDefault

  ## NOTICE
  def insert_keyword
    "= = = = = = = = = = INSERT KEYWORD = = = = = = = = = = = = = = = ="
  end

  def insert_last_page
     "= = = = = = = = = = INSERT LAST PAGE = = = = = = = = = = = = = = = ="
  end

  def nil_keyword
    "= = = = = = = = = = KEYWORD NILL = = = = = = = = = = = = = = = = ="
  end

  def not_availability_last_page
    "= = = = = = = = = = LAST PAGE NOT AVAILABILITY = = = = = = = = = ="
  end

  def complete_get_asin
    "= = = = = = = = = = COMPLETE GET DATA ASIN = = = = = = = = = = = ="
  end

  def insert_to_csv
    "= = = = = = = = = = INSERT TO CSV FILE = = = = = = = = = = = = = ="
  end

  def complete
    "= = = = = = = = = = COMPLETE = = = = = = = = = = = = = = = = = = ="
  end

  def loading
    "== "
  end
end

class InsertData < NoticeDefault
    attr_accessor :keyword, :last_page

    def initialize
      puts insert_keyword
      @keyword = gets.chomp.to_s
      puts insert_last_page
      @last_page = gets.chomp.to_i
    end
end


class GetdataAsin
  attr_accessor :urls
  
  def initialize(insert_data)
    @urls = []
    $total_asin = []
    insert_data.last_page.times {|i| urls.push("https://www.amazon.co.jp/s?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&i=aps&k=#{insert_data.keyword}&page=#{i+1}&ref=nb_sb_noss&url=search-alias%3Daps")}
  end
end

class Parser < NoticeDefault

  def initialize(insert_data)
    ## Function
    insert_data.urls.each { |url|
      raw_page = Nokogiri::HTML(open(url))
      items = raw_page.css("#a-page > #search > .sg-row > .sg-col > .sg-col-inner > .rush-component > .s-result-list .s-result-item")
      asin_array = []
      items.each do |item|
        asin = item.attr("data-asin")
        unless asin == nil
          asin_array << asin
        end
      end
      $total_asin = $total_asin + asin_array
      print loading
    }
    p complete_get_asin
    p insert_to_csv
  end
end

class InsertCsv < NoticeDefault
  def initialize(insert_data)
    CSV.open("#{insert_data.keyword}_asin_amazonjp.csv", 'wb') do |csv|
      $total_asin.each do |item|
        csv << [item, "\n"]
      end
    end
    puts complete
  end
end

insert_data = InsertData.new
get_data = GetdataAsin.new(insert_data)
parser_data = Parser.new(get_data)
InsertCsv.new(insert_data)