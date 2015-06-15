require_relative 'sugarscape_params.rb'
require_relative 'sugar_params.rb'
require_relative 'agent_params.rb'
require_relative 'info_params.rb'
require_relative 'statistic.rb'
require_relative 'control_panel.rb'
require_relative 'plot_panel.rb'
require_relative 'log.rb'
require_relative 'sugarscape_view.rb'

module RScape
  module GUI
    # Main window Widget.
    class MainWindow < Qt::Widget
      # Number of agents.
      STAT_AGENTS_NUM = :agents_number
      # Average age.
      STAT_AVG_AGE = :avg_age
      # Average vision.
      STAT_AVG_VISION = :avg_vision

      # Average wealth.
      STAT_AVG_WEALTH = :avg_wealth
      # Gini coefficient.
      STAT_GINI = :gini
      
      # Information percentage.
      STAT_INFO_PERCENT = :spread_percent
      
      # Maximum width of buttons.
      BUTTONS_MAXIMUM_WIDTH = 100
      
      # Sugarscape parameters Widget.
      attr_reader :sugarscape_params
      # Sugar parameters Widget.
      attr_reader :sugar_params
      # Agent parameters Widget.
      attr_reader :agent_params
      # Info params Widget.
      attr_reader :info_params
      # Social statistics Widget.
      attr_reader :social_statistic
      # Economical statistics Widget.
      attr_reader :economical_statistic
      # Info spread statistics Widget.
      attr_reader :info_spread_statistic
      # Control panel.
      attr_reader :control_panel
      # Plot making panel.
      attr_reader :plot_panel
      # Sugarscape view.
      attr_reader :view
      # Log Widget.
      attr_reader :log
      
      # Creates a new Window.
      def initialize
        super
        
        @side_panel = Qt::ToolBox.new
        @control_panel = ControlPanel.new
        @view = SugarscapeView.new 15
        @log = Log.new
        
        @side_panel.addItem(create_params_panel, 'Parameters')
        @side_panel.addItem(create_statistics_panel, 'Statistics')
        @side_panel.setMinimumWidth 350
        @side_panel.setMaximumWidth 350
        
        @control_panel.setMaximumWidth 350
        @control_panel.stop_button.setEnabled false
        
        @view.setMinimumSize(600, 600)
        @view.setMaximumSize(1000, 1000)
        @view.resize(600, 600)
        
        @log.setMinimumHeight 200
        
        side_panel_layout = Qt::VBoxLayout.new
        vertical_layout = Qt::VBoxLayout.new
        horizontal_layout = Qt::HBoxLayout.new
        main_layout = Qt::HBoxLayout.new
        
        side_panel_layout.addWidget @side_panel
        side_panel_layout.addWidget @control_panel
        vertical_layout.addStretch
        vertical_layout.addWidget @view
        vertical_layout.addStretch
        vertical_layout.addWidget @log
        horizontal_layout.addStretch
        horizontal_layout.addLayout vertical_layout
        horizontal_layout.addStretch
        main_layout.addLayout side_panel_layout
        main_layout.addLayout horizontal_layout

        setLayout main_layout
      end
      
      def show_parameters_panel
        @side_panel.setCurrentIndex 0
      end
      
      def show_statistics_panel
        @side_panel.setCurrentIndex 1
      end
      
      private
      
      # Creates model parameters panel.
      #
      # Returns panel as Widget.
      def create_params_panel
        params_panel = Qt::Widget.new
        params_layout = Qt::VBoxLayout.new
        
        @sugarscape_params = SugarscapeParams.new
        @sugar_params = SugarParams.new
        @agent_params = AgentParams.new
        @info_params = InfoParams.new
        
        params_layout.addWidget @sugarscape_params
        params_layout.addWidget @sugar_params
        params_layout.addWidget @agent_params
        params_layout.addWidget @info_params
        params_layout.addStretch
        
        params_panel.setLayout params_layout
        
        params_panel
      end
      
      # Creates model statistics panel.
      #
      # Returns panel as Widget.
      def create_statistics_panel
        statistics_panel = Qt::Widget.new
        statistics_layout = Qt::VBoxLayout.new
        
        @social_statistic = Statistic.new('<b>Social</b>', {
          STAT_AGENTS_NUM => 0,
          STAT_AVG_AGE => 0,
          STAT_AVG_VISION => 0
          })
        @economical_statistic = Statistic.new('<b>Economical</b>', {
          STAT_AVG_WEALTH => 0,
          STAT_GINI => 0
          })
        @info_spread_statistic = Statistic.new('<b>Info spread</b>', {
          STAT_INFO_PERCENT => 0
          })
        
        statistics_layout.addWidget @social_statistic
        statistics_layout.addWidget @economical_statistic
        statistics_layout.addWidget @info_spread_statistic
        statistics_layout.addWidget create_plot_panel
        statistics_layout.addStretch
        
        statistics_panel.setLayout statistics_layout
        
        statistics_panel
      end
      
      # Creates plot panel.
      #
      # Returns panel as a Widget.
      def create_plot_panel
        @plot_panel = PlotPanel.new
        
        data_list = [
          :iteration,
          STAT_AGENTS_NUM,
          STAT_AVG_AGE,
          STAT_AVG_VISION,
          STAT_AVG_WEALTH,
          STAT_GINI,
          STAT_INFO_PERCENT
        ]
        
        data_list.map!(&:to_s)
        
        @plot_panel.x_data_list.addItems data_list
        @plot_panel.y_data_list.addItems data_list
        
        @plot_panel
      end
    end
  end
end
