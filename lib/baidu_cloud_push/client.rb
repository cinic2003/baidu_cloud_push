module BaiduCloudPush
  class Client

    RESOURCE = {push_all: 'push/all', 
                push_single: 'push/single_device',
                push_batch: 'push/batch_device',
                create_tag: 'app/create_tag',
                del_tag: 'app/del_tag',
                add_device: 'tag/add_devices',
                del_device: 'tag/del_devices',
                device_num: 'tag/device_num',
                query_tags: 'app/query_tags',
                push_tags: 'push/tags'}

    REQUEST_METHOD = :post
    DEFAULT_OPTIONS = {
      use_ssl: false,
      api_version: '3.0'
    }
    API_HOST = "api.tuisong.baidu.com/rest/#{DEFAULT_OPTIONS[:api_version]}"
    CONF = YAML.load_file("#{Rails.root}/config/baidu.yml")[Rails.env]
    APIKEY = CONF['apikey']
    SECRET = CONF['secret']

    attr_reader :api_key, :secret_key, :resource, :api_uri, :request_method, :options 
    attr_accessor :resource

    def initialize(api_key: '', secret_key: '', options: {})
      @api_key, @secret_key = api_key.strip, secret_key.strip
      @options = DEFAULT_OPTIONS.merge options

      @request = Request.new(self)
    end

    ###################################################
    # Basic API
    #
    def self.push_single channel_id, message, msg_type = 1
      params = {msg_type: msg_type, msg: message.to_json, channel_id: channel_id}
      resource = RESOURCE[:push_single]
      api_uri = "http://#{API_HOST}/#{resource}"

      params.merge!({apikey: APIKEY, timestamp: Time.now.to_i})
      params.merge!({sign: Client.generate_sign(api_uri, params)})
      uri = URI(api_uri)
      req = Net::HTTP::Post.new(uri)
      req.set_form_data(params)
      req['Content-Type'] = "application/x-www-form-urlencoded;charset=utf-8"
      req['User-Agent'] = "BCCS_SDK/3.0 (Linux version 3.13.0-45-generic) Ruby/2.2 (Baidu Push Server SDK V3.0.0)"
      Net::HTTP.start(uri.host, uri.port){|http| http.request(req)}
    end


    def push_all message: '', msg_type: 1
      set_resource RESOURCE[:push_all]
      params = {msg_type: msg_type, msg: message.to_json} #, timestamp: Time.now.to_i, apikey: @api_key}

      @api_uri = set_api_uri
      @request.fetch params
    end

    def push_single message: '', channel_id: '', msg_type: 1
      set_resource RESOURCE[:push_single]
      params = {msg_type: msg_type, msg: message.to_json, channel_id: channel_id} #, timestamp: Time.now.to_i}
      @api_uri = set_api_uri
      @request.fetch params
    end

    def push_batch message: '', channel_ids: [], msg_type: 1
      set_resource RESOURCE[:push_batch]
      params = {msg_type: msg_type, msg: message.to_json, channel_ids: channel_ids.to_json}
      @api_uri = set_api_uri
      @request.fetch params
    end

    def push_tags type: 1, tag: '', message: ''
      set_resource RESOURCE[:push_tags]
      params = {type: type, msg: message.to_json, tag: tag}
      @api_uri = set_api_uri
      @request.fetch params
    end

    def create_tag tag: ''
      set_resource RESOURCE[:create_tag]
      params = {tag: tag}
      @api_uri = set_api_uri
      @request.fetch params
    end

    def del_tag tag: ''
      set_resource RESOURCE[:del_tag]
      params = {tag: tag}
      @api_uri = set_api_uri
      @request.fetch params
    end

    def add_device tag: '', channel_ids: []
      set_resource RESOURCE[:add_device]
      params = {tag: tag, channel_ids: channel_ids}
      @api_uri = set_api_uri
      @request.fetch params
    end

    def del_device tag: '', channel_ids: []
      set_resource RESOURCE[:del_device]
      params = {tag: tag, channel_ids: channel_ids}
      @api_uri = set_api_uri
      @request.fetch params
    end

    def device_num tag: ''
      set_resource RESOURCE[:device_num]
      params = {tag: tag}
      @api_uri = set_api_uri
      @request.fetch params
    end

    def query_tags tag: nil
      set_resource RESOURCE[:query_tags]
      params = tag.nil? ? {} : {tag: tag}
      @api_uri = set_api_uri
      @request.fetch params
    end

    private

    def self.generate_sign api_uri, params
      params_str = params.sort.map{ |p| p.join('=') }.join
      base_str = "#{REQUEST_METHOD.to_s.upcase}#{api_uri}#{params_str}#{SECRET}"
      Digest::MD5.hexdigest(URI::encode_www_form_component(base_str))
    end

    def set_api_uri
      @request_method = REQUEST_METHOD
      scheme = @options[:use_ssl] ? 'https' : 'http'
      @api_uri = "#{scheme}://#{API_HOST}/#{@resource}"
    end

    def set_resource resource
      @resource = resource
    end
  end
end
