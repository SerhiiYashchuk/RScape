require 'Qt'

module RScape
  module GUI
    # Widget for setting Agent parameters.
    class AgentParams < Qt::Widget
      # Creates a new widget.
      def initialize(parent = nil)
        super parent
        
        wealth_label = Qt::Label.new "Initial wealth:"
        metabolism_label = Qt::Label.new "Metabolism:"
        vision_label = Qt::Label.new "Vision:"
        max_age_label = Qt::Label.new "Maximum age:"
        @wealth_edit = Qt::LineEdit.new "0"
        @metabolism_edit = Qt::LineEdit.new "0"
        @vision_edit = Qt::LineEdit.new "0"
        @max_age_edit = Qt::LineEdit.new "0"
        
        main_layout = Qt::VBoxLayout.new
        row_1_layout = Qt::HBoxLayout.new
        row_2_layout = Qt::HBoxLayout.new
        wealth_layout = Qt::VBoxLayout.new
        metabolism_layout = Qt::VBoxLayout.new
        vision_layout = Qt::VBoxLayout.new
        max_age_layout = Qt::VBoxLayout.new
        
        wealth_layout.addWidget wealth_label
        wealth_layout.addWidget @wealth_edit
        metabolism_layout.addWidget metabolism_label
        metabolism_layout.addWidget @metabolism_edit
        vision_layout.addWidget vision_label
        vision_layout.addWidget @vision_edit
        max_age_layout.addWidget max_age_label
        max_age_layout.addWidget @max_age_edit
        row_1_layout.addLayout wealth_layout
        row_1_layout.addLayout metabolism_layout
        row_2_layout.addLayout vision_layout
        row_2_layout.addLayout max_age_layout
        main_layout.addLayout row_1_layout
        main_layout.addLayout row_2_layout
        
        setLayout main_layout
      end
      
      # Wealth parameter getter. Supports Range.
      def wealth
        extract_values @wealth_edit.text
      end
      
      # Wealth parameter setter. Supports Range.
      def wealth=(value)
        @wealth_edit.setText value.to_s
      end
      
      # Metabolism parameter getter. Supports Range.
      def metabolism
        extract_values @metabolism_edit.text
      end
      
      # Metabolism parameter setter. Supports Range.
      def metabolism=(value)
        @metabolism_edit.setText value.to_s
      end
      
      # Vision parameter getter. Supports Range.
      def vision
        extract_values @vision_edit.text
      end
      
      # Vision parameter setter. Supports Range.
      def vision=(value)
        @vision_edit.setText value.to_s
      end
      
      # Maximum age parameter getter. Supports Range.
      def max_age
        extract_values @max_age_edit.text
      end
      
      # Maximum age parameter setter. Supports Range.
      def max_age=(value)
        @max_age_edit.setText value.to_s
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
