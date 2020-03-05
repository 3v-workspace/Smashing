
require 'json'
require 'open-uri'
require 'net/http'
require_relative 'config.rb'

#Repeating for requests, getting & sending data to dashboard
SCHEDULER.every '10m', :first_in => 0 do           
  
  # Request & getting list of users from syncromsp
  uurl = URI.parse('https://' + $SYN_ORGNAME +'.syncromsp.com/api/v1/users?api_key='+ $SYN_API_KEY)
  ureq = Net::HTTP::Get.new(uurl.to_s)
  ures = Net::HTTP.start(uurl.host, uurl.port, :use_ssl => uurl.scheme == 'https') {|http| http.request(ureq)}
  
  uparsed  = JSON.parse(ures.body) #Parsing gotten data for users to an object
  
  # Request & getting list of tickets from syncromsp
  turl = URI.parse('https://' + $SYN_ORGNAME +'.syncromsp.com/api/v1/tickets?api_key='+ $SYN_API_KEY)
  treq = Net::HTTP::Get.new(turl.to_s)
  tres = Net::HTTP.start(turl.host, turl.port, :use_ssl => turl.scheme == 'https') {|http| http.request(treq)}
  
  tparsed = JSON.parse(tres.body) #Parsing gotten data for tickets to an object
  
  utc = {} #Creating empty array for count tickets assigned to users
  users_final = {} #Creating empty array for all users 
  
  #Counting tickets & filling utc array
  tparsed["tickets"].each do |tick|
    if utc[tick["user_id"]] != nil
      utc[tick["user_id"]] += 1
    else    
      utc[tick["user_id"]] = 1
    end
  end
  
  #Assigning counts of tickets to users & adding "non-tickets" users in users_final array
  n = 0
  uparsed["users"].each do |user|
    val = 0
    if utc[user[0]] != nil
      val = utc[user[0]]
    end
    users_final[n] = {label: user[1], value: val}
    n = n+1
  end
  send_event('syncro', { items: users_final.values }) #Sending data to dashboard
end