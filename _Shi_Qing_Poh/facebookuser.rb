#####################################################################
# Simplified Facebook interactions/navigation via Ruby/Mechanize.   #
#   Author: Robbie Harjes                                           #
#     Date: 6/8/2011                                                #
#    Notes: Not liable for misuse; free for non-commercial projects.#
#           This notice must remain intact if you use this code.    #
#####################################################################
 
 email = 'pohshiqing@gmail.com'
 password = 'S8502674gmouser'
require 'rubygems'
require 'mechanize'
 
class FbConsole
 
  attr_reader :agent, :username
  
  # Constructs a new FbConsole instance.
  #   PRECONDITIONS: (none)
  #   POSTCONDITION: Agent is at URL http://m.facebook.com.
  #    RETURN VALUE: The FbConsole instance.
  #-------------------------------------------------------------
  def initialize
    @agent = Mechanize.new
    @agent.follow_meta_refresh = true
    @agent.get('http://m.facebook.com')
    @logged_in = false
    @errors = []
  end
  
  # Logs a user into Facebook.
  #   PRECONDITIONS: Agent is at URL http://m.facebook.com.
  #   POSTCONDITION: Agent is 'Home'.
  #    RETURN VALUE: True if successful, false otherwise.
  #-------------------------------------------------------------
  def login(email, password)
    if !@logged_in
      form = @agent.page.form_with(:method => 'POST')
      form.email = email
      form.pass = password
      @agent.submit(form)
      @logged_in = !@agent.page.uri.to_s.match('home.php').nil? or !@agent.page.uri.to_s.match('checkpoint').nil?
      
      name = @agent.page.search("#footer/div[@class='acw apm']/span").text.strip
      #@username = name.scan(/\((.*?)\)/).first.first
    end
    logged_in?
    puts 'log in successful'
  end
  
  # Logs a user out of Facebook.
  #   PRECONDITIONS: (none)
  #   POSTCONDITION: Logged out.
  #    RETURN VALUE: True if successful, false otherwise.
  #-------------------------------------------------------------
  def logout
    if logged_in?
      @agent.page.link_with(:text => /Logout/).click
      @logged_in = !@agent.page.uri.to_s.match('home.php').nil?
    end
    !logged_in?
  end
  
  # Updates the currently logged in user's status.
  #   PRECONDITIONS: Agent is 'Home'.
  #   POSTCONDITION: Agent is 'Home'.
  #    RETURN VALUE: True if successful, false otherwise.
  #-------------------------------------------------------------
  def update_status(string)
    if logged_in?
      form = @agent.page.form_with(:method => 'POST')
      form.status = string
      @agent.submit(form)
      return true
    end
    false
  end
  
  # Get a user's feed, sorted by "Most Recent" (default), or "Top News".
  #   PRECONDITIONS: Agent is 'Home'.
  #   POSTCONDITION: Agent is 'Home'.
  #    RETURN VALUE: An array of feed item hashes (keys = :name, :content, :timestamp), or false.
  #-------------------------------------------------------------
  def feed_items(most_recent = true)
    if logged_in?
      
      # Configure sorting method
      if most_recent && @agent.page.link_with(:text => 'Most Recent')
        @agent.page.link_with(:text => 'Most Recent').click
      elsif !most_recent && @agent.page.link_with(:text => 'Top News')
        @agent.page.link_with(:text => 'Top News').click
      end
      
      # Scrape the feed items
      feed_items = []
      @agent.page.search("#m_stream_stories/div").each_with_index do |item, index|
        name = item.search("a/strong").text.strip
        content = item.search("span").text.strip
        timestamp = item.search("div/abbr").text.strip
        feed_item = {:name => name, :content => content, :timestamp => timestamp}
        feed_items[index] = feed_item
      end      
      return feed_items
    end
    false
  end
  
  # Get a user's active notifications.
  #   PRECONDITIONS: (none)
  #   POSTCONDITION: Agent returns to original (initial) location.
  #    RETURN VALUE: An array of notification strings, or false.
  #-------------------------------------------------------------
  def notifications
    if logged_in?
      self.Home
      notifications = []
      @agent.page.search("#__m_notifications__/div").each do |notification|
        notifications << notification.text.strip
      end
      @agent.history.pop
      return notifications
    end
    false
  end
  
  # Sends a message to another user.
  #   PRECONDITIONS: Agent has navigated to the friend's profile.
  #   POSTCONDITION: Agent is on friend's profile.
  #    RETURN VALUE: True if successful, false otherwise.
  #-------------------------------------------------------------
  def send_message(string)
    if logged_in?
      form = @agent.page.form_with(:action => '/messages/compose/')
      if form.nil?
        @errors << "Couldn't find the 'Message' button. Are you sure you chained the 'Friends(friend_name)' method first?"
        return false
      end
      @agent.submit(form)
      form = @agent.page.form_with(:method => 'POST')
      if form.nil?
        @errors << "Couldn't resolve the message body."
        @agent.history.pop
        return false
      end
      form.body = string
      @agent.submit(form, form.buttons.first)
      return true
    end
    false
  end
  
  # Posts a comment on a friend's wall.
  #   PRECONDITIONS: Agent has navigated to the friend's profile.
  #   POSTCONDITION: Agent is on friend's profile.
  #    RETURN VALUE: True if successful, false otherwise.
  #-------------------------------------------------------------
  def post_on_wall(string)
    if logged_in?
      form = @agent.page.form_with(:method => 'POST')
      if form.nil?
        @errors << "Couldn't find the form to post comment."
        return false
      end
      form.message = string
      @agent.submit(form)
      return true
    end
    false
  end
  
  # Tests whether you are logged in or not.
  #   PRECONDITIONS: (none)
  #   POSTCONDITION: (none)
  #    RETURN VALUE: True if logged in, false otherwise.
  #-------------------------------------------------------------
  def logged_in?
    if @logged_in
      return true
    else
      @errors = "You are not logged in."
      false
    end
  end
  
  # Get a list of any active errors.
  #   PRECONDITIONS: (none)
  #   POSTCONDITION: Any errors are cleared.
  #    RETURN VALUE: An array of error strings.
  #-------------------------------------------------------------
  def errors?
    ret_errors = @errors
    @errors = []
    ret_errors
  end
  
  # Navigates to 'Home' (your Facebook dashboard)
  #   PRECONDITIONS: (none)
  #   POSTCONDITION: Agent is 'Home'.
  #    RETURN VALUE: True if successful, false otherwise.
  #-------------------------------------------------------------
  def Home
    if logged_in?
      @agent.page.links[0].click
      if @agent.page.title == 'Facebook'
        return true
      end
      @errors << "Couldn't access the Facebook homepage."
      @agent.history.pop
    end
    false
  end
  
  # Navigates to 'Profile' (your Facebook profile)
  #   PRECONDITIONS: (none)
  #   POSTCONDITION: Agent is on your Profile page.
  #    RETURN VALUE: True if successful, false otherwise.
  #-------------------------------------------------------------
  def Profile
    if logged_in?
      @agent.page.link_with(:text => 'Profile').click
      if @agent.page.title == @username
        return true
      end
      @errors << "Couldn't access your Profile."
      @agent.history.pop
    end
    false
  end
  
  # Navigates to 'Friends' 
  #   PRECONDITIONS: (none)
  #   POSTCONDITION: Agent is on the 'Friends' tab, or (if optionally
  #                  specified), a given friend's profile page.
  #    RETURN VALUE: self if friend was found, true if successful, false otherwise.
  #-------------------------------------------------------------
  def Friends(friend_name = nil)
    @agent.page.link_with(:text => 'Friends').click
    
    if @agent.page.title != "Friends"
      @errors << "Couldn't access the 'Friends' page."
      @agent.history.pop
    elsif !friend_name.nil?
      # Find the given friend
      form = @agent.page.form_with(:method => 'GET')
      form.q = friend_name
      @agent.submit(form)
      
      # Click the first result (leap of faith)
      if !@agent.page.search("div[@class='c']/a").empty?
        friend_name_qualified = @agent.page.search("div[@class='c']/a").first.text.to_s
        @agent.page.link_with(:text => friend_name_qualified).click
        if @agent.page.title != friend_name_qualified
          @errors << "Couldn't access #{friend_name_qualified}'s Profile."
          @agent.history.pop
          return false
        end
        return self
      else
        @errors << "No friends matching query '#{friend_name}'."
        @agent.history.pop
      end
    end   
    @errors.count == 0
  end
  
  # Navigates to 'Messages' (your Facebook messages)
  #   PRECONDITIONS: (none)
  #   POSTCONDITION: Agent is on 'Messages' tab.
  #    RETURN VALUE: True if successful, false otherwise.
  #                  Note:  m.facebook.com/messages is broken right now
  #-------------------------------------------------------------
  def Messages
    if logged_in?
      @agent.page.links[5].click
      if @agent.page.title == 'Messages'
        return true
      end      
      @errors << "Couldn't access the Messages page."
      @agent.history.pop
    end
    false
  end
  
