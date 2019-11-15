require 'aws-sdk-rdsdataservice'
require 'json'

module Handler
  class User
    class Get
      def self.call(event:, context: {})
        id = event['pathParameters']['id']

        sql = <<~SQL
          SELECT id, name FROM users WHERE id=:id::uuid;
        SQL

        parameters = [
          { name: 'id', value: { string_value: id }}
        ]

        response = client.execute_statement(
          database: ENV['DATABASE_NAME'],
          schema: ENV['DATABASE_NAME'],
          resource_arn: ENV['DATABASE_RESOURCE_ARN'],
          secret_arn: ENV['DATABASE_SECRET_ARN'],
          sql: sql,
          parameters: parameters
        )

        record = response.records[0]

        if record
          result = {
            id: record[0].string_value,
            name: record[1].string_value
          }

          {
            statusCode: 200,
            body: JSON.generate(result)
          }
        else
          {
            statusCode: 404
          }
        end
      end

      def self.client
        @_client ||= Aws::RDSDataService::Client.new(region: 'ap-northeast-1')
      end
    end
  end
end
