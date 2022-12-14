require "option_parser"
require "file_utils"

root_dir = Path.new(__DIR__).parent
template_dir = Path.new("#{root_dir}/templates/")
new = false
run = false
debug = false
folder = ""
input = "sample.in"

parser = OptionParser.new do |parser|
    parser.banner = "Happy Advent of Code"
    parser.on("new", "Create a new solution template") do 
        new = true
        parser.banner = "Usage: new [arguments]"
        parser.on("-f FOLDER", "--folder=FOLDER", "Specify the folder name ie: 3") { |_folder| folder = _folder }
    end
    parser.on("run", "Run a solution against an input") do
        run = true
        parser.banner = "Usage: run [arguments]"
        parser.on("-i INPUT", "--input=INPUT", "Specify the input file. Defaults to sample.in") { |_input| input = _input }
        parser.on("-f FOLDER", "--folder=FOLDER", "Specify the folder") { |_folder| folder = _folder }
        parser.on("-d", "--debug", "Enable debug mode") { debug = true }
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
elsif run
    # only run if folder exists
    puts "Running..."

    target_dir = Path.new("#{root_dir}/solutions/#{folder}")

    if !Dir.exists?(target_dir)
        STDERR.puts "No solution found for #{target_dir}"
        exit(1)
    end

    input = input + ".in" if File.extname(input) == ""
    input_file = "#{target_dir}/in/#{input}"
    solution_file = "#{target_dir}/solution.cr"
    output_file = "#{target_dir}/out/#{File.basename(input, ".in")}.out"
    env = {} of String => String
    env["AOC_DEBUG"] = "true" if debug
    if File.exists?(input_file) && File.exists?(solution_file)
        Process.run("sh", ["-c", "crystal #{target_dir}/solution.cr < #{input_file} > #{output_file}"], shell: true, error: STDERR, env: env)
    end 

else
    puts parser
    exit(1)
end