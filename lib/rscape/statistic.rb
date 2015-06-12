require_relative 'agent.rb'
require_relative 'harvester.rb'

module RScape
  # Statistic module.
  module Statistic
    # Determines wealth distribution in a society.
    #
    # data - an Array of wealth values.
    #
    # Returns a Hash of wealth-frequency pairs.
    def self.wealth_distribution(data)
      frequencies = Hash.new 0
      
      data.each { |value| frequencies[value] += 1 }
      
      frequencies
    end
    
    # Calculates Gini coefficient.
    #
    # data - an Array of wealth values.
    def self.gini(data)
      distribution = wealth_distribution data
      frequencies = distribution.values.sort
      sum1 = sum2 = 0
      n = frequencies.count
      i = 1
      
      frequencies.each do |frequency|
        sum1 += frequency * i
        sum2 += frequency
        i += 1
      end
      
      g = (2 * sum1).to_f / (n * sum2) - (n + 1).to_f / n
    end
  end
end
