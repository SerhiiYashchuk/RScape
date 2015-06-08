module RScape
  module SexPartner
    def sex
      @sex ||= nil
    end
    
    def sex=(value)
      @sex = value
    end
    
    def fertile?
      @age.between?($MIN_CHILDBEARING_AGE, $MAX_CHILDBEARING_AGE) &&
      @wealth >= @initial_wealth
    end
    
    def birth_child_with(partner)
      params = child_params(self, partner)
      
      self.decrease_wealth_after_birth
      partner.decrease_wealth_after_birth
      
      child = Agent.new params
      child.sex = rand(0..1) == 0 ? :male : :female
      
      child
    end
    
    def decrease_wealth_after_birth
      @wealth -= @initial_wealth / 2
    end
    
    private
    
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
