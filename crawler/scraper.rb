# encoding: utf-8

# fetch data from url
# parse data
# thread to get data!

require 'pry'

require 'json'
require 'net/http'
require 'nokogiri'
require 'open-uri'

require_relative 'ext/string'

RANGE = (1..672)

base_url = "http://top.chinaz.com/list.aspx"


def fetch(url)
  uri      = URI url
  http     = Net::HTTP.new(uri.host, uri.port)
  path     = uri.request_uri
  response = http.get(path)
  list     = []
  case response
  when Net::HTTPSuccess
    doc = Nokogiri::HTML(response.body.to_utf_8)
    doc.css(".webItemList ul li").each do |li|
      next if li.search(".info h3 a").text == ''
      image_path = "http://#{uri.host}#{li.search('figure a img').last['src']}"
      item = {
        :description => li.search(".info .desc").text,
        :site        => li.search(".info h3 span").text,
        :name        => li.search(".info h3 a").text,
        :rank        => li.search(".rank .pm").text,
        :image       => image_path
        }
      list << item
    end
  else
    puts "some error"
  end
  list
end

threads = []
list = [(1...100), (100...200), (200...300), (300...400), (400...500), (500...600), (600..672)]
list.each do |range|
  threads << Thread.new do
    range.to_a.each do |index|
      # puts "fetch page : #{index}"
      url = "#{base_url}?p=#{index}"
      result = fetch url
      File.open(File.join("results", "#{index}.txt"), "w") do |io|
        io << JSON.generate(result)
      end
    end
    # range.to_a.each do |index|
    #   puts "fetch page: #{index}"
    #   url = "#{base_url}?p=#{index}"
    #   result = fetch url
    #   puts "一共获取了 #{result.size} 条数据"
    #   File.open("results/#{index}.txt", "w") do |io|
    #     io << result.inspect
    #   end
    # end
  end
end

threads.each { |thread| thread.join }
# threads.join



