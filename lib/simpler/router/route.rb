module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @path_arr = path.split('/').reject { |path| path.empty? }
      end

      def match?(env)
        env['simpler.route_params'] = ''
        method = env['REQUEST_METHOD'].downcase.to_sym
        path = env['PATH_INFO']
        if @method == method
          path = path.split('/').reject { |path| path.empty? }
          @path_arr.each_with_index do |value, index|
            if value[0] == ':'
              env['simpler.route_params'] += "#{path[index]}"
            else
              return false unless value == path[index]
            end
          end
        end
      end
    end
  end
end
