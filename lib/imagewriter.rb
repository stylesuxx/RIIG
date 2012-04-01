require 'net/http'
require 'uri'
require 'fileutils'

class ImageWriter
  attr_reader :dir, :count, :isValid, :new
  
  def initialize(basedir, domain, board, thread)
    @basedir = basedir
    @dir = basedir + board + '_' + thread + '/'
    @domain = domain
    @count = 0
    @board = board
    @thread = thread
    @isValid = createDir
  end
  
  def createDir
    begin
      if !File.directory?(@dir)		# If dir does not exist
	Dir.mkdir @dir
	@new = true
      else				# If dir exists
	@new = false
      end
    rescue 				# If output dir does not exist or user has no write permissions
      return false
    end
    return true
  end
   
  # delete folder
  def del()
    FileUtils.rm_rf @dir
    return "Deleted #{@dir}"
  end
  
  # create zipfile
  def zip()
    require 'zip/zip'
    zipfile = "#{@basedir + @board}_#{@thread}.zip"
    
    # Delete zipfile if there already is one
    if File.exist? zipfile
      File.delete(zipfile)
    end
    files = Dir.entries(@dir)
    Zip::ZipFile.open(zipfile, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.mkdir("#{@board}_#{@thread}/")
      files.each do |file|
	zipfile.add(@board + '_' + @thread + '/' + file, @dir+'/'+file) if file != "." && file != ".." 
      end
    end
    return "Zip file created: #{zipfile}"
  end
  
  def saveImage(path, filename)
    if !File.exist? @dir + filename
      Net::HTTP.start(@domain) do |http|
	resp = http.get(path)
	open(@dir + filename, "wb") do |file|
	  file.write(resp.body)
	  @count += 1
	  return "Saved #{@domain + path} to #{@dir + filename}"
	end
	return "Something went wrong while saving #{@dir + filename}"
      end
      return NIL
    end
  end
  
end