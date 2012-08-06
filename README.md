NewRelicData
============

This is a simple interface for accessing data through [NewRelic's RESTful API](https://newrelic.com/docs/docs/getting-started-with-the-new-relic-rest-api).

* [Gem on Rubygems.com](https://rubygems.org/gems/newrelic_data)
* [Documentation](http://jmervine.github.com/newrelic_data/doc/)
* [Coverage](http://jmervine.github.com/newrelic_data/coverage/)
* [History](https://github.com/jmervine/newrelic_data/blob/master/HISTORY.md)

### Installation

        gem install newrelic_data

Via Bundler

     sources :rubygems
     gem 'newrelic_data'

### Usage

     require 'newrelic_data'
     @newrelic = NewRelicData.new

     @newrelic.format = "json" # default
     
     @newrelic.configure({
         api_key:      "your_newrelic_api_key",
         account:      4321,     # NewRelic Account ID
         application:  654321,   # NewRelic Application ID 
         # Also supported:
         # application:  "app name",   # NewRelic Application name.
         query_params: {
             metrics:      [ "Apdex", "Apdex/home/index" ],
             field:        "score",
             begin:        @newrelic.today,
             end:          7.days_ago
         }
     })
     
     pp @newrelic.fetch

### Disclaimer

NewRelic (tm) is a trademark of [New Relic, Inc.](http://www.newrelic.com/). This was written without their consent and is in no way affiliated with them.

#### MIT License

Copyright (C) 2012 Joshua P. Mervine

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

