IEX_CLIENT= IEX::Api::Client.new(
  publishable_token: ENV["PUBLISHABLE_TOKEN"],
  secret_token: ENV["SECRENT_TOKEN"],
  endpoint: 'https://cloud.iexapis.com/v1'
)
SYMBOL = IEX_CLIENT.ref_data_symbols()

SYMBOLS = []

SYMBOL.each do |x|
  SYMBOLS.push(x.symbol)
end