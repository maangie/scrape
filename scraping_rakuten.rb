# 書籍情報を得る

require 'open-uri' # URL を、普通のファイルのように開く
require 'nokogiri' # HTML 解析器
require 'unf'      # ユニコード正規化
require 'csv'
# require 'robotex' # robot.txt 処理

SEARCH = 'ruby' # 検索ワード

# スクレイピング対象
URL = "http://search.books.rakuten.co.jp/bksearch/nm?g=001005&sitem=#{SEARCH}"

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

# HTML 解析
doc = Nokogiri::HTML.parse(html, nil, charset)

csv = # ヘッダを出力し、全フィールドをクォートする
  CSV.new(STDOUT, headers: %w(title publish isbn),
          write_headers: true, force_quotes: true)

# CSV 出力
doc.css('#rightContents div.rbcomp__item-list__item__details').each do |i|
  title = i.css('h3 > a').text.normalize.strip # 書籍名

  publish = # 出版社名
    i.css('p.rbcomp__item-list__item__subtext').text.
    split('／')[1].normalize.strip

  isbn = i.css('p.rbcomp__item-list__item__isbn').text.sub(/^ISBN：/, '') # ISBN

  csv << [title, publish, isbn]
end
