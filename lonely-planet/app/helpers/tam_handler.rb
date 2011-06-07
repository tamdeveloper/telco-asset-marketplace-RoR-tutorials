class TamHandler
  TYPES = Set.new ["eat", "sleep", "see", "shop", "night", "do"]
  
  HELP  = 'Type LonelyPlanet in your message, ' <<
          'if you want to narrow down by category ' <<
          'then type also one of the following: ' <<
          'eat, sleep, see, shop, night, do'
          
  def receive_sms(from_user, to_app, body)
    words = body.split
    # the first word is the keyword
    # the second word is the type of search
    if words.size > 1
      type = words[1].downcase
    else
      type = ''
    end
    
    if type == 'help'
      TAM::API.send_sms(to_app, from_user, HELP)
    else
      coords = TAM::API.getcoord(from_user)['body']
      response = get_lp_pois(coords['longitude'], coords['latitude'], type)
      TAM::API.send_sms(to_app, from_user, response)
    end
  end
  
  def get_lp_pois(longitude, latitude, type)
    apigateway_url = "http://apigateway.lonelyplanet.com"

    consumer_key = "your consumer key"
    consumer_secret = "your consumer secret"

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, :site => apigateway_url)

    access_token = OAuth::AccessToken.new(consumer)

    north = latitude  + 0.05
    south = latitude  - 0.05
    east  = longitude - 0.05
    west  = longitude + 0.05
    url = "/api/bounding_boxes/#{north},#{south},#{east},#{west}/pois"
    
    if TYPES.include? type
      url << "?poi_type=#{type}"
    end
    
    xml_response = access_token.get(url).body
    doc, pois = Hpricot::XML(xml_response), []

    response = (doc/:poi/:name).collect {|poi_name| poi_name.innerText}.to_sentence(:last_word_connector => ' and ')
    if response == ''
      'LonelyPlanet could not find any recommendations in your area'
    else
      'LonelyPlanet recommends: ' << response
    end
  end
end
