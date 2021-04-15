class Api::V1::SearchesController < ApplicationController
  def show
  end

  def create
    @results = MakeSearch.call(query_params)

    render json: { data: @results }
  end

  private

  def query_params
    params.require(:search).permit(:engine, :text)
  end
end
