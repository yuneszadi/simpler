require 'logger'
module Middleware
  class SimplerLogger

    def initialize(app, **options)
      @logger = Logger.new(Simpler.root.join(options[:logdev] || STDOUT))
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      @logger.info(log_info(env, status, headers))
      [status, headers, response]
    end

    private

    def log_info(env, status, headers)
      "#{env['REQUEST_METHOD']} #{env['REQUEST_URI']}"
      "#{env['simpler.controller'].class}##{env['simpler.action']}"
      "#{env['simpler.route.params']}"
      "#{status} [#{headers['Content-Type']}] #{env['simpler.view']}" 
    end
  end
end
