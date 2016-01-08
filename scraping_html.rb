# URLにアクセスするためのライブラリの読み込み
require 'open-uri'

# スクレイピング先のURL
url = 'http://www.yahoo.co.jp/'

user_agent = # user_agentの偽装
  'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) '\
  'Chrome/28.0.1500.63 Safari/537.36'

charset = nil
html = open(url, "User-Agent" => user_agent) do |f|
  charset = f.charset # 文字種別を取得
  f.read
end

# 取得したhtmlを全て表示する
puts html
