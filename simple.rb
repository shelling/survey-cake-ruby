require "rest-client"
require "digest"

class SurveyCake
  attr_accessor :key, :secret, :sole, :timestamp

  def initialize(key, secret, sole)
    @key, @secret, @sole, @timestamp = key, secret, sole, Time.now
  end
  
  def tmp
    @timestamp.strftime("%S%y%H%m%d%M")
  end

  def x
    tmp[0]
  end

  def y
    tmp[1]
  end

  def string1
    string1 = Digest::MD5.hexdigest(@secret + tmp)
    string1[x.to_i] = x
    string1
  end

  def string2
    string2 = Digest::MD5.hexdigest(@sole   + tmp)
    string2[y.to_i] = y
    string2
  end

  def string3
    string3 = Digest::MD5.hexdigest(@key    + tmp)
    string3[x.to_i + y.to_i] = x
    string3
  end

  def token
    Digest::MD5.hexdigest(string1 + string2 + string3)
  end

  def post(action)
    RestClient.post("https://go.surveycake.com/surveycake/3pt/mbrsvc.php", {
      key: key,
      tmp: tmp,
      unq: sole,
      act: action,
      tkn: token,
    })
  end
end

surveycake = SurveyCake.new("key", "secret", "sole")

puts surveycake.key
puts surveycake.secret
puts surveycake.sole
puts surveycake.tmp
puts surveycake.token

response = surveycake.post("login")

puts response.inspect
