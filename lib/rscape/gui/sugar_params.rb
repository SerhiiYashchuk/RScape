require 'Qt'

module RScape
  module GUI
    # Widget for setting Sugar parameters.
    class SugarParams < Qt::GroupBox
      # Creates a new Widget.
      def initialize(parent = nil)
        super parent
        
        capacity_label = Qt::Label.new "Capacity:"
        level_label = Qt::Label.new "Level:"
        growth_label = Qt::Label.new "Growth:"
        @capacity_edit = Qt::LineEdit.new "0"
        @level_edit = Qt::LineEdit.new "0"
        @growth_edit = Qt::LineEdit.new "0"
        
        main_layout = Qt::VBoxLayout.new
        row_1_layout = Qt::HBoxLayout.new
        capacity_layout = Qt::VBoxLayout.new
        level_layout = Qt::VBoxLayout.new
        growth_layout = Qt::VBoxLayout.new
        
        capacity_layout.addWidget capacity_label
        capacity_layout.addWidget @capacity_edit
        level_layout.addWidget level_label
        level_layout.addWidget @level_edit
        growth_layout.addWidget growth_label
        growth_layout.addWidget @growth_edit
        row_1_layout.addLayout capacity_layout
        row_1_layout.addLayout level_layout
        row_1_layout.addLayout growth_layout
        main_layout.addLayout row_1_layout
        
        setLayout main_layout
        setTitle 'Sugar'
      end
      
      # Capacity getter. Supports Range.
      def capacity
        extract_values @capacity_edit.text
      end
      
      # Capacity setter. Supports Range.
      def capacity=(value)
        @capacity_edit.setText value.to_s
      end
      
      # Level getter. Supports Range.
      def level
        extract_values @level_edit.text
      end
      
      # Level setter. Supports Range.
      def level=(value)
        @level_edit.setText value.to_s
      end
      
      # Growth getter. Supports Range.
      def growth
        extract_values @growth_edit.text
      end
      
      # Growth setter. Supports Range.
      def growth=(value)
        @growth_edit.setText value.to_s
      end
      
      private
      
      # Extracts values from text.
      #
      # Returns Number or Range.
      def extract_values(string)
        values = string.split('..').map(&:to_i)
        
        if values.count == 1
          values.first
          
        elsif values.count == 2
          values[0]..values[1]
        
        else
          0
        end
      end
    end
  end
end
