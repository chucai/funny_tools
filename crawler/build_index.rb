require 'tire'
require 'json'

module BuildIndex
  class Site
    class << self
      def build!
        #672
        (1..672).each do |num|
          puts "build number : #{num}"
          sites = JSON.parse File.read(File.join("results", "#{num}.txt"))
          sites.map { |item| item["rank"] = item["rank"].to_i }
          Tire.index 'sites' do
            import sites
          end
        end
        puts "build index success"
      end

      def destroy
        Tire.index 'sites' do
          delete
        end
        puts 'destroy success'
      end

      def rebuild!
        destroy
        build!
      end
    end
  end
end

command = ARGV.first

case command
when 'build'
  BuildIndex::Site.build!
when 'destroy'
  BuildIndex::Site.destroy
when 'rebuild'
  BuildIndex::Site.rebuild!
when 'search'
  s = Tire.search('sites') do
    query do
      string "name:*"
    end
    sort { by :rank, 'asc' }
    from 1
    size 10
  end
  s.results.each do |document|
    puts "* #{ document.name }"
  end
else
  puts "invalid command options"
end





