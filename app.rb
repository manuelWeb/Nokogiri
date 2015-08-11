require 'htmlbeautifier'
require 'slim'
require 'htmlentities'
require 'nokogiri'
Slim::Engine.set_options pretty: true

class Slimed
  attr_accessor :src, :out, :outprod
  def initialize(src,out,outprod)
    @src = src
    @out = out
    @outprod = outprod
  end
  
  def tohtml
    # ouverture src en lecture
    srcfile = File.open(src, "rb").read
    s2h = Slim::Template.new{srcfile}
    htmlrender = s2h.render
    beautiful = HtmlBeautifier.beautify(htmlrender, tab_stops: 2)
    # ecriture du fichier out = Slimed.new(src,**out**) > return beautiful
    File.open(out, "w") do |go|
      go.puts beautiful
    end
  end

  def htmlEncodeEnt
    coder = HTMLEntities.new
    html = File.open(out).read
    File.open(outprod, "w") do |go|
      go.puts coder.encode(html, :named).gsub(/&lt;/, "<").gsub(/&gt;/, ">").gsub(/&apos;/, "'").gsub(/&quot;/, '"')
    end
  end

end

fr = Slimed.new('indexC.slim', 'indexC.html','index.html')
fr.tohtml
# fr.htmlEncodeEnt

# system("explorer #{fr.out}")

myfile = File.read('indexC.html')
# data = Nokogiri::HTML(html_document)
doc = Nokogiri::HTML(myfile)
puts doc.at_css("#centralEvent")