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
        rescue ActiveRecord::Validations
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
