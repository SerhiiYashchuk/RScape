module RScape
  class Cell
    attr_accessor :sugar, :occupant, :pollution
    
    def initialize
      @sugar = nil
      @occupant = nil
      @pollution = 0.0
    end
    
    def has_sugar?
      !@sugar.nil?
    end
    
    def occupied?
      !@occupant.nil?
    end
  end
end
