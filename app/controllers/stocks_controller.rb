class StocksController < ApplicationController
    def index
        @stocks = current_user.stocks.all
    end

    def create
        @stock = current_user.stocks.build(symbol: transaction_params[:stock], average_price: transaction_params[:price], volume: transaction_params[:volume])

        if @stock.save
            redirect_to stocks_url, notice: "Stock was added to your portfolio"
        end
    end


    def update
        @stock = current_user.stocks.where symbol:transaction_params[:stock]
        
        if params[:method] == "Buy"
            @stock.volume += transaction_params[:volume]
            @stock.average_price = (@stock.average_price * @stock.volume + transaction_params[:price] * transaction_params[:volume]) / @stock.volume + transaction_params[:volume]
        elsif params[:method] == "Sell"
            @stock.volume -= transaction_params[:volume]
        end

    end
end
