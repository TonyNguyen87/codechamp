# require "pry"

require "httparty"
#6d501db98d7ebb1af926738a2198ef5811683dd6
module CodeChamp
  class Github
		include HTTParty
		base_uri "https://api.github.com"
    @username = nil

    def initialize(oauth)
   		@headers = {
       	"Authorization" => "token #{oauth}",
        "User-Agent"    => "HTTParty"
     	}
   	end

   	def get_contributions(org, repo)
      results = []
      Github.get("/repos/#{org}/#{repo}/stats/contributors", headers: @headers)
    end
      
    def retrieve_data(weeks)
      target_key = "a"
      target_value = 1

      qualified = weeks.select {|h|h.key?(target_key) && h[target_key]==target_value}
      return nil if qualified.empty?  
      qualified.each_with_object({}) {|h,g| g.merge!(h) {|k,gv,hv| k == target_key ? gv : 
                      (gv.to_i + hv.to_i).to_s}}
    end

  end
end

    # binding.pry sub method get user total loop over author give get user the weeks dig out all the login authors etc
    # response.first["weeks/author"] will get the array