require 'Qt'
require_relative '../agent.rb'
require_relative '../sugar.rb'

module RScape
  module GUI
    # Widget for graphical representation of a Sugarscape.
    class SugarscapeView < Qt::Widget
      # Size of a Cell in pixels.
      attr_reader :cell_size
      
      # Creates a new Widget.
      def initialize(cell_size, parent = nil)
        super parent
        
        @scene = Qt::GraphicsScene.new
        @view = Qt::GraphicsView.new @scene
        @cell_size = cell_size
        @agents = {}
        @sugar_sources = {}
        
        @pen = Qt::Pen.new
        @agent_brush = Qt::Brush.new(Qt::Color.new(255, 0, 0))
        @sugar_brush = Qt::Brush.new(Qt::Color.new(255, 255, 0))
        
        main_layout = Qt::HBoxLayout.new
        
        main_layout.addWidget @view
        setLayout main_layout
      end
      
      # Adds new agent.
      #
      # new_agent - Agent to be displayed. Has to be positioned previously.
      #
      # Returns +true+ if succeeded, +false+ if Agent isn't positioned or
      # is already displayed.
      def add_agent(new_agent)
        return false if new_agent.row.nil? || new_agent.col.nil?
        return false if @agents.include? new_agent.id
        
        new_item = @scene.addEllipse(0, 0, @cell_size, @cell_size, @pen,
                                     @agent_brush)
        
        new_item.setPos(new_agent.row * @cell_size, new_agent.col * @cell_size)
        @agents[new_agent.id] = new_item
        
        true
      end
      
      # Removes Agent.
      def delete_agent(agent_id)
        if agent = @agents[agent_id]
          @scene.removeItem agent
          @agents.delete agent_id
        end
      end
      
      # Moves Agent representation to a new position.
      def move_agent(agent_id, row, col)
        if agent = @agents[agent_id]
          agent.setPos(row * @cell_size, col * @cell_size)
        end
      end
      
      # Adds new Sugar.
      #
      # new_sugar - Sugar to be displayed. Has to be positioned previously.
      #
      # Returns +true+ if succeeded, +false+ if Sugar isn't positioned or
      # is already displayed.
      def add_sugar(new_sugar)
        return false if new_sugar.row.nil? || new_sugar.col.nil?
        return false if @sugar_sources.include? new_sugar.id
        
        new_item = @scene.addRect(new_sugar.row * @cell_size,
                                  new_sugar.col * @cell_size,
                                  @cell_size, @cell_size, @pen, @sugar_brush)
        @sugar_sources[new_sugar.id] = new_item
        
        true
      end
      
      # Removes Sugar.
      def delete_sugar(sugar_id)
        if sugar = @sugar_sources[sugar_id]
          @scene.removeItem sugar
          @sugar_sources.delete sugar_id
        end
      end
      
      # Moves Sugar representation to a new position.
      def move_sugar(sugar_id, row, col)
        if sugar = @sugar_sources[sugar_id]
          sugar.setPos(row * @cell_size, col * @cell_size)
        end
      end
      
      # Returns number of Agents.
      def agents_count
        @agents.count
      end
      
      # Returns number of Sugar sources.
      def sugars_count
        @sugar_sources.count
      end
      
      # Sets color for Agent representation.
      def set_agent_color(r, g, b)
        @agent_brush = Qt::Brush.new Qt::Color.new(r, g, b)
      end
      
      # Sets color for Sugar source representation.
      def set_sugar_color(r, g, b)
        @sugar_brush = Qt::Brush.new Qt::Color.new(r, g, b)
      end
      
      # Changes Agent color.
      def change_agent_color(agent_id, r, g, b)
        if agent = @agents[agent_id]
          x, y = agent.x, agent.y
          
          @scene.removeItem agent
          
          new_item = @scene.addEllipse(0, 0, @cell_size, @cell_size, @pen,
                                       Qt::Brush.new(Qt::Color.new(r, g, b)))
        
          new_item.setPos(x, y)
          @agents[agent_id] = new_item
        end
      end
      
      # Changes Sugar source color.
      def change_sugar_color(sugar_id, r, g, b)
        if sugar = @sugar_sources[sugar_id]
          x, y = sugar.x, sugar.y
          
          @scene.removeItem sugar
          
          new_item = @scene.addEllipse(0, 0, @cell_size, @cell_size, @pen,
                                       Qt::Brush.new(Qt::Color.new(r, g, b)))
        
          new_item.setPos(x, y)
          @sugar_sources[sugar_id] = new_item
        end
      end
    end
  end
end
