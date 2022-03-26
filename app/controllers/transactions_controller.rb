class TransactionsController < ApplicationController
    before_action :redirect_to_admin, only: %i[new]
    before_action :authenticate_user!
    before_action :check_if_user_approved, only: %i[create]
    before_action :transaction_params, only: %i[create]
    
    def index
        @transactions = current_user.transactions
    end

    def new
        @transaction = Transaction.new
        stock = params["stock"] ? params["stock"] : ""
        if SYMBOLS.include? stock
            @stock_data = IEX_CLIENT.quote(stock)
        end
    end

    def create
        @stock = current_user.stocks.find_by symbol: transaction_params[:stock]
        @transaction = current_user.transactions.build(transaction_params)
        @transaction.method = params[:method]
        transaction_price = transaction_params[:price].to_f
        transaction_volume = transaction_params[:volume].to_i

        if @transaction.method == "Buy"
            @transaction.price = IEX_CLIENT.quote(transaction_params[:stock]).latest_price
            if @stock
                @stock.volume += transaction_volume
                @stock.average_price = (@stock.average_price * @stock.volume + transaction_price * transaction_volume) / (@stock.volume + transaction_volume))
            else
                @stock = current_user.stocks.build(symbol: transaction_params[:stock], average_price: @transaction.price, volume: transaction_volume) 
            end
            
            ActiveRecord::Base.transaction do
                if @transaction.save && @stock.save
                    redirect_to transactions_url, notice: "Category was successfully created."
                end
            end
        elsif @transaction.method == "Sell"
            if @stock
                if @stock.volume >= transaction_volume
                    @transaction.price = IEX_CLIENT.quote(transaction_params[:stock]).latest_price
                    @stock.volume -= transaction_volume
                    ActiveRecord::Base.transaction do
                        if @transaction.save && @stock.save
                            redirect_to transactions_url, notice: "Stocks were successfully sold."
                        end  
                    end
                else
                    redirect_to transactions_url, notice: "You do not own enough shares of this stock."
                end
            else
                redirect_to transactions_url, notice: "You do not own any shares of this stock."
            end
        end
    end

    private

    def transaction_params
        params.require(:transaction).permit(:volume, :stock, :method)
    end

    def redirect_to_admin
        if admin_signed_in?
            redirect_to admin_home_url
        end
    end

    def check_if_user_approved
        if current_user.approved != true
            redirect_to home_path, notice: "User must be approved to make transactions"
        end
    end
end
