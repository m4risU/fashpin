require 'open-uri'
require 'uri'

class Scrapper

  def initialize(url)
    @url = url
  end

  def images
    Nokogiri::HTML(open(@url)).xpath("//img/@src").map do |src|
      "<img src=\"#{make_absolute(src, @url)}\" class=\"img-polaroid\"/>".html_safe
    end
  end

  def make_absolute(href, root)
    URI.parse(root).merge(URI.parse(href)).to_s
  end
end