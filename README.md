# Smashing
![Website Screenshot](https://github.com/3v-workspace/Smashing/blob/master/Screenshot%20from%202020-03-05%2014-37-03.png)

To add widgets to existing dashboard/Smashing

It is expected that Smashing has already been installed. If not https://github.com/Smashing/smashing/wiki/How-to:-Install-Smashing-on-Ubuntu-or-Debian.

1. Add line:

gem 'zendesk_api', '~> 1.4.3'

into the Gemfile.

2. Files .rb from jobs/ copy to jobs/ in the Smashing directory.
2.1 Configure config.rb file (see below).
3. Add following lines to your dashboard (.erb file):

<div class="gridster">
  <ul>

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="2" >
      <div class="zendesk" data-id="zend" data-view="List" data-unordered="true" data-title="Zendesk" data-moreinfo="Zendesk users and tickets count list"></div>
    </li>

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="2" >
      <div class="zoho" data-id="zoho" data-view="List" data-unordered="true" data-title="Zoho" data-moreinfo="Zoho users and tickets count list"></div>
    </li>

     <li data-row="1" data-col="1" data-sizex="1" data-sizey="2" >
      <div class="syncro" data-id="syncro" data-view="List" data-unordered="true" data-title="SyncroMSP" data-moreinfo="SyncroMSP users and tickets count list"></div>
    </li>
    
  </ul>
</div>

or copy dashboards/sample.erb file to your Smashing.
4. Run:

$ bundle install

in command line from Smashing directory;
run:

$ smashing start

5. Widgets will appear at localhost:3030/sample

To install dashboard with new Smashing

1. Unpack .zip file to You_Project folder and run command line from it.
1.1 Configure config.rb file (see below)
2. Install Ruby and NodeJS:

$ sudo apt-get update
$ sudo apt-get install ruby ruby-dev build-essential nodejs

3. Install required gems:

$ sudo gem install smashing bundler

4. Install the bundle of project specific gems:

$ bundle install

5. Start dashboard:

$ smashing start

6. Dashboard will appear at localhost:3030/sample

Configure config.rb file

You may have working accounts on Zoho, ZenDeck and SyncroMSP or at least one of it with active users/agents and some tickets assigned to a specific user.

Fill filds in "" instead * with:
1. For Zendeck:
- zendesk orgname (https://<zendesk_orgname>.zendesk.com/api/v2);
- zendesk username (email address).
- zendesk API token.

2. For Zoho:
- Zoho organization ID;
- API temporary token:
	- "refresh_token";
	- "client_id";
	- "client_secret".

3. For SyncroMSP:
- syncroMSP orgname (https://<orgname>.syncromsp.com/api/v1/users?api_key=);
- syncroMSP API token.