end


user = FbConsole.new()
user.login('pohshiqing@gmail.com','S8502674gmouser')
user.update_status('Testing posting from Ruby')
#################
#FACEBOOK

gem install "koala"
gem install 'rubygems'
gem install 'mechanize'
#Access Token: CAACEdEose0cBAG182ZArLhr4cy15rRhICjCfKKs8XdaMjyzmqq5RqMqm14ZBsHgDTm0YP1yPN8CoYOyABzyprjUvNP58QKp8u2bvhNDB5rxChS4kVYGmevlADAe2HCZBSkvsieS5lZACm2GAJMuRDOwYLIkL6W0iTq05QoZA1KZAHVEZBGU29V2zfYMa1BD818kD3vB0HF8LwZDZD
require 'koala'
require 'rubygems'

#https://developers.facebook.com/tools/explorer?method=GET&path=me%3Ffields%3Did%2Cname
access_token = 'CAACEdEose0cBAOzcZCZAupbqNbb0F2uVNnxIgwnQMczUvmmQXAAaZAdxwLMyu5g0PBLWmgcvmjZAdgJ7WNxvAXzK3ctid3YbOQjDgmgohnG0NSVx5ZBugUWO5PIgxHyAyFrMdPAbgYoQcRuwSxsiVR5IKq1NZABixxn8urx13er6Er1WyGXJ0eHU7Q2WdytnETl4NZCnKU6OQZDZD'

graph = Koala::Facebook::API.new(access_token)
profile = graph.get_object("me")
friends = graph.get_connection("me","friends")
feed = graph.get_connection("me","feed")
home = graph.get_connection("me","home")



############ How to get all posts from facebook user news feed for specific day

@feed = Koala::Facebook::API.new(current_user.token)
to = Time.now.to_i
yest = 1.day.ago.to_i
@feed.fql_query("SELECT post_id, actor_id, target_id, message, likes FROM stream WHERE source_id = me() AND created_time > #{yest} AND created_time < #{to} AND type = 80
AND strpos(attachment.href, "youtu") >= 0")
       
require 'koala'
@graph = Koala::Facebook::API.new(access_token)
@graph.fql_query("SELECT post_id, actor_id, target_id, message FROM stream WHERE source_id = me() AND created_time > START_TIME AND created_time < END_TIME LIMIT 10")

