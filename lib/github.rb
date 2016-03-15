# require "pry"

require "httparty"
#3e1d673d21d7e965a9b1fe3ca55b024f8525e83b
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
      Github.get("/repos/#{org}/#{repo}/stats/contributors", headers: @headers)
    end
      
    def retrieve_total(weeks, key)
      result = 0
      weeks.each do |week|
        result += week[key]
      end
      result
    end

    # def retrieve_total(weeks, key)
    #   weeks.map {|week| week[key] }.inject(:+)
    # end

    # additions = retrieve_total(weeks, "a")
    # deletions = retrieve_total(weeks, "d")
    # puts "Additions: #{additions}, Deletions: #{deletions}"

    # def retrieve_data(weeks)
    #   results = []
    #   total_a = []
    #   total_d = []
    #   total_c = []

    #   weeks.each do |week|
    #     total_a << week["a"]
    #     total_d << week["d"]
    #     total_c << week["c"]
    #     end
    #   total_a = total_a.inject(:+)
    #   total_d = total_d.inject(:+)
    #   total_c = total_c.inject(:+)
    #   results.push("Additions: #{total_a}", "Deletions: #{total_d}", "Commits: #{total_d}")
    #   results
    #   # binding.pry
    # end
  end
end

    # binding.pry sub method get user total loop over author give get user the weeks dig out all the login authors etc
    # response.first["weeks/author"] will get the array