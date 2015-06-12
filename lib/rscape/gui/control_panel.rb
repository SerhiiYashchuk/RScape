require 'Qt'

module RScape
  module GUI
    # Widget with simulation control elements.
    class ControlPanel < Qt::Widget
      # Start button.
      attr_reader :start_button
      # Stop button.
      attr_reader :stop_button
      
      # Creates a new Widget.
      def initialize(parent = nil)
        super parent
        
        @start_button = Qt::PushButton.new 'Start'
        @stop_button = Qt::PushButton.new 'Stop'
        layout = Qt::HBoxLayout.new
        
        @start_button.setMaximumWidth 150
        @stop_button.setMaximumWidth 150
        layout.addStretch
        layout.addWidget @start_button
        layout.addWidget @stop_button
        layout.addStretch
        setLayout layout
      end
    end
  end
end
