require 'Qt'

module RScape
  module GUI
    # Widget for setting Sugarscape parameters.
    class SugarscapeParams < Qt::Widget
      # Creates a new Widget.
      def initialize(parent = nil)
        super parent
        
        rows_label = Qt::Label.new "Rows:"
        cols_label = Qt::Label.new "Columns:"
        agents_count_label = Qt::Label.new "Agents count:"
        sugar_count_label = Qt::Label.new "Sugar count:"
        @rows_edit = Qt::LineEdit.new "0"
        @cols_edit = Qt::LineEdit.new "0"
        @agents_count_edit = Qt::LineEdit.new "0"
        @sugar_count_edit = Qt::LineEdit.new "0"
        
        main_layout = Qt::VBoxLayout.new
        row_1_layout = Qt::HBoxLayout.new
        row_2_layout = Qt::HBoxLayout.new
        rows_layout = Qt::VBoxLayout.new
        cols_layout = Qt::VBoxLayout.new
        agents_count_layout = Qt::VBoxLayout.new
        sugar_count_layout = Qt::VBoxLayout.new
        
        rows_layout.addWidget rows_label
        rows_layout.addWidget @rows_edit
        cols_layout.addWidget cols_label
        cols_layout.addWidget @cols_edit
        agents_count_layout.addWidget agents_count_label
        agents_count_layout.addWidget @agents_count_edit
        sugar_count_layout.addWidget sugar_count_label
        sugar_count_layout.addWidget @sugar_count_edit
        row_1_layout.addLayout rows_layout
        row_1_layout.addLayout cols_layout
        row_2_layout.addLayout agents_count_layout
        row_2_layout.addLayout sugar_count_layout
        main_layout.addLayout row_1_layout
        main_layout.addLayout row_2_layout
        
        setLayout main_layout
      end
      
      # Rows number getter.
      def rows
        @rows_edit.text.to_i
      end
      
      # Rows number setter.
      def rows=(value)
        @rows_edit.setText value.to_s
      end
      
      # Columns number getter.
      def cols
        @cols_edit.text.to_i
      end
      
      # Columns number setter.
      def cols=(value)
        @cols_edit.setText value.to_s
      end
      
      # Agents number getter.
      def agents_count
        @agents_count_edit.text.to_i
      end
      
      # Agents number setter.
      def agents_count=(value)
        @agents_count_edit.setText value.to_s
      end
      
      # Sugar number getter.
      def sugar_count
        @sugar_count_edit.text.to_i
      end
      
      # Sugar number setter.
      def sugar_count=(value)
        @sugar_count_edit.setText value.to_s
      end
    end
  end
end
