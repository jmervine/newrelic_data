require 'date'
require 'curb'
require 'json'
require 'xmlsimple'
require 'csv'
require 'uri'

# A simple utility for getting data from NewRelic based
# loosly off of NewRelic's API.
class NewRelicData

  # Version for gem.
  VERSION = "0.0.4"

  # @return [String] NewRelic API key.
  attr_accessor :api_key
 
  # @return [Boolean] Use 'http' or 'https', defaults to true.
  attr_accessor :ssl

  # @return [String] NewRelic API host, defaults to 'rpm.newrelic.com'.
  attr_accessor :host
 
  # @return [Fixnum] NewRelic API port, defaults to '80'.
  attr_accessor :port
 
  # @return [Fixnum] NewRelic Account ID.
  attr_accessor :account
  
  # @return [Fixnum] NewRelic Application ID.
  attr_accessor :application
 
  # @return [String] Format to return NewRelic data; valid options:
  # * json
  # * xml
  # * csv
  attr_accessor :format
 
  # @return [Hash] Parameters to be passed to NewRelic API.
  attr_accessor :query_params

  # == Parameters:
  # See {#configure}.
  def initialize opts={}
    self.ssl = true
    configure(opts)
  end

  # == Parameters:
  # api_key::
  #   See {#api_key}
  # ssl::
  #   See {#ssl}
  # host:: 
  #   See {#host}
  # port::
  #   See {#port}
  # application::
  #   See {#application}
  # account::
  #   See {#account}
  # format::
  #   See {#format}
  # query_params::
  #   See {#query_params}
  #
  # == Example:
  #
  #     nr.configure( :query_params => { :metrics => [ "Apdex" ], :field => "score" },
  #                   :format => "xml",
  #                   :account => 4321, 
  #                   :application => 654321 )
  def configure opts
    opts.each do |key,val| 
      self.send("#{key}=".to_sym, val)
    end
  end

  # @return [Hash] or [Array] parsed data from NewRelic. 
  def fetch
    case self.format
    when "json"
      return JSON.parse(fetch_raw)
    when "xml"
      return XmlSimple.xml_in(fetch_raw)
    when "csv"
      return CSV.parse(fetch_raw)
    else
      raise "unsupport format '#{self.format}', try #fetch_raw"
    end
  end

  # @return [String] raw data from NewRelic.
  def fetch_raw
    Curl::Easy.perform(fetch_path) do |curl|
      curl.headers['x-api-key'] = self.api_key
    end.body_str
  end

  # @return [String] URI to be used to fetch content
  def fetch_path
    port = ":#{self.port}" unless self.port.nil? or self.port == 80
    "#{self.ssl ? 'https' : 'http' }://#{self.host}#{port}/api/v1/#{self.account}/metrics/data.#{self.format}?#{self.query_string}"
  end

  # @return [String] NewRelic API key.
  def api_key
    raise "api_key required" unless @api_key
    @api_key
  end

  # @return [String] NewRelic API host, defaults to 'api.newrelic.com'.
  def host
    @host||"api.newrelic.com"
  end

  # @return [Fixnum] NewRelic API port, defaults to '80'.
  def port
    @port||80
  end
 
  # @return [Fixnum] NewRelic Application ID.
  def application
    raise "application required" unless @application
    @application
  end

  def application=(a)
    @application = a
    if @application.kind_of? String and @application.to_i == 0
      self.query_params = self.query_params.merge({ "app_name" => @application })
      self.query_params.delete("app_id") if self.query_params.has_key?("app_id")
    else
      self.query_params = self.query_params.merge({ "app_id" => @application })
      self.query_params.delete("app_name") if self.query_params.has_key?("app_name")
    end
    @application
  end

  # @return [Fixnum] NewRelic Account ID.
  def account
    raise "account required" unless @account
    "accounts/#{@account}"
  end

  # @return [String] Format to return NewRelic data; valid options:
  # * json
  # * xml
  # * csv
  def format
    @format||"json"
  end

  # @return [Hash] Parameters to be passed to NewRelic API.
  #
  # == Parameters:
  # * "metrics" -- [Array]  (see NewRelic API)
  # * "field"   -- [String] (see NewRelic API)
  # * "begin"   -- [String] (format: YYYY-MM-DDTHH:MM:SSZ)
  # * "end"     -- [String] (format: YYYY-MM-DDTHH:MM:SSZ)
  #
  # == Note:
  # 'begin' and 'end' can be set using X.days_ago or helpers {#today} or {#yesterday}
  def query_params
    @query_params||{ "metrics" => [ "Apdex" ], "field" => "score", "begin" => 1.day_ago, "end" => self.today, "summary" => 1 }
  end

  def query_params=(q)
    @query_params = q
    @query_params["app_id"] = @application if @application and !@query_params.has_key?("app_id")
  end

  # @return [String] {#query_params} as a URI query string.
  def query_string
    q = []
    self.query_params.each do |key,val|
      if val.kind_of? Array
        val.each do |v|
          q.push "#{key}[]=#{v}"
        end
      else
        q.push "#{key}=#{val}"
      end
    end
    URI.escape(q.join("&"))
  end

  # @return [String] Today formated for 'begin' or 'end' {#query_params}.
  def today
    0.days_ago
  end

  # @return [String] Yesterday formated for 'begin' or 'end' {#query_params}.
  def yesterday
    1.day_ago
  end

  # @return [String] Formatted date / time
  def self.date_formatter(date_time)
    date_time.strftime("%Y-%m-%dT%H:%M:%SZ")
  end

  def date_formatter(date_time)
    self.class.date_formatter(date_time)
  end

end

# Monkey patch of the [Integer] object for quickly generating
# {NewRelicData#query_params} options 'begin' and 'end'.
class Integer
  # @return [String] formated for {NewRelicData#query_params} 'begin' and 'end'.
  # * N.days_ago at '00:00:00'
  def days_ago
    (DateTime.now-self).strftime("%Y-%m-%dT00:00:00Z")
  end
  alias :day_ago :days_ago
  def hours_ago
    (DateTime.now-self/24.0).strftime("%Y-%m-%dT%H:00:00Z")
  end
  alias :hour_ago :hours_ago
end

