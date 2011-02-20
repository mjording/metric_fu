require 'pathname'
require 'optparse'
require 'metric_abc'


module MetricFu
  class MetricABC < Generator
    def emit
      files = []
      .collect do |filename|
        MetricABC.new(filename).complexity
      end.inject({}) do |merged, current|
       merged.merge(current) 
      end.sort{|a,b| b[1]<=>a[1]}.each do |function, score|
       puts "#{function}: #{score}"
      end
      
    end
    def analyze

    end
    def to_h

    end

  end
  class MethodContainer
      attr_reader :methods

      def initialize(name, path)
        @name = name
        add_path path
        @methods = {}
      end

      def add_path path
        return unless path
        @path ||= path.split(':').first
      end

      def add_method(full_method_name, operators, score, path)
        @methods[full_method_name] = {:operators => operators, :score => score, :path => path}
      end

      def to_h
        { :name => @name,
          :path => @path || '',
          :total_score => total_score,
          :highest_score => highest_score,
          :average_score => average_score,
          :methods => @methods}
      end

      def highest_score
        method_scores.max
      end

      private

      def method_scores
        @method_scores ||= @methods.values.map {|v| v[:score] }
      end

      def total_score
        @total_score ||= method_scores.inject(0) {|sum, score| sum += score}
      end

      def average_score
        total_score / method_scores.size.to_f
      end
   end
end
