require 'Qt'

module RScape
  module GUI
    class Statistic < Qt::Widget
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
      
      def title
        @label.text
      end
      
      def title=(value)
        @label.setText value
      end
      
      def [](name)
        @entries[name].text
      end
      
      def []=(name, value)
        @entries[name].setText value.to_s
      end
    end
  end
end
