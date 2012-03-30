class Url  
  attr_reader :url, :board, :valid
    
  def initialize(url)
    @url = url
    @valid = true
    checkValid
  end
    
  # Check if the url is from a board we are able to grab
  def checkValid
    case @url
    # 4chan
    when /((^http:\/\/)?boards.4chan.org\/)[a-z0-9]*\/res\/[0-9]*/
      @board = "4chan"
    else
      @board = "not supported"
      @valid = false
    end
  end
 
end