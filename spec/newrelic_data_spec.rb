require 'spec_helper'
describe NewRelicData do
  before(:all) do
    @n = NewRelicData.new
  end

  describe :new, "with params" do
    before(:all) do
      @set_test = {
        api_key:      "test_api_key",
        host:         "test.host.com",
        port:         8080,
        format:       "xml"
      }
    end
    
    it "should set params from passed options" do
      n = nil
      expect { n = NewRelicData.new @set_test }.to_not raise_error
      @set_test.each do |key,val|
        n.send(key).should eq @set_test[key]
      end
    end
  end

  # attributes with defaults
  [ :ssl, :host, :port, :format ].each do |attr|
    describe attr do
      it 'should have default value' do
        @n.send(attr).should_not be_nil
      end
      it 'should set from value' do
        @n.send("#{attr}=".to_sym, "foobar").should be
        @n.send(attr).should eq "foobar"
      end
    end
  end

  describe :query_string do
    it "return query param string for fetching data from NewRelic" do
      n = NewRelicData.new( account: 4321, application: 543210 )
      str = n.query_string
      str.should match /metrics\[\]=Apdex/
      str.should match /field=score/
      str.should match /app_id=543210/
    end
  end

  describe :fetch_path do
    it "return URI string for fetching data from NewRelic" do
      n = NewRelicData.new( account: 4321, application: 543210 )
      str = n.fetch_path
      str.should match /^https/
      str.should match /\.json/
      str.should match /accounts\/4321/
      str.should match /app_id=543210/
      str.should match /metrics\[\]=Apdex/
      str.should match /field=score/
    end
  end

  describe :fetch_raw do
    before(:all) do
      @nr = NewRelicData.new( account: 4321, application: 543210, api_key: "test_api_key" )
    end
    it "should fetch raw json" do
      @nr.format = "json"
      expect { JSON.parse(@nr.fetch_raw) }.to_not raise_error
    end
    it "should fetch raw xml" do
      @nr.format = "xml"
      expect { XmlSimple.xml_in(@nr.fetch_raw) }.to_not raise_error
    end
    it "should fetch raw csv" do
      @nr.format = "csv"
      expect { CSV.parse(@nr.fetch_raw) }.to_not raise_error
    end
  end

  describe :fetch do
    before(:all) do
      @nr = NewRelicData.new( account: 4321, application: 543210, api_key: "test_api_key" )
    end
    it "should fetch parsed json" do
      @nr.format = "json"
      @nr.fetch.should be_a Hash
      @nr.fetch.should have_key "foo"
    end
    it "should fetch parsed xml" do
      @nr.format = "xml"
      @nr.fetch.should be_a Hash
      @nr.fetch.should have_key "foo"
    end
    it "should fetch parsed csv" do
      @nr.format = "csv"
      @nr.fetch.should be_a Array
      @nr.fetch.first.first.should eq "foo"
    end
    it "should raise error when format is unknown" do
      @nr.format = "bad"
      expect { @nr.fetch }.to raise_error RuntimeError
    end
  end

  # attributes without defaults
  [ :api_key, :application, :account ].each do |attr|
    describe attr do
      it 'should raise error if not set' do
        expect { @n.send(attr) }.to raise_error
      end
      it 'should set from value' do
        @n.send("#{attr}=".to_sym, "foobar").should be
        @n.send(attr).should match /foobar/
      end
    end
  end

  describe :application do
    it "should set app_id in query_param" do
      @n.application = 54321
      @n.query_params.should have_key "app_id"
      @n.query_params.should_not have_key "app_name"
      @n.query_params["app_id"].should eq 54321
    end
    it "should set app_name in query_param" do
      @n.application = "foobar"
      @n.query_params.should have_key "app_name"
      @n.query_params.should_not have_key "app_id"
      @n.query_params["app_name"].should eq "foobar"
    end
  end

  describe :today do
    it "should return today" do
      DateTime.stub(:now).and_return(DateTime.parse("2012-06-07"))
      @n.today.should eq "2012-06-07T00:00:00Z"
    end
  end
  describe :yesterday do
    it "should return yesterday" do
      DateTime.stub(:now).and_return(DateTime.parse("2012-06-07"))
      @n.yesterday.should eq "2012-06-06T00:00:00Z"
    end
  end
end

describe Integer, "monkey patch" do
  describe :days_ago do
    (-5..5).each do |n|
      n = n*7
      it "it should return '#{n}' days ago" do
        DateTime.stub(:now).and_return(DateTime.parse("2012-06-07"))
        DateTime.parse(n.days_ago).should eq DateTime.parse("2012-06-07")-n
      end
    end
  end
end
