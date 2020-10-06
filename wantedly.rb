require "open-uri"
require "nokogiri"
require 'csv'
require 'pry'

urls = %w(
  https://www.wantedly.com/projects?type=mixed&page=1&hiring_types%5B%5D=mid_career&locations%5B%5D=tokyo
)
lists = []
charset = nil
urls.each do |url|
  html = open(url) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)
    counts = doc.css('count').count
    companys = doc.css('h3').inner_text
    titles = doc.css('h1').inner_text
    links = doc.css('.projects-index-single .project-title a href')
    lists.push("エントリー数：#{counts},企業名：#{companys},タイトル：#{titles},リンク：#{links}")
end

CSV.open("wantedly.csv", "w") do |csv|
  csv << lists
end



#========解説不要なら削除========
# webに接続するためのライブラリ
# require "open-uri"
# クレイピングに使用するライブラリ
# require "nokogiri"
# CSV吐き出しに使用するライブラリ
# require 'csv'

# 単語検索したページのURLを入れる(複数春場合は,改行)
# urls = %w(
#   https://www.wantedly.com/projects?type=mixed&page=1&hiring_types%5B%5D=mid_career&locations%5B%5D=tokyo
# )
# titles = []
# 取得するhtml用charset(文字コード)
# charset = nil
# urls.each do |url|
#   html = open(url) do |f|
#charsetを自動で読み込み、取得
#     charset = f.charset
#中身を読む
#     f.read
#   end

#   doc = Nokogiri::HTML.parse(html, nil, charset)
#   doc.xpath('//h1[@class="searchResult_itemTitle"]').each do |node|
#     title = node.css('a').inner_text
#     titles.push(title)
#   end
# end

# CSV.open("wantedly.csv", "w") do |csv|
#   csv << titles
# end
