class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :transactions, :dependent => :destroy
  has_many :stocks, :dependent => :destroy

  def buy_stock!(volume, stock)
    symbol = stock
    volume = volume.to_i
    stock = self.stocks.find_by symbol: symbol
    transaction = transactions.build(
      volume:volume,
      stock: symbol,
      method: "Buy",
      price: IEX_CLIENT.quote(symbol).latest_price
    )
    if stock
      stock.volume += volume
      stock.average_price = (stock.average_price * stock.volume + transaction.price * transaction.volume) / (stock.volume + transaction.volume)
    else
      stock = stocks.build(symbol: transaction.stock, average_price: transaction.price, volume: transaction.volume)
    end

    ActiveRecord::Base.transaction do
      transaction.save!
      stock.save!
    end
  end

  def sell_stock!(volume, stock)
    symbol = stock
    volume = volume.to_i
    stock = self.stocks.find_by symbol: symbol
    transaction = transactions.build(
      volume:volume,
      stock: symbol,
      method: "Sell",
      price: IEX_CLIENT.quote(symbol).latest_price
    )
    if stock
      if stock.volume >= volume
        stock.volume -= transaction.volume
        ActiveRecord::Base.transaction do
          transaction.save!
          if stock.volume == 0
            stock.destroy
          else
            stock.save!
          end
        end
      else
        raise ArgumentError.new("You do not own enough shares of this stock")
      end
    else
      raise ArgumentError.new("You do not own shares of this stock")
    end
  end
end
