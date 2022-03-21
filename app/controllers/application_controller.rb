class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    private

        def set_iex_client
            @iex_client= IEX::Api::Client.new(
                publishable_token: ENV["PUBLISHABLE_TOKEN"],
                secret_token: ENV["SECRENT_TOKEN"],
                endpoint: 'https://cloud.iexapis.com/v1'
            )
        end
end
