class Foo::Client::Accountstest < Foo::TestCase
	def setup
		@stubs = Faraday::Adapter::Test::Stubs.new

		@connection = Faraday.new do |builder|
			builder.adapter :test, @stubs
		end

		@client = Foo::Client.new
		@client.expects(:connection).at_least_once.returns(@connection)
		 assert_equal expected, @client.subscribe(@email, @campaign_id, @data)
		end

context "#subscriber" do
 	   setup do
    	 	 @id = "sakonet@github.com"
     		 @response_status = 201
     		 @response_body = stub
     		 @stubs.get "12345/subscribers/#{CGI.escape @id}" do
       		 [@response_status, {}, @response_body]
     			 end
	    end
   		 do
    		  expected = Foo::Response.new(@response_status, @response_body)
   		 assert_equal expected, @client.subscribe(@email, @campaign_id, @data) 
	end
  end

context "#unsubscribe" do
    setupt do
	@id= "sakonet@github.com"
	@respone_status=201
	@response_body=stub

        @stubs.post "12345/subscribers/#{CGI.escape @id}/unsubscribe" do
          [@response_status, {}, @response_body]
        end
      end
       do
        expected = Git::Response.new(@response_status, @response_body)
          assert_equal expected, @client.subscribe(@email, @campaign_id, @data)       
      end
    end
end

  context "#subscribe" do
    setup do
      @email = "sakonet@github.com"
      @campaign_id = "12345"
      @payload = { "subscribers" => [@data.merge(:email => @email)] }.to_json
      @response_status = 201
      @response_body = stub
      @stubs.post "12345/campaigns/#{@campaign_id}/subscribers", @payload do
        [@response_status, {}, @response_body]
      end
    end
     expected = Git::Response.new(@response_status, @response_body)
      assert_equal expected, @client.subscribe(@email, @campaign_id, @data)
    end
  end

    context "if a campaign id is provided" do
      setup do
        @id = "sakonet@github.com"
        @campaign = "12345"
        @response_status = 200
        @response_body = stub
@payload = { "subscribers" => [@data.merge(:email => @email)] }.to_json
      @stubs.post "12345/subscribers", @payload do
        [@response_status, {}, @response_body]
      end
    end
        @stubs.post "12345/subscribers/#{CGI.escape @id}/unsubscribe?campaign_id=#{@campaign}" do
          [@response_status, {}, @response_body]
        end
      end
      should "send the right request" do
        expected = Drip::Response.new(@response_status, @response_body)
        assert_equal expected, @client.unsubscribe(@id, campaign_id: @campaign)
      end
    end
  end
