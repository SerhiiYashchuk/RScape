require 'Qt'

module RScape
  module GUI
    class Runner < Qt::Widget
      slots 'iterate()', 'start()', 'stop()'
      
      attr_reader :timer
      attr_accessor :tps
      
      def initialize(parent = nil)
        super parent
        
        @timer = Qt::Timer.new
        @proc = Proc.new { }
        @tps = 1
        
        connect(@timer, SIGNAL('timeout()'), self, SLOT('iterate()'))
      end
      
      def set_iteration_proc(& proc)
        @proc = proc
      end
      
      def iterate
        @proc.call
      end
      
      def start
        @timer.start 1000 / @tps
      end
      
      def stop
        @timer.stop
      end
    end
  end
end
