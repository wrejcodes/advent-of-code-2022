class Solution

    def initialize
        @cwd = ""
        @dirs = {} of String => Int32
        @sum = 0
    end

    def parse_command(match)
        return if match[1] == "ls"
        if match[2] == ".."
            @cwd = Path.new(@cwd).parent.to_s
        else
            next_dir = @cwd.ends_with?("/") || @cwd == "" ? match[2] : "/" + match[2]
            @cwd += next_dir
        end
    end

    def parse_output(line)
        return if line =~ /^dir/
        if match = line.match(/^(\d+) .*/)
            size = match[1]
            path = ""
            Path.new(@cwd).each_part do |dir|
                path += dir == "/" ? dir : "/" + dir
                @dirs[path] = 0 if !@dirs.has_key?(path)
                @dirs[path] += size.to_i
            end
        end
    end

    def process
        STDIN.each_line do |line|
            # process input
            if match = line.match(/^\$ (\w+) (\w+|\/|\.+)/)
                parse_command match
            else
                parse_output line
            end
        end
    end

    def part1
        @dirs.each do |dir, size|
            @sum += size if size <= 100000
        end
        puts @sum
    end

    def part2
        total = @dirs["/"]
        target = 30000000
        max = 70000000
        potential_dirs = [] of Int32
        @dirs.each do |dir, size|
            if total + target - size <= max
                potential_dirs << size
            end
        end
        puts potential_dirs.sort()[0]
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
