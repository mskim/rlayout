module RLayout
  module Commands
    module Auth
      extend self

      def login(email, password)
        require "softcover/client"
        client = RLayout::Client.new email, password
        client.login!
      end

      def logout
        require "softcover/config"
        RLayout::Config['api_key'] = nil
      end
    end
  end
end
