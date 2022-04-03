class TransactionsController < ApplicationController
    before_action :redirect_to_admin, only: %i[new new_crypto]
    before_action :authenticate_user!
    before_action :check_if_user_approved, only: %i[create]
    before_action :transaction_params, only: %i[create]
    
    def index
        @transactions = current_user.transactions
    end

    def new
        @transaction = Transaction.new
        symbol = params["symbol"] ? params["symbol"] : ""
        if SYMBOLS.include? symbol 
            @stock_data = IEX_CLIENT.quote(symbol)
        end
    end

    def new_crypto
        @transaction = Transaction.new
        crypto = Crypto.new
        @crypto_symbols = crypto.crypto_symbols

        symbol = params["symbol"] ? params["symbol"] : ""
        if @crypto_symbols.include? symbol 
            @crypto_data = crypto.quote_crypto(symbol).first
        end

        quote_all = params["all"] ? true : false
        if symbol && quote_all
            @quotes = crypto.quote_crypto_on_all_rates(symbol)
        end
    end
    def create
        begin
            if params[:method]== "Buy"
                current_user.buy_stock!(transaction_params[:volume], transaction_params[:stock])
                redirect_to transactions_url, notice: "Stock was successfully bought"
            elsif params[:method]== "Sell"
                current_user.sell_stock!(transaction_params[:volume], transaction_params[:stock])
                redirect_to transactions_url, notice: "Stock was succesfully sold"
            end
        rescue ArgumentError => e
            redirect_to transactions_url, notice: e.message
        rescue ActiveRecord::ValidationError
            redirect_to transactoins_url, notice: "Error in executing transaction. Contact admin."
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
