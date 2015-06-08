require 'Qt'

module RScape
  module GUI
    class Log < Qt::Widget
      slots 'clear()', 'add(const char *, const char *)'
      
      def initialize(parent = nil)
        super parent
        
        @text = Qt::TextEdit.new
        layout = Qt::HBoxLayout.new
        
        @text.setReadOnly true
        layout.addWidget @text
        setLayout layout
      end
      
      def add(entry, color: '#000000')
        @text.append "<font color='#{color}'>#{entry}</font>"
      end
      
      def clear
        @text.clear
      end
      
      def export_to(file_path)
        Qt::TextDocumentWriter.new(file_path).write @text.document
      end
    end
  end
end
