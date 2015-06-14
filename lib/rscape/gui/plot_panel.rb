require 'Qt'
require_relative '../plot.rb'

module RScape
  module GUI
    # Panel with plot creation parameters.
    class PlotPanel < Qt::Widget
      # List of available X values.
      attr_reader :x_data_list
      # List of available Y values.
      attr_reader :y_data_list
      # List of plot types.
      attr_reader :type_list
      # Make plot button.
      attr_reader :plot_button
      
      # Creates a new panel.
      def initialize(parent = nil)
        super parent
        
        x_data_label = Qt::Label.new 'X values:'
        y_data_label = Qt::Label.new 'Y values:'
        type_label = Qt::Label.new 'Type:'
        @x_data_list = Qt::ComboBox.new
        @y_data_list = Qt::ComboBox.new
        @type_list = Qt::ComboBox.new
        @plot_button = Qt::PushButton.new 'Make plot'
        
        x_data_layout = Qt::VBoxLayout.new
        y_data_layout = Qt::VBoxLayout.new
        type_layout = Qt::VBoxLayout.new
        lists_layout = Qt::HBoxLayout.new
        button_layout = Qt::HBoxLayout.new
        main_layout = Qt::VBoxLayout.new
        
        @type_list.addItems ['point', 'line', 'histo']
        @type_list.setMaximumWidth 75
        
        @plot_button.setMaximumWidth 150
        
        x_data_layout.addWidget x_data_label
        x_data_layout.addWidget @x_data_list
        y_data_layout.addWidget y_data_label
        y_data_layout.addWidget @y_data_list
        type_layout.addWidget type_label
        type_layout.addWidget @type_list
        lists_layout.addLayout x_data_layout
        lists_layout.addLayout y_data_layout
        lists_layout.addLayout type_layout
        button_layout.addStretch
        button_layout.addWidget @plot_button
        button_layout.addStretch
        main_layout.addLayout lists_layout
        main_layout.addLayout button_layout
        
        setLayout main_layout
      end
    end
  end
end
