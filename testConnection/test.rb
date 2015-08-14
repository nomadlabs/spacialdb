class Foo::Client::Accountstest < Foo::TestCase
	def setup
		@stubs = Faraday::Adapter::Test::Stubs.new

		@connection = Faraday.new do |builder|
			builder.adapter :test, @stubs
		end

		@client = Foo::Client.new
		@client.expects(:connection).at_least_once.returns(@connection)
		end

context "#subscriber" do
 	   setup do
    	 	 @id = "sakonet@github.com"
     		 @response_status = 200
     		 @response_body = stub
     		 @stubs.get "12345/subscribers/#{CGI.escape @id}" do
       		 [@response_status, {}, @response_body]
     			 end
	    end
   		 should "is sending correct request" do
    		  expected = Foo::Response.new(@response_status, @response_body)
      		assert_equal expected, @client.subscriber(@id)
   	 end
  end

context "#unsubscribe" do
    setupt do
	@id= "sakonet@github.com"
	@respone_status=200
	@response_body=stub

        @stubs.post "12345/subscribers/#{CGI.escape @id}/unsubscribe" do
          [@response_status, {}, @response_body]
        end
      end
      should "send the right request" do
        expected = Git::Response.new(@response_status, @response_body)
        assert_equal expected, @client.unsubscribe(@id)
      end
    end
end
