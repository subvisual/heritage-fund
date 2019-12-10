module PostcodeHelper
    def result_formatter(result)
        [ [ [result[:line_1],result[:line_2],result[:line_3] ].reject(&:empty?) ].join(', '), result[:udprn] ] 
    end
end
