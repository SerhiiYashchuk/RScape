require 'Qt'

module RScape
  module GUI
    # Statistic table Widget.
    class Statistic < Qt::Widget
      # Creates a new Widget.
      def initialize(title, entries = {}, parent = nil)
        super parent
        
        @table = Qt::TableWidget.new(entries.count, 1)
        @label = Qt::Label.new title
        @entries = {}
        layout = Qt::VBoxLayout.new
        
        layout.addWidget @label
        layout.addWidget @table
        setLayout layout
        
        @table.setVerticalHeaderLabels entries.keys
        @table.horizontalHeader.hide
        @table.setEditTriggers Qt::AbstractItemView::NoEditTriggers
        
        row = -1
        
        entries.each do |name, value|
          new_entry = Qt::TableWidgetItem.new value.to_s
          
          new_entry.setTextAlignment Qt::AlignRight
          @entries[name] = new_entry
          @table.setItem(row, 1, new_entry)
          
          row += 1
        end
      end
      
      # Title getter.
      def title
        @label.text
      end
      
      # Title setter.
      def title=(value)
        @label.setText value
      end
      
      # Returns value of statistic named +name+.
      def [](name)
        @entries[name].text
      end
      
      # Sets value of statistic named +name+.
      def []=(name, value)
        @entries[name].setText value.to_s
      end
    end
  end
end
