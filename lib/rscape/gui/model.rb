require_relative '../sugarscape.rb'
require_relative '../agent.rb'

module RScape
  module GUI
    class Model < Qt::Widget
      slots 'plant_sugar(int)', 'settle_agents(int)'
      
      attr_reader :population, :sugarscape
      
      def initialize(sugarscape, parent = nil)
        super parent
        
        @sugarscape = sugarscape
        @population = []
        @new_sugar_proc = nil
        @new_agent_proc = nil
        @sugar_placement_proc = nil
        @agent_placement_proc = nil
      end
      
      def plant_sugar(count)
        if !@sugar_sources.empty?
          Kernel::raise(RuntimeError, "Sugarscape already has some sugar.")
        end
        
        if @new_sugar_proc.nil? || @sugar_placement_proc.nil?
          Kernel::raise(RuntimeError,
                        "No Sugar creation or placement procedure.")
        end
        
        if count > @sugarscape.cells_count
          Kernel::raise(ArgumentError,
                        "Sugar count is more than Sugarscape can hold.")
        end
        
        count.times do
          new_sugar = @new_sugar_proc.call
          row, col = @sugar_placement_proc.call
          
          new_sugar.move_to(row, col)
          @sugarscape.add_sugar new_sugar
        end
      end
      
      def settle_agents(count)
        if !@population.empty?
          Kernel::raise(RuntimeError, "Sugarscape already has some agents.")
        end
        
        if @new_agent_proc.nil? || @agent_placement_proc.nil?
          Kernel::raise(RuntimeError,
                        "No Agent creation or placement procedure.")
        end
        
        if count > @sugarscape.cells_count
          Kernel::raise(ArgumentError,
                        "Agents count is more than Sugarscape can hold.")
        end
        
        count.times do
          new_agent = @new_agent_proc.call
          row, col = @agent_placement_proc.call
          
          new_agent.move_to(row, col)
          @sugarscape.place_agent new_agent
          @population << new_agent
        end
      end
      
      def set_sugar_creation_proc(& proc)
        @new_sugar_proc = proc
      end
      
      def set_sugar_placement_proc(& proc)
        @sugar_placement_proc = proc
      end
      
      def set_agent_creation_proc(& proc)
        @new_agent_proc = proc
      end
      
      def set_agent_placement_proc(& proc)
        @agent_placement_proc = proc
      end
    end
  end
end
