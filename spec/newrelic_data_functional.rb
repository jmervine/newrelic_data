require 'functional_helper'

describe NewRelicData, "functional tests" do
  before(:all) do
    @newrelic = NewRelicData.new( api_key: API_KEY, account: ACCT_ID, application: APP_ID )
  end
  describe :fetch_raw do
    it "should fetch raw json" do
      results = nil
      expect { results = JSON.parse(@newrelic.fetch_raw) }.to_not raise_error
      results.first.should have_key "score"
    end
    it "should fetch raw xml" do
      @newrelic.format = "xml"
      results = nil
      expect { results = XmlSimple.xml_in(@newrelic.fetch_raw) }.to_not raise_error
      results["metric"].first["field"].first.should have_key "content"
    end
    it "should fetch raw csv" do
      @newrelic.format = "csv"
      results = nil
      expect { results = CSV.parse(@newrelic.fetch_raw) }.to_not raise_error
      results.first.include?("Score").should be_true
    end
  end
  describe :fetch do
    it "should fetch parse json" do
      @newrelic.format = "json"
      results = nil
      expect { results = @newrelic.fetch }.to_not raise_error
      results.first.should have_key "score"
    end
    it "should fetch parse xml" do
      @newrelic.format = "xml"
      results = nil
      expect { results = @newrelic.fetch }.to_not raise_error
      results["metric"].first["field"].first.should have_key "content"
    end
    it "should fetch parse csv" do
      @newrelic.format = "csv"
      results = nil
      expect { results = @newrelic.fetch }.to_not raise_error
      results.first.include?("Score").should be_true
    end
  end
end
