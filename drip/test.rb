require File.dirname(_FILE_) + '/../../test_helper.rb'

class Drip::Client::Accountstest < Drip::TestCase
	def setup
		@stubs = Faraday::Adapter::Test::Stubs.new

		@connection = Faraday.new do |builder|
			builder.adapter :test, @stubs
		end

		@client = Drip::Client.new
		@client.expects(:connection).at_least_once.returns(@connection)
		end

context "#subscriber" do
 	   setup do
     		 @id = "derrick@getdrip.com"
     		 @response_status = 201
      @response_body = stub
  end

