# TODO:値が回り上書きされないindex番号をしているから?
require "open-uri"
require "nokogiri"
require 'csv'
require 'kconv'
require 'pry'

for i in 1..3 do
  count = 0
  lists = []
    url = "https://www.wantedly.com/projects?type=mixed&page=#{i}&occupation_types%5B%5D=jp__engineering&hiring_types%5B%5D=mid_career&locations%5B%5D=tokyo"
    charset = nil
    html = OpenURI.open_uri(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html.toutf8, nil, 'utf-8')
    posts_list = doc.css(".column-main")
    posts_list.each do |post|
      data = []
      entrycount = post.css(".project-tags .entry-count .count")[0].inner_text
      company = post.css(".projects-index-single .project-bottom .company-name")[0].inner_text
      title = post.css(".projects-index-single .project-title")[0].inner_text
      link = "https://www.wantedly.com"+post.css(".projects-index-single .project-title a")[0][:href]

      data.push("entry:#{entrycount.tosjis}")
      data.push("company:#{company.tosjis}")
      data.push("title:#{title.tosjis}")
      data.push("link:#{link.tosjis}")
      lists.push(data)
    end
  CSV.open("wantedly.csv", "a") do |csv|
    lists.each do |r|
      csv << r
    end
  end
end


#========================================
# for i in 1..3 do
#   count = 0
#   lists = []
#     url = "https://www.wantedly.com/projects?type=mixed&page=#{i}&occupation_types%5B%5D=jp__engineering&hiring_types%5B%5D=mid_career&locations%5B%5D=tokyo"
#     charset = nil
#     html = OpenURI.open_uri(url) do |f|
#       charset = f.charset
#       f.read # htmlを読み込んで変数htmlに渡す
#     end

# htmlを解析してオブジェクトを生成
#     doc = Nokogiri::HTML.parse(html.toutf8, nil, 'utf-8')
#     posts_list = doc.css(".column-main")
#     posts_list.each do |post|
#       data = []
#       company = post.css(".projects-index-single .project-bottom .company-name")[0].inner_text
#       title = post.css(".projects-index-single .project-title")[0].inner_text
#       link = post.css(".projects-index-single .project-title a")[0][:href]

# data配列に取得した情報を格納
#       data.push(company.tosjis,title.tosjis,link.tosjis)
#       lists.push(data)
#     end

#   CSV.open("wantedly.csv", "w") do |csv|
#     lists.each do |r|
#       csv << r
#     end
#   end
# end