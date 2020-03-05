require 'zendesk_api'
require_relative 'config.rb'
require 'hashie'
require 'hashie/logger'

Hashie.logger = Logger.new(nil) # for no log warnings

client = ZendeskAPI::Client.new do |config| # zendesk api request
  config.url = "https://" + $ZENDEK_ORGNAME + ".zendesk.com/api/v2" # from config.rb
  config.username = $ZENDEK_USERNAME # from config.rb
  config.token = $ZENDEK_TOKEN # from config.rb
  config.retry = true
end

SCHEDULER.every '10m', :first_in => 0 do |job| # planning event for send data to smashing view module 

tickets = client.tickets # api request results
users = client.users

utc = {} # create associated array, where each index is equal value of tickets.user_id field

tickets.all do |tick|
  if utc[tick.requester_id.to_s] != nil # calculate amount of tickets, associated with each user

    utc[tick.requester_id.to_s] += 1
  else utc[tick.requester_id.to_s] = 1
  end
end

users_final = {} # create array, contains all users, included users without tickets and put objects, contains label (user name) and value (count of tickets) for send to smashing view module

n = 0 # array counter
users.all do |us|
  
  value = 0 # tickets count preset

  if utc[us.id.to_s] != nil
    value = utc[us.id.to_s]
  end

  users_final[n] = {label: us.name, value: value}
  n +=1

end

send_event('zend', { items: users_final.values}) # send data to smashing view module (by /widgets/list.html template) to html element named 'zend'

end # ---------------- end of sheduler

