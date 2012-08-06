require 'simplecov'
require 'pp'
SimpleCov.start do
    add_filter "/vendor/"
    add_filter "/coverage/"
    add_filter "/doc/"
end

require './lib/newrelic_data'

module Curl
  class Easy
    def self.perform str, &block
      data = DummyData.new
      yield(data)
      case str
      when /\.json/
        data.body_str = File.read('./spec/dummy_data.json')
      when /\.xml/
        data.body_str = File.read('./spec/dummy_data.xml')
      when /\.csv/
        data.body_str = File.read('./spec/dummy_data.csv')
      end
      return data
    end
  end
end

class DummyData
  attr_accessor :body_str, :headers
  def initialize 
    @headers = {}
  end
end
