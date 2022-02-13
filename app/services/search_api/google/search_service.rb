# frozen_string_literal: true

module SearchApi
  module Google
    class SearchService < ApplicationService
      def initialize(search_string, options)
        @search_string = URI.encode_www_form_component(search_string)
        @options = options
      end

      def call
        result = SearchApi::Google::QueryService.call(search_string, options)
        if result.success?
          OpenStruct.new(success?: true, collection: parse_data(result.collection))
        else
          OpenStruct.new(success?: false, error: result.error)
        end
      end

      private

      attr_reader :search_string, :options

      def parse_data(collection)
        collection.map do |data|
          {
            name: data['title'],
            url: data['link']
          }
        end
      end
    end
  end
end
