require 'Qt'

module RScape
  module GUI
    # Widget with simulation control elements.
    class ControlPanel < Qt::Widget
      # Start button.
      attr_reader :start_button
      # Stop button.
      attr_reader :stop_button
      # Reset button.
      attr_reader :reset_button
      
      # Creates a new Widget.
      def initialize(parent = nil)
        super parent
        
        button_maximum_width = 150
        
        @start_button = Qt::PushButton.new 'Start'
        @stop_button = Qt::PushButton.new 'Stop'
        @reset_button = Qt::PushButton.new 'Reset'
        
        layout = Qt::HBoxLayout.new
        
        @start_button.setMaximumWidth button_maximum_width
        @stop_button.setMaximumWidth button_maximum_width
        @reset_button.setMaximumWidth button_maximum_width
        
        layout.addStretch
        layout.addWidget @start_button
        layout.addWidget @stop_button
        layout.addWidget @reset_button
        layout.addStretch
        
        setLayout layout
      end
    end
  end
end
