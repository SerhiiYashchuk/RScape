require 'Qt'

module RScape
  module GUI
    # Log Widget.
    class Log < Qt::Widget
      slots 'clear()', 'add(const char *, const char *)'
      
      # Creates a new Widget.
      def initialize(parent = nil)
        super parent
        
        @text = Qt::TextEdit.new
        layout = Qt::HBoxLayout.new
        
        @text.setReadOnly true
        layout.addWidget @text
        setLayout layout
      end
      
      # Adds new entry.
      #
      # entry - String to be added to the log.
      # color - color (hex) of an entry.
      def add(entry, color: '#000000')
        @text.append "<font color='#{color}'>#{entry}</font>"
      end
      
      # Deletes all entries.
      def clear
        @text.clear
      end
      
      # Saves log to file.
      def export_to(file_path)
        Qt::TextDocumentWriter.new(file_path).write @text.document
      end
    end
  end
end
