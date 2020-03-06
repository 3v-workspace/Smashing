require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require_relative 'config.rb'

key = '' # temporary key for zoho API

# get zoho temporary token from zoho API Token actuality during 1 hour maximum.
SCHEDULER.every '59m', :blocking => true, :first_in => 0 do
    url = "https://accounts.zoho.eu/oauth/v2/token" 
    uri = URI.parse(url)
    parameters =  $GET_ZOHO_TOKEN
    response = Net::HTTP.post_form(uri, parameters)
    response = JSON.parse(response.body)

    key = response["access_token"] # temporary key

end

SCHEDULER.every '10m', :first_in => 0 do
    # get tickets list from zoho API
    uri = URI("https://desk.zoho.eu/api/v1/tickets?include=contacts,assignee,departments,team,isRead")
    req = Net::HTTP::Get.new(uri)
    req['orgId'] = $ZOHO_ORGID
    req['Authorization'] = "Zoho-oauthtoken "+ key # use temporary token
    tickets= Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http| http.request(req)}

    #get users list from zoho API
    uri = URI("https://desk.zoho.eu/api/v1/agents")
    req = Net::HTTP::Get.new(uri)
    req['orgId'] = $ZOHO_ORGID
    req['Authorization'] = "Zoho-oauthtoken "+ key
    agents = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http| http.request(req)}

    # create associate array, contains tickets count for each user {'aseegne id'=>ticket.count}
    tickets_count_hash = JSON.parse(tickets.body)["data"]
    .group_by { |ticket| ticket["assigneeId"] }
    .map { |assigneeId, tickets| [ assigneeId, tickets.count ] }
    .to_h

    users = JSON.parse(agents.body)["data"]
    users_final = {} # create array, contains all users, included users without tickets and put objects, contains label (user name) and value (count of tickets) for send to smashing view module

    n = 0 # array counter
    users.each do |us|

        value = 0 # tickets count preset

        if tickets_count_hash[us["id"]] != nil
            value = tickets_count_hash[us["id"]]
        end

        users_final[n] = {label: us["name"], value: value}
        n +=1

    end

    send_event('zoho', { items: users_final.values}) # send data to smashing view module (by /widgets/list.html template) to html element named 'zend'

end # scheduler


