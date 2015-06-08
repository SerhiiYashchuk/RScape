require_relative 'agent.rb'
require_relative 'harvester.rb'

module RScape
  module Statistic
    def self.wealth_distribution(data)
      frequencies = Hash.new 0
      
      data.each { |value| frequencies[value] += 1 }
      
      frequencies
    end
    
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
