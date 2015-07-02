require 'open-uri'
require 'digest'

module BaiduCloudPush
  class Request

    attr_reader :client

    def initialize(client)
      @client = client

      #set_base_uri
    end

    def fetch params = {}
      params.merge!({apikey: @client.api_key, timestamp: Time.now.to_i})
      params.merge!({sign: generate_sign(params)})
      uri = URI(@client.api_uri)
      req = Net::HTTP::Post.new(uri)
      req.set_form_data(params)
      req['Content-Type'] = "application/x-www-form-urlencoded;charset=utf-8"
      req['User-Agent'] = "BCCS_SDK/3.0 (Linux version 3.13.0-45-generic) Ruby/2.2 (Baidu Push Server SDK V3.0.0)"
      Net::HTTP.start(uri.host, uri.port){|http| http.request(req)}
    end

    def generate_sign params = {}
      params_str = params.sort.map{ |p| p.join('=') }.join
      base_str = "#{@client.request_method.to_s.upcase}#{@client.api_uri}#{params_str}#{@client.secret_key}"
      Digest::MD5.hexdigest(URI::encode_www_form_component(base_str))
    end

    private
    def set_base_uri
      self.class.base_uri "#{@client.api_url}"
    end

  end
end
