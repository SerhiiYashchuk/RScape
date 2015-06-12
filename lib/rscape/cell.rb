module RScape
  # Represents basic part of a Sugarscape.
  class Cell
    # Sugar source that is placed on a Cell.
    attr_accessor :sugar
    # Agent that occupies a Cell.
    attr_accessor :occupant
    # Amount of pollution.
    attr_accessor :pollution
    
    # Creates a new Cell.
    def initialize
      @sugar = nil
      @occupant = nil
      @pollution = 0.0
    end
    
    # Indicates if there's a Sugar source.
    #
    # Returns +true+ if there is, +false+ otherwise.
    def has_sugar?
      !@sugar.nil?
    end
    
    # Indicates if there's an Agent.
    #
    # Returns +true+ if there is, +false+ otherwise.
    def occupied?
      !@occupant.nil?
    end
  end
end
