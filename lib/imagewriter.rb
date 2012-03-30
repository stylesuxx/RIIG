require 'net/http'
require 'uri'

class ImageWriter
  attr_reader :url, :dir, :board, :valid, :new, :thread, :links, :domain, :count, :verbose
  
  def initialize(dir, board, url, verbose)
    @dir = dir
    @url = url
    @board = board
    @valid = true
    @verbose = verbose
    setBoardVars
    createDir()
  end
  
  def createDir()
    begin
      if !File.directory?(@dir)		# If dir does not exist
	Dir.mkdir @dir
	@new = true
      else				# If dir exists
	@new = false
      end
    rescue 				# If output dir does not exist or user has no write permissions
      @valid = false
    end
  end
  
  def setBoardVars()
    case @board
    when "4chan"
      @thread = @url.gsub(/.*res\/([0-9]*)/, '\1')
      @domain = "images.4chan.org"
      @links = getHTML.scan(/File: <a href\="\/\/images.4chan.org\/[a-z0-9]*\/src\/[0-9]*.\w{3,4}"/)
      @links = @links.map {|link| link.gsub(/.*"\/\/(.*)"/, '\1')}

    else
   
    end
    @dir += @board + '_' + @thread
  end
  
  # get boards HTML for parsing
  def getHTML()
    uri = URI.parse(@url)
    response = Net::HTTP.get_response(uri)
    # TODO check if response was OK
    return Net::HTTP.get(uri)
  end
  
  def getPath(link)    
    case @board
    when "4chan"
      return link.gsub(/images.4chan.org\/(.*)/, '/\1')
    else 
      return NIL
    end
  end
    
  def getFilename(link)
    case @board
    when "4chan"	  
      return @dir + '/' + getPath(link).gsub(/^.*\/([0-9]*\.\w{3,4}$)/, '\1')
    else 
      return NIL
    end
  end
  
  def saveImages()
    @count = 0
    @links.each do |link| 
      saveImage(getPath(link), getFilename(link))
    end
  end
  
  def saveImage(path, filename)
    if !File.exist? filename
      Net::HTTP.start(@domain) do |http|
	resp = http.get(path)
	open(filename, "wb") do |file|
	  puts "Saving #{@domain + path} to #{filename}" if verbose
	  file.write(resp.body)
	  @count += 1
	end
      end
    end
  end
  
end