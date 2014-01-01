# {
#   "description" => "description",
#   "site"        =>"www.sina.com.cn",
#   "name"        =>"新浪网",
#   "rank"        =>"9",
#   "image"       => "http://top.chinaz.com/WebSiteimages/2012-04-06/_s9c10ca06-b3a4-44f2-bc50-5da4e37e6b6d.png"
# }
require 'tire' unless defined? Tire

class Site
  SIZE = 10

  attr_accessor :site, :name, :rank, :image_url, :image_path, :description

  def initialize(options)
    @site        = options["site"]
    @name        = options["name"]
    @rank        = options["rank"]
    @image_url   = options["image"]
    @image_path  = "/images/#{File.basename(@image_url)}" if @image_url
    @description = options["description"]
  end

  def attributes
    instance_variables.map { |var| var.to_s.gsub(/@/, '') }
  end

  def to_json
    attributes.inject({}) do |result, name|
      result[name] = self.send(name)
      result
    end
  end

  def type
    'site'
  end

  def to_indexed_json
    to_json
  end

  class << self
    def fetch(from: 1, size: SIZE)
      from = (from - 1) * SIZE
      sites = []
      query = Tire.search('sites') do
        query do
          string "name:*"
        end
        from from
        size size
        sort { by :rank, 'asc' }
      end
      query.results.each do |document|
        site = Site.new({
          "name"        => document.name,
          "description" => document.description,
          "rank"        => document.rank,
          "site"        => document.site,
          "image"       => document.image
        })
        sites << site
      end
      sites
    end

    def search(name)
      sites = []
      query = Tire.search('sites') do
        query do
          string "name:#{name}"
          # string "description:#{name}"
        end
        sort { by :rank, 'asc'}
        size 100
      end
      query.results.each do |document|
        site = Site.new({
          "name"        => document.name,
          "description" => document.description,
          "rank"        => document.rank,
          "site"        => document.site,
          "image"       => document.image
        })
        sites << site
      end
      puts "site count: #{sites.count}"
      sites
    end
  end
end
