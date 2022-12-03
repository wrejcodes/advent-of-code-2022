require "option_parser"
require "file_utils"

root_dir = Path.new(__DIR__).parent
template_dir = Path.new("#{root_dir}/templates/")
new = false
folder = ""

parser = OptionParser.new do |parser|
    parser.banner = "Happy Advent of Code"
    parser.on("new", "Create a new solution template") do 
        new = true
        parser.banner = "Usage: new [arguments]"
        parser.on("-f FOLDER", "--folder=FOLDER", "Specify the folder name ie: 3") { |_folder| folder = _folder }
    end
    parser.on("-h", "--help", "Show Help") do 
        puts parser
        exit
    end
    parser.invalid_option do |flag|
        STDERR.puts "ERROR: #{flag} is not a valid option."
        STDERR.puts parser
        exit(1)
    end
end

parser.parse

if new
    # create new folder template
    puts "Creating folder #{folder}..."

    target_dir = Path.new("#{root_dir}/solutions/#{folder}")
    # check if folder exists
    if Dir.exists?(target_dir)
        STDERR.puts "#{root_dir}/solutions/#{folder} already exists... ABORTING"
        exit(1)
    else
        ins = "#{target_dir}/in"
        outs = "#{target_dir}/out"
        FileUtils.mkdir_p([ins, outs])
        FileUtils.touch(["#{ins}/sample.in", "#{ins}/test.in"])
        FileUtils.touch(["#{outs}/sample.out", "#{outs}/test.out"])
        FileUtils.cp("#{template_dir}/solution.cr.template", "#{target_dir}/solution.cr")
    end

else
    puts parser
    exit(1)
end