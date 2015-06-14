require 'rscape/sugarscape'
require 'rscape/agent'
require 'rscape/statistic'
require 'rscape/gui/main_window'
require 'rscape/gui/sugarscape_view'

class Model < RScape::GUI::MainWindow
  MIN_ROWS = 1
  MIN_COLS = 1
  MAX_ROWS = 100
  MAX_COLS = 100
  
  slots 'start()', 'stop()', 'reset()', 'iterate()'
  slots 'collect_statistic()', 'update_statistic()'
  
  attr_accessor :tps, :sugarscape, :population, :iterations_passed
  attr_reader :new_sugar_proc, :new_agent_proc, :sugar_placement_proc,
  :agent_placement_proc, :info_placement_proc, :iterate_proc, :view, :statistics
  
  def initialize
    super
    
    @timer = Qt::Timer.new
    @tps = 1
    @sugarscape = nil
    @population = []
    @iterations_passed = 0
    @model_ready = false
    
    @new_sugar_proc = nil
    @new_agent_proc = nil
    @sugar_placement_proc = nil
    @agent_placement_proc = nil
    @info_placement_proc = nil
    @iterate_proc = nil
    
    @statistics = {
      iteration: [],
      STAT_AGENTS_NUM => [],
      STAT_AVG_AGE => [],
      STAT_AVG_VISION => [],
      STAT_AVG_WEALTH => [],
      STAT_GINI => [],
      STAT_INFO_PERCENT => []
    }
    
    connect(control_panel.start_button, SIGNAL('pressed()'),
            self, SLOT('start()'))
    connect(control_panel.stop_button, SIGNAL('pressed()'),
            self, SLOT('stop()'))
    connect(control_panel.reset_button, SIGNAL('pressed()'),
            self, SLOT('reset()'))
    connect(@timer, SIGNAL('timeout()'), self, SLOT('iterate()'))
  end
  
  def start
    create_model unless @model_ready
    control_panel.start_button.setEnabled false
    control_panel.stop_button.setEnabled true
    control_panel.reset_button.setEnabled false
    
    @timer.start 1000 / @tps
  end
  
  def stop
    control_panel.start_button.setEnabled true
    control_panel.stop_button.setEnabled false
    control_panel.reset_button.setEnabled true
    
    @timer.stop
  end
  
  def reset
    @iterations_passed = 0
    @model_ready = false
    @sugarscape = nil
    @population.clear
    @view.clear
    
    clear_statistic
  end
  
  def iterate
    @iterate_proc.call
    @iterations_passed += 1
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
  
  def set_info_placement_proc(& proc)
    @info_placement_proc = proc
  end
  
  def set_iteration_proc(& proc)
    @iterate_proc = proc
  end
  
  def update_statistic
    total_age = @population.inject(0) { |total, agent| total + agent.age }
    total_vision = @population.inject(0) { |total, agent| total + agent.vision }
    total_wealth = @population.inject(0) { |total, agent| total + agent.wealth }
    total_bearers = @population.count { |agent| !agent.info.empty? }
    @population.collect { |agent| agent }
    info_chunks_count = info_params.chunks.count
    
    social_statistic[STAT_AGENTS_NUM] = @population.size
    social_statistic[STAT_AVG_AGE] = total_age / @population.size
    social_statistic[STAT_AVG_VISION] = total_vision / @population.size
    
    economical_statistic[STAT_AVG_WEALTH] = total_wealth / @population.size
    economical_statistic[STAT_GINI] = RScape::Statistic.
      gini(@population.collect(&:wealth)).round 3
    
    info_spread_statistic[STAT_INFO_PERCENT] = ((total_bearers.to_f /
      @population.size) * 100).round 2
  end
  
  def collect_statistic
    @statistics[:iteration] << @iterations_passed
    @statistics[STAT_AGENTS_NUM] << social_statistic[STAT_AGENTS_NUM]
    @statistics[STAT_AVG_AGE] << social_statistic[STAT_AVG_AGE]
    @statistics[STAT_AVG_VISION] << social_statistic[STAT_AVG_VISION]
    @statistics[STAT_AVG_WEALTH] << economical_statistic[STAT_AVG_WEALTH]
    @statistics[STAT_GINI] << economical_statistic[STAT_GINI]
    @statistics[STAT_INFO_PERCENT] << info_spread_statistic[STAT_INFO_PERCENT]
  end
  
  def clear_statistic
    @statistics.each { |_, array| array.clear }
    
    social_statistic[STAT_AGENTS_NUM] = 0
    social_statistic[STAT_AVG_AGE] = 0
    social_statistic[STAT_AVG_VISION] = 0
    economical_statistic[STAT_AVG_WEALTH] = 0
    economical_statistic[STAT_GINI] = 0
    info_spread_statistic[STAT_INFO_PERCENT] = 0
  end
  
  private
  
  def create_model
    create_sugarscape
    plant_sugar
    settle_agents
    spread_info
    
    @model_ready = true
  end
  
  def create_sugarscape
    rows_count = sugarscape_params.rows
    cols_count = sugarscape_params.cols
    
    if rows_count.nil? || cols_count.nil? ||
      !rows_count.between?(MIN_ROWS, MAX_ROWS) ||
      !cols_count.between?(MIN_COLS, MAX_COLS)
      
      Kernel::raise(RuntimeError, "Invalid Sugarscape size.")
    end
    
    @sugarscape = RScape::Sugarscape.new(rows: rows_count, cols: cols_count)
  end
  
  def plant_sugar
    sugar_count = sugarscape_params.sugar_count
    
    if !sugar_count.between?(1, @sugarscape.cells_count)
      Kernel::raise(RuntimeError, "Too much Sugar for this Sugarscape.")
    end
    
    sugar_count.times do
      new_sugar = @new_sugar_proc.call
      row, col = @sugar_placement_proc.call
      
      new_sugar.move_to(row, col)
      @sugarscape.add_sugar new_sugar
      @view.add_sugar new_sugar
    end
  end
  
  def settle_agents
    agents_count = sugarscape_params.agents_count
    
    if !agents_count.between?(1, @sugarscape.cells_count)
      Kernel::raise(RuntimeError, "Too much Agents for this Sugarscape.")
    end
    
    agents_count.times do
      new_agent = @new_agent_proc.call
      row, col = @agent_placement_proc.call
      
      new_agent.move_to(row, col)
      @sugarscape.place_agent new_agent
      @population << new_agent
      @view.add_agent new_agent
    end
  end
  
  def spread_info
    @population.each { |agent| @info_placement_proc.call agent }
  end
end
