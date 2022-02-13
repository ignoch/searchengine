# frozen_string_literal: true

module Api
  module V1
    class SearchesController < ApplicationController
      def show; end

      def create
        @result = SearchApi::MakeSearch.call(query_params)

        if @result.success?
          render json: { data: @result.collection }
        else
          render json: { error: @result.error }, status: :unprocessable_entity
        end
      end

      private

      def query_params
        params.require(:search).permit(:engine, :text, :offset)
      end
    end
  end
end
