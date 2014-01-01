# encoding: utf-8

require 'json'
require 'open-uri'
require 'fileutils'

module DownLoad
  class Image

    attr_accessor :folder, :file_name

    def initialize(image_path, folder = "images")
      @image_path = image_path
      @file_name = File.basename(@image_path)
      @folder = folder
    end

    def image_path
      File.join(@folder, @file_name)
    end

    def download
      return if File.exist? @image_path
      FileUtils.mkdir(@folder) unless Dir.exist? @folder

      puts @image_path
      begin
        File.open(image_path, "wb") do |file|
          file.write open(@image_path).read
        end
      rescue Exception => e
        puts "#{e.inspect}"
        self.download
      end
    end
  end
end


def main
  threads = []
  list = [(1...100), (100...200), (200...300), (300...400), (400...500), (500...600), (600..672)]
  list.each do |range|
    threads << Thread.new {
      range.to_a.each do |index|
        file  = File.read(File.join("results", "#{index}.txt"))
        items = JSON.parse(file)
        items.each do |item|
          image_url = item["image"]
          image     = DownLoad::Image.new image_url
          image.download
        end
      end
    }
  end

  threads.each { |thread| thread.join }
end

main
