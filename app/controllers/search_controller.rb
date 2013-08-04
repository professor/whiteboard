require 'open-uri'

class SearchController < ApplicationController
  layout 'cmu_sv'
  before_filter :authenticate_user!

  def self.index_tank
    @api = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || 'http://your_api_url')
    @index ||= @api.indexes(ENV['SEARCHIFY_INDEX'] || 'cmux')
    @index
  end

  # retrieve docs from IndexTank
  def self.search(query)
    index_tank.search("#{query} OR title:#{query}", :fetch => 'timestamp,url,text,title', :snippet => 'text')
  end

  def index
    query_string = params[:query].gsub(/[^0-9a-zA-Z.\s]/, "").strip if params[:query]
    @docs = SearchController.search(query_string) if query_string.present?
  end
end
