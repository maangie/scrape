# 書籍情報を得る

require 'open-uri' # URL を、普通のファイルのように開く
require 'nokogiri' # HTML 解析器
require 'unf'      # ユニコード正規化
require 'robotex'  # robot.txt 処理
require 'cgi'      # 文字列エスケープ用
require 'pry'      # デバッグ用

SEARCH = 'ruby+言語' # 検索ワード

# スクレイピング対象
URL =
  "https://twitter.com/search?f=tweets&vertical=default&q=#{CGI.escape(SEARCH)}"

# robots.txt を読んでクロールできるかどうか確認する
# robotex = Robotex.new
# p robotex.allowed?(URL)

USER_AGENT = # 'USER_AGNET' 偽装用
  'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) '\
  'Chrome/28.0.1500.63 Safari/537.36'

class String # ユニコード正規化の拡張
  def normalize
    UNF::Normalizer.normalize self, :nfkc
  end
end

# HTML 取得
charset = nil
html = open(URL, 'User-Agent' => USER_AGENT) do |f|
  charset = f.charset
  f.read
end

res = []

# HTML 解析
Nokogiri::HTML.parse(html, nil, charset).css('.tweet-text').each do |i|
  res << i.text.tr("\n", ' ')
end

res.uniq.each { |i| puts i.normalize }
