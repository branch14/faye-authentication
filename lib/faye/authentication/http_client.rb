require 'json'

module Faye
  module Authentication
    class HTTPClient

      def self.publish(url, channel, data, key)
        uri = URI(url)
        req = Net::HTTP::Post.new(url)
        message = {'channel' => channel, 'clientId' => 'http'}
        message['signature'] = Faye::Authentication.sign(message, key)
        message['data'] = data
        req.set_form_data(message: JSON.dump(message))
        opts = { use_ssl: uri.scheme == 'https' }
        Net::HTTP.start(uri.hostname, uri.port, opts) do |http|
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http.request(req)
        end
      end

    end
  end
end
