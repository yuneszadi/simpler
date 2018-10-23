require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      if @request.env['simpler.template'].is_a?(Hash)
        return @response['Content-Type'] = check_request
      end

      @response['Content-Type'] = 'text/html'
    end

    def check_request
      if @request.env['simpler.template'].first[0] == :plain
        return 'text/plain'
      else
        return 'text/html'
      end
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def headers(headers)
      headers.each_pair { |key, value| @response[key.to_s] = value.to_s }
    end

    def status(status)
      @response.status = status
    end
  end
end
