require 'json'

module Handler
  class Hello
    def self.call(event:, context: {})
      {
        statusCode: 200,
        body: JSON.pretty_generate(
          message: 'Hello World',
          event: event,
          context: context,
          env: Hash(ENV)
        )
      }
    end
  end
end
