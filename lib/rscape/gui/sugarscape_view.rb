require 'Qt'
require_relative '../agent.rb'
require_relative '../sugar.rb'

module RScape
  module GUI
    class SugarscapeView < Qt::Widget
      attr_reader :cell_size
      
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
      
      def add_agent(new_agent)
        return false if new_agent.row.nil? || new_agent.col.nil?
        return false if @agents.include? new_agent.id
        
        new_item = @scene.addEllipse(0, 0, @cell_size, @cell_size, @pen,
                                     @agent_brush)
        
        new_item.setPos(new_agent.row * @cell_size, new_agent.col * @cell_size)
        @agents[new_agent.id] = new_item
        
        true
      end
      
      def delete_agent(agent_id)
        if agent = @agents[agent_id]
          @scene.removeItem agent
          @agents.delete agent_id
        end
      end
      
      def move_agent(agent_id, row, col)
        if agent = @agents[agent_id]
          agent.setPos(row * @cell_size, col * @cell_size)
        end
      end
      
      def add_sugar(new_sugar)
        return false if new_sugar.row.nil? || new_sugar.col.nil?
        return false if @sugar_sources.include? new_sugar.id
        
        new_item = @scene.addRect(new_sugar.row * @cell_size,
                                  new_sugar.col * @cell_size,
                                  @cell_size, @cell_size, @pen, @sugar_brush)
        @sugar_sources[new_sugar.id] = new_item
        
        true
      end
      
      def delete_sugar(sugar_id)
        if sugar = @sugar_sources[sugar_id]
          @scene.removeItem sugar
          @sugar_sources.delete sugar_id
        end
      end
      
      def move_sugar(sugar_id, row, col)
        if sugar = @sugar_sources[sugar_id]
          sugar.setPos(row * @cell_size, col * @cell_size)
        end
      end
      
      def agents_count
        @agents.count
      end
      
      def sugars_count
        @sugar_sources.count
      end
      
      def set_agent_color(r, g, b)
        @agent_brush = Qt::Brush.new Qt::Color.new(r, g, b)
      end
      
      def set_sugar_color(r, g, b)
        @sugar_brush = Qt::Brush.new Qt::Color.new(r, g, b)
      end
      
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
