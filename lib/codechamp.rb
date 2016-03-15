require "pry"
require "httparty"## do i need to require httparty here?

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
   		@github = Github.new(oauth_token)
   	end

   	def collect_contributions
      totals = []
     	org_name = prompt("Which Organization are you from",
      	                  	/^[a-z0-9\-]{4,30}$/i)
     	repo_name = prompt("Which Repository would you like to pull data from?",
     	  			            	/^[a-z0-9\-]{4,30}$/i)
     	contribution_list = @github.get_contributions(org_name, repo_name)
      contribution_list.each do |user|
        total = process_user(user)
        @results.push(total)
        end
        @results
    end

    def process_user(user)
      user_data = []
      user_name1 = user["author"]["login"]
      user_name = user_name1.capitalize
      user_data.push ("User".to_sym)
      user_data.push(user_name)
      weeks = user["weeks"]
      add = @github.retrieve_total(weeks, "a")
      del = @github.retrieve_total(weeks, "d")
      cha = @github.retrieve_total(weeks, "c")
        # data = @github.retrieve_total(weeks, "a")

      user_data.push("Additions".to_sym)
      user_data.push(add)
      user_data.push("Deletions".to_sym)
      user_data.push(del)
      user_data.push("Changes".to_sym)
      user_data.push(cha)
        # user_data.push("Additions: #{add}", "Deletions: #{del}", "Commits: #{com}")
      user_info = Hash[*user_data.flatten]
        # binding.pry
    end

    def rank_contributions
      puts
      puts "How would you like the data sorted?"
      puts "1. Sort username alphabetically."
      puts "2. User with most additions."
      puts "3. User with most deletions."
      puts "4. User with most changes."
        choice = gets.chomp.to_i
          if choice == 1               
            puts "## Contritbutions for 'owner/repo'"
            puts "----------------"
            puts "Username     Additions     Deletions    Changes"
              @results.sort_by { |x| x[:User] }.each do |result|
              puts "#{result[:User]}   #{result[:Additions]}   #{result[:Deletions]}   #{result[:Changes]}"
            end
          elsif choice == 2
            puts "## Contributions for 'owner/repo'"
            puts "----------------"
            puts "Username     Additions     Deletions    Changes"
              @results.sort_by { |x| x[:Additions]}.reverse.each do |result|
              puts "#{result[:User]}   #{result[:Additions]}   #{result[:Deletions]}   #{result[:Changes]}"
            end
          elsif choice == 3
            puts "## Contributions for 'owner/repo"
            puts "----------------"
            puts "Username     Additions     Deletions    Changes"
              @results.sort_by { |x| x[:Deletions]}.reverse.each do |result|
              puts "#{result[:User]}   #{result[:Additions]}   #{result[:Deletions]}   #{result[:Changes]}"
              end
          elsif choice == 4
            puts "## Contributions for 'owner/repo"
            puts "----------------"
            puts "Username     Additions     Deletions     Changes"
              @results.sort_by { |x| x[:Changes]}.reverse.each do |result|
              puts "#{result[:User]}   #{result[:Additions]}   #{result[:Deletions]}   #{result[:Changes]}"
              end
          else
            puts "Please choose a number between 1-4"
              choice = gets.chomp.to_i
          end
      choice
    end

    def fetch_another?
      puts "Would you like to fetch another? Y/N?"
      choice = gets.chomp.upcase
        # until ["Y", "N"].include?(choice)
        #   puts "Sorry please type Y or N."
          if choice == "Y"
            codechamp = CodeChamp::App.new
            codechamp.connect_github
            codechamp.collect_contributions
            codechamp.rank_contributions
            codechamp.fetch_another?
            # binding.pry
          else
            exit
          end
            choice
        # end                           
    end
  end
end


codechamp = CodeChamp::App.new
codechamp.connect_github
codechamp.collect_contributions
codechamp.rank_contributions
codechamp.fetch_another?






