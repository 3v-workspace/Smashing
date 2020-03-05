# zendesk configure
# ==================================================

$ZENDEK_TOKEN = "*********************************" # zendesk API token

$ZENDEK_ORGNAME = "*************" # zendesk orgname (https://<zendesk_orgname>.zendesk.com/api/v2)
    
$ZENDEK_USERNAME = "***************" # zendesk username (email address)
 
# zoho configure
# ==================================================

$GET_ZOHO_TOKEN = {
        "refresh_token"=>"***********************************************",
        "client_id"=>"**********************************************",
        "client_secret"=>"************************************************",
        "scope"=>"Desk.tickets.READ,Desk.basic.READ,Desk.settings.READ",
        "grant_type"=>"refresh_token"
    } # zoho API temporary token

$ZOHO_ORGID = "*************" # zoho organization ID

# syncroMSP configure 
# ==================================================

$SYN_API_KEY = "*******************************" # syncroMSP API token

$SYN_ORGNAME = "*********" # syncroMSP orgname (https://<orgname>.syncromsp.com/api/v1/users?api_key=)
