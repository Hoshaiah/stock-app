class UsersController < ApplicationController
    before_action :set_iex_client, only: %i[index]
    def index
    end
end
