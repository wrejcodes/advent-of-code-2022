class Solution

    def initialize
        @signal = ""
    end

    def process
        STDIN.each_line do |line|
            @signal = line
        end
    end

    def eachDifferent(array)
        letters = {} of Char => Bool
        array.each do |i|
            if !letters.has_key?(@signal[i])
                letters[@signal[i]] = true
            else
                return false
            end
        end
        true
    end

    def sub_routine(length)
        last_pos = length - 1
        indexs = (0..last_pos).to_a
        marker = last_pos
        loop do 
            if eachDifferent(indexs)
                marker = indexs[last_pos]
                break
            end
            indexs.map!(&.+ 1)
        end
        marker + 1
    end

    def part1
        puts sub_routine 4
    end

    def part2
        puts sub_routine 14
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
