require "pry"
require "httparty"

require "./github"
# require "/codechamp/version"

module CodeChamp
	class App
		def initialize
      @results = []
		end


	  	def prompt(message, regex)
   	  		puts message
   	  		choice = gets.chomp
      	until choice =~ regex
      		puts "Incorrect input. Try again."
       		puts message
       		choice = gets.chomp
    	end
     	choice
     	end

   		def connect_github
   			oauth_token = prompt("What is your OAuth Token?", 
    						/[a-z0-9]{4,50}/)
   			# token = oauth_token
   			@github = Github.new(oauth_token)
   			# binding.pry
   		end

   		def ranked_contributions
     		org_name = prompt("Which Organization are you from",
      	                  	/^[a-z0-9\-]{4,30}$/i)
     		repo_name = prompt("Which Repository would you like to pull data from?",
     						/^[a-z0-9\-]{4,30}$/i)
     		contribution_list = @github.get_contributions(org_name, repo_name)
        user1 = contribution_list.first
        get_user(user1)
      end

      def get_user(user1)
        user1_name = user1["author"]["login"]
        @results.push(user1_name)
        weeks = user1["weeks"]
        data = @github.retrieve_data(weeks)
        data.delete("w")
        @results.push(data)
        binding.pry
    	end
    end
end

codechamp = CodeChamp::App.new
codechamp.connect_github
codechamp.ranked_contributions

