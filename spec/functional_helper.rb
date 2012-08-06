require 'pp'
require './lib/newrelic_data'


API_KEY = "SETME"
ACCT_ID = "SETME"
APP_ID  = "SETME"

if API_KEY == "SETME" or ACCT_ID == "SETME" or APP_ID == "SETME"
  abort "ABORT: Please ensure that you have set API_KEY, ACCT_ID and APP_ID in 'spec/functional_helper.rb' before running functional test."
end

