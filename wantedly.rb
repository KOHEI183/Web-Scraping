#TODO:日本語化する
#TODO:URLをうまく吐き出せない
#TODO:きれいな配列で抽出できない
require "open-uri"
require "nokogiri"
require 'csv'
require 'kconv'
require 'pry'

CSV.open("list.csv", "w") do |csv|
  for i in 1..3 do
    url = "https://www.wantedly.com/projects?type=mixed&page=#{i}&occupation_types%5B%5D=jp__engineering&hiring_types%5B%5D=mid_career&locations%5B%5D=tokyo"
    begin
      _html = open(url)
    rescue OpenURI::HTTPError
      sleep 1
      next
    end
    doc = Nokogiri::HTML(_html)
    counts =  doc.css('.project-tags .entry-count .count').inner_text
    companys =  doc.css('h3').inner_text
    titles = doc.css('h1').inner_text
    csv << [counts,companys, titles]
    sleep 1
  end
end

#========解説不要なら削除========
# webに接続するためのライブラリ
# require "open-uri"
# クレイピングに使用するライブラリ
# require "nokogiri"
# CSV吐き出しに使用するライブラリ
# require 'csv'
# CSV.open("list.csv", "w") do |csv|
#   for i in 1..3 do ←　読み込みたいページ数を入れる。例は1～3ページ。37行目の#{i}にページ数が入り繰り返されるよ！
#     url = "https://www.wantedly.com/projects?type=mixed&page=#{i}&occupation_types%5B%5D=jp__engineering&hiring_types%5B%5D=mid_career&locations%5B%5D=tokyo"　←　読み込みたいURL入れる複数ページ読みたい場合#{i}に変える
#     begin
#       _html = open(url)
#     rescue OpenURI::HTTPError
#       sleep 1
#       next
#     end
#     doc = Nokogiri::HTML(_html)
#     counts =  doc.css('.project-tags .entry-count .count').inner_text　←（）内は読み込みたいクラス名を入れる
#     companys =  doc.css('h3').inner_text　←（）内は読み込みたいクラス名を入れる
#     titles = doc.css('h1').inner_text　←（）内は読み込みたいクラス名を入れる
#     csv << [counts,companys, titles]
#     sleep 1
#   end
# end

