class TransactionsController < ApplicationController
    def index
        @transaction = Transaction.new
        @stock_data = params["stock"] ? params["stock"] : ""
    end
end
