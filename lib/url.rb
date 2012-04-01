require 'net/http'
require 'uri'

class Url  
  attr_reader :url, :board, :isValid, :thread, :domain, :links
    
  def initialize(url)
    @url = url
    @isValid = checkValid
    getLinks if @isValid
  end
    
  # Check if the url is from a board we are able to grab
  def checkValid
    case @url
    # 4chan
    when /((^http:\/\/)?boards\.4chan\.org\/)[a-z0-9]*\/res\/[0-9]*/
      @board = "4chan"    
    when /((^http:\/\/)?\w{3}\.2chan\.net\/)[a-z0-9]*\/res\/[0-9]*\.htm/
      @board = "2chan"
    else
      return false
    end
    return true
  end
  
  # Get the pages content
  def getHTML
    uri = URI.parse(@url)
    response = Net::HTTP.get_response(uri)
    # TODO check if response was OK
    return Net::HTTP.get(uri)
  end

  # Returns an array of image links
  # sets thread and domain vars
  def getLinks
    case @board
    when "4chan"
      @thread = @url.gsub(/.*res\/([0-9]*)/, '\1')
      @domain = "images.4chan.org"
      @links = getHTML.scan(/File: <a href\="\/\/images.4chan.org\/[a-z0-9]*\/src\/[0-9]*.\w{3,4}"/)
      @links = @links.map {|link| link.gsub(/.*"\/\/(.*)"/, '\1')}
    when "2chan"
      @thread = @url.gsub(/.*res\/([0-9]*)\.htm/, '\1')
      @links = getHTML.scan(/<br><a href\="http:\/\/\w{3}\.2chan\.net\/[a-z0-9]*\/[0-9]*\/src\/[0-9]*.\w{3,4}" target/)
      @links = @links.map {|link| link.gsub(/.*"http:\/\/(.*)" target/, '\1')}
      @domain = @links[0].gsub(/(.*\.2chan\.net).*/, '\1')
    else
      return NIL
    end
    # Folder where the images will be saved
    #@dir += @board + '_' + @thread
    return @links
  end
  
  def getFilename(link)
    case @board
    when "4chan"	  
      return getPath(link).gsub(/^.*\/([0-9]*\.\w{3,4}$)/, '\1')
    when "2chan"
      return getPath(link).gsub(/^.*\/([0-9]*\.\w{3,4}$)/, '\1')
    else 
      return NIL
    end
  end
  
  def getPath(link)
    case @board
    when "4chan"
      return link.gsub(/images.4chan.org\/(.*)/, '/\1')
    when "2chan"
      return link.gsub(/.*\.2chan\.net\/(.*)/, '/\1')     
    else 
      return NIL
    end
  end
  
end