Key                 ApiEndpoint                                                                                                               
Description         Base URL for the HTTP API                                                                                                 
Value               https://dtrc11ett0.execute-api.us-east-1.amazonaws.com

# 1) By ID (replace with the id you just got back)
curl -s 'https://dtrc11ett0.execute-api.us-east-1.amazonaws.com/persons/PER_01K9GDHAYS1HSWGHDY34Z37M6P'

# 2) By email (GSI1)
curl -sG 'https://dtrc11ett0.execute-api.us-east-1.amazonaws.com/persons' \
  --data-urlencode 'email=robbie@example.com'