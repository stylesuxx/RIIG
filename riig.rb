#!/usr/bin/ruby
########################################
# Ruby Imageboard Image Grabber (RIIG) #
#                                      #
# Author: Chris (stylesuxx@gmail.com)  #
########################################
require './lib/url.rb'
require './lib/imagewriter.rb'
require './lib/options.rb'

# Set the commandline options - displays help in case of fuckup
# After parsing there are only non options (aka URL's to grab) in the ARGV array
options = OptionParser.parse(ARGV)

# Do for each url given as commandline argument
ARGV.each do |url|
  begin
    page = Url.new(url)
    
  # When there is an HTTP error or Board is not supported print exception message and skip to the next URL 
  rescue Exception => e
    puts e.message
    next
  end
    
  iWriter = ImageWriter.new(options.output, page.domain, page.board, page.thread)
    
  # If directory exists and subdir was created
  if iWriter.isValid

    # Save each image from page
    page.links.each do |image|
      begin	
	status = iWriter.saveImage(page.getPath(image), page.getFilename(image))
	puts status if status != NIL && options.verbose
      rescue
	puts "Image down or no internet connection: image"
	next
      end
    end
      
  else
   abort("Output path does not exist or you do not have write permissions")
  end
  
  # Output Stats
  !iWriter.new ? tmp = "new " : tmp = ""
  puts "Grabbed #{iWriter.count} #{tmp}images from thread #{page.thread} on #{page.board}" if iWriter.count > 0
  puts "No #{tmp}images in thread #{page.thread} on #{page.board}" if iWriter.count == 0
  
  # Zip images
  if options.zip
    status = iWriter.zip
    puts status if options.verbose
  end
  
  # Delete images - only if files have been zipped too
  if options.del && options.zip
    status = iWriter.del
    puts status if options.verbose
  end

end if !options.help # each url