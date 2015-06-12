module RScape
  # Represents reproduction behavior for Agent.
  module SexPartner
    # Sex of the Agent.
    def sex
      @sex ||= nil
    end
    
    # Sets Agents' sex.
    def sex=(value)
      @sex = value
    end
    
    # Indicates if Agent can produce a child Agent.
    #
    # Returns +true+ if Agents' age is in range from +MIN_CHILDBEARING_AGE+
    # to +MAX_CHILDBEARING_AGE+ and current wealth is greater or equal to
    # initial wealth. Returns +false+ otherwise.
    def fertile?
      @age.between?($MIN_CHILDBEARING_AGE, $MAX_CHILDBEARING_AGE) &&
      @wealth >= @initial_wealth
    end
    
    # Produces a child Agent of random sex and with half of its parents
    # initial wealth. Also decreases parents' wealth.
    #
    # Returns a new Agent.
    def birth_child_with(partner)
      params = child_params(self, partner)
      
      self.decrease_wealth_after_birth
      partner.decrease_wealth_after_birth
      
      child = Agent.new params
      child.sex = rand(0..1) == 0 ? :male : :female
      
      child
    end
    
    # Decreases wealth by half of its initial wealth.
    def decrease_wealth_after_birth
      @wealth -= @initial_wealth / 2
    end
    
    private
    
    # Determines attributes of a child Agent.
    def child_params(parent1, parent2)
      params = {}
      
      case rand(0..1)
      when 0
        params[:metabolism] = parent1.metabolism
      when 1
        params[:metabolism] = parent2.metabolism
      end
      
      case rand(0..1)
      when 0
        params[:vision] = parent1.vision
      when 1
        params[:vision] = parent2.vision
      end
      
      params[:wealth] = (parent1.initial_wealth + parent2.initial_wealth) / 2
      
      params
    end
  end
end
