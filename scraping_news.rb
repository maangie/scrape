# ニュースの見出しを得る

require 'open-uri'
require 'nokogiri'
# require 'robotex'

# robotex = Robotex.new
# p robotex.allowed?("http://www.yahoo.co.jp/")

url = 'http://www.yahoo.co.jp/'
user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
charset = nil
html = open(url, "User-Agent" => user_agent) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

doc.css('#topicsfb > div.topicsindex > ul.emphasis > li > a').each { |a_tag|
  puts a_tag.text
}
