require 'Qt'

module RScape
  module GUI
    # Widget for setting Information parameters.
    class InfoParams < Qt::GroupBox
      # Creates a new widget.
      def initialize(parent = nil)
        super parent
        
        chunks_label = Qt::Label.new 'Chunks:'
        initial_bearers_label = Qt::Label.new 'Initial bearers:'
        @chunks_edit = Qt::LineEdit.new ''
        @initial_bearers_edit = Qt::LineEdit.new '0'
        
        main_layout = Qt::VBoxLayout.new
        chunks_layout = Qt::VBoxLayout.new
        initial_bearers_layout = Qt::VBoxLayout.new
        
        chunks_layout.addWidget chunks_label
        chunks_layout.addWidget @chunks_edit
        initial_bearers_layout.addWidget initial_bearers_label
        initial_bearers_layout.addWidget @initial_bearers_edit
        main_layout.addLayout chunks_layout
        main_layout.addLayout initial_bearers_layout
        
        setLayout main_layout
        setTitle 'Information'
      end
      
      # Info chunks getter.
      #
      # Returns an Array of Strings.
      def chunks
        @chunks_edit.text.split
      end
      
      # Info chunks setter.
      #
      # value - an Array of Strings.
      def chunks=(value)
        @chunks_edit.setText value.join(' ')
      end
      
      # Initial bearers parameter getter.
      def initial_bearers
        @initial_bearers_edit.text.to_i
      end
      
      # Initial bearers parameter setter.
      def initial_bearers=(value)
        @initial_bearers_edit.setText value.to_s
      end
    end
  end
end
