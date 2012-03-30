#!/usr/bin/ruby

# Ruby Imageboard Image Grabber (RIIG)
# 
# Author: Chris (chris@1337.af)

require './lib/url.rb'
require './lib/imagewriter.rb'
require './lib/options.rb'

# Set the commandline options - display help in case of fuckup
options = OptionParser.parse(ARGV)

# Do for each url given as commandline argument
# After parsing the options only url's are left in the ARGV array
ARGV.each do |url|
  link = Url.new(url)
    
  # If URL valid (valid board & valid formatting)
  if link.valid
    iWriter = ImageWriter.new(options.output, link.board, url, options.verbose)
    if iWriter.valid 
      iWriter.saveImages
    else
      puts "Directory does not exist or you have no write permissions"
      exit
    end
    
  # If URL NOT valid
  else
    puts "\"#{url}\" is not a valid url"
    next
  end
  
  # Output Stats
  #if iWriter.new
  !iWriter.new ? tmp = "new " : tmp = ""
    puts "Saved #{iWriter.count} #{tmp}images to #{iWriter.dir}" if iWriter.count > 0
    puts "No #{tmp}images in thread #{iWriter.thread}" if iWriter.count == 0
  #else
    #puts "Saved #{iWriter.count} new images to #{iWriter.dir}" if iWriter.count > 0
    #puts "No new images in thread #{iWriter.thread}" if iWriter.count == 0
  #end
  
  # Zip images
  
  # Delete images
  
end # each url