require 'aws-sdk-rdsdataservice'
require 'json'

module Handler
  class User
    class Post
      def self.call(event:, context: {})
        attributes = JSON.parse(event['body'], symbolize_names: true)

        sql = <<~SQL
          INSERT INTO users (name) VALUES (:name) RETURNING id, name;
        SQL

        parameters = [
          { name: 'name', value: { string_value: attributes[:name] }}
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

        result = {
          id: record[0].string_value,
          name: record[1].string_value
        }

        {
          statusCode: 201,
          body: JSON.generate(result)
        }
      end

      def self.client
        @_client ||= Aws::RDSDataService::Client.new(region: 'ap-northeast-1')
      end
    end
  end
end
