class TamHandler
  def receive_sms(from_user, to_app, body)
    file = File.open("db/received_sms.txt", "w+")
    file.puts(body)
    file.close
  
    TAM::API.send_sms(to_app, from_user, 'we got your message: ' + body)
  end

  def self.received_sms
    if File.exists?("db/received_sms.txt")
      file = File.open("db/received_sms.txt", "r")
      sms = file.readline
      file.close
      sms
    end
  end
end
