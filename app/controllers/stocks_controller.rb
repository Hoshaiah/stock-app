class StocksController < ApplicationController
    def index
        @stocks = current_user.stocks.all
    end
end
