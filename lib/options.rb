require 'optparse'
require 'ostruct'

# Set the options according to commandline arguments
# Catches invalid arguments, missing options and displays helptext
class OptionParser
  
  def self.parse(args)
    options = OpenStruct.new
    options.output = ''
    options.zip = false
    options.del = false
    options.verbose = false
    options.help = false
	    
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: riig.rb [options] url1 url2 ..."
      
      opts.separator ""
      opts.separator "Specific options:"
      opts.on('-o', '--output DIRECTORY', 'Output DIRECTORY') do|file|
	options.output = file + '/'
      end
      
      opts.on('-z', '--zip', 'Zip the images') do
	options.zip = true
      end
      
      opts.on('-v', '--verbose', 'Output more information') do
	options.verbose = true
      end
      
      opts.on('--delete', 'Delete images after execution') do
	options.del = true
      end
      
      opts.separator ""
      opts.separator "Common options:"
      opts.on('-h', '--help', 'Display this screen') do
	puts opts
	options.help = true
      end
  
      opts.on('--version', 'Show programm version') do
	puts "0.1"
      end
  
    end
    
    begin
      opts.parse!(args)
      return options
    # Catch invalid arguments and missing options - display error message, help and exit
    rescue Exception => e
      puts e
      puts opts
      exit
    end
    
  end 	# parse()
  
end 	# class OptionParser