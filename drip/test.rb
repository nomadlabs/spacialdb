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
     		 @stubs.get "12345/subscribers/#{CGI.escape @id}" do
       		 [@response_status, {}, @response_body]
     			 end
	    end
   		 should "is sending correct request" do
    		  expected = Drip::Response.new(@response_status, @response_body)
      		assert_equal expected, @client.subscriber(@id)
   	 end
  end

