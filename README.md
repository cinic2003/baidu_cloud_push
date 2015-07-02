# Baidu Cloud Push

The ruby gem of baidu cloud push base on Baidu Push Rest API 3.0

## Installation

Add this line to your application's Gemfile:

    gem 'baidu_cloud_push', :git => 'git@github.com:cinic2003/baidu_cloud_push.git

And then execute:

    $ bundle


## Usage

```ruby
api_key = 'your_api_key'
secret_key = 'your_secret_key'
# Create a client
client = BaiduCloudPush::Client.new(api_key: api_key, secret_key: secret_key)

# Push messages
message = { title: 'title', description: 'desc' }
client.push_all msg: message
```
>For more examples refer to the [official doc](http://push.baidu.com/doc/restapi/restapi)

### Required params:
```ruby
def push_all msg: msg, msg_type: 1
def push_single msg: msg, channel_id: 'xxxx', msg_type: 1
def push_batch msg: msg, channel_ids: ['xxx', 'xxx', ...], msg_type: 1
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## From
Thanks [fahchen/baidu_push](https://github.com/fahchen/baidu_push.git)
