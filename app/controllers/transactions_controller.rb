class TransactionsController < ApplicationController
    before_action :transaction_params, only: %i[create]
    def index
        @transaction = Transaction.new
        stock = params["stock"] ? params["stock"] : ""
        if SYMBOLS.include? stock
            @stock_data = IEX_CLIENT.quote(stock)
        end
    end

    def create
        @transaction = current_user.transactions.build(transaction_params)
        @transaction.method = params[:method]
        if @transaction.method == "Buy"
            @transaction.price = IEX_CLIENT.quote(transaction_params[:stock]).latest_price
            if @transaction.save
                redirect_to transactions_url, notice: "Category was successfully created."
            end
        elsif transaction_params[:method] == "Sell"

        end
    end

    private

    def transaction_params
        params.require(:transaction).permit(:volume, :stock, :method)
    end
end
