@return_code ||= 0
json.server_time Time.now.to_i
json.return_code @return_code
json.message @message