DEBUG = false
class Knot
    @touched : Set(Array(Int32))
    getter touched
    getter pos
    getter name
    def initialize(head : Knot, name : String)
        @head = head
        @pos = @head.not_nil!.pos.clone
        @touched = Set.new([@pos.clone])
        @name = name
    end

    def initialize(pos : Array(Int32), name : String)
        @head = nil
        @pos = pos.clone
        @touched = Set.new([@pos.clone])
        @name = name
    end

    def touching()
        head = @head.not_nil!
        return Math.isqrt((head.pos[0] - @pos[0]) ** 2 + (head.pos[1] - @pos[1]) ** 2) <= 1
    end

    def catch_up
        head = @head.not_nil!
        diff = [head.pos[0] - @pos[0], head.pos[1] - @pos[1]]
        diff[0] = (diff[0] / 2).to_i if diff[0].abs > 1
        diff[1] = (diff[1] / 2).to_i if diff[1].abs > 1
        @pos[0] += diff[0]
        @pos[1] += diff[1]
    end

    def move(dir)
        move_head dir if @head.nil?
        move_knot unless @head.nil?
        @touched.add @pos.clone
    end

    def move_head(dir)
        case dir
        when "U"
            @pos[1] += 1
        when "R"
            @pos[0] += 1
        when "L"
            @pos[0] -= 1
        when "D"
            @pos[1] -= 1
        else
            raise "Invalid Move!"
        end
    end

    def move_knot
        catch_up if !touching
    end
end

class Solution
    @touched : Set(Array(Int32))
    def initialize
        @h_pos = [0,0]
        @t_pos = [0,0]
        @touched = Set.new([@t_pos])
        @moves = [] of String
    end

    def process
        STDIN.each_line do |line|
            # process input
            @moves << line
        end
    end

    def plot(knots)
        # inefficient way of plotting :)
        points = Set(Array(Int32)).new()  
        names = [] of String
        knots.each do |knot|
            if !points.includes? knot.pos
                names << knot.name
            end
            points.add knot.pos
        end
        lines = [] of String
        (-5..15).each do |i|
            line = [] of Char
            (-11..14).each do |j|
                if points.includes? [j, i]
                    line << names.pop.chars[0]
                else
                    line << '.'
                end
            end
            lines << line.join()
        end
        lines.size.times {STDERR.puts lines.pop}
    end

    def move_knots(knot_size)
        knots = [] of Knot
        should_debug = DEBUG && knot.size > 2
        knot_size.times do |i|
            knot = nil
            if knots.empty?
                knot = Knot.new([0, 0], "H")
            else
                knot = Knot.new(knots[i - 1], i.to_s)
            end
            knots << knot
        end
        @moves.each do |move|
            dir, steps = move.split(' ')
            STDERR.puts "" if should_debug
            STDERR.puts("======#{dir} #{steps}=======") if should_debug
            steps = steps.to_i
            steps.times do | i |
                knots.each do |knot|
                    knot.move(dir)
                end
                # plot only works for sample and larger input
                plot(knots) if should_debug
                STDERR.puts "#{dir}:#{i + 1}" if should_debug
                STDERR.puts "" if should_debug
            end
        end
        return knots.last.touched.size
    end

    def part1
        puts move_knots 2
    end

    def part2
        puts move_knots 10 # I spent about 1.5 hrs with this at 9 :rip:
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
