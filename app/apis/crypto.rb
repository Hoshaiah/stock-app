class Crypto
    def crypto_symbols
        response_body = request(
            http_method: :get,
            endpoint: "/v1/assets"
        )
        symbols = []
        response_body.each do |entry|
            if entry["type_is_crypto"] == 1
                symbols.push(entry["asset_id"])
            end
        end
        symbols
    end

    def quote_crypto(symbol)
        request(
            http_method: :get, 
            endpoint: '/v1/assets/' + symbol
        )
    end

    def quote_crypto_on_all_rates(symbol)
        response_body = request(
            http_method: :get,
            endpoint: 'v1/exchangerate/' + symbol
        )

        quotes = response_body["rates"]
        quotes
    end

    private

    def request(http_method:, endpoint:)
        response = connection.public_send(http_method, endpoint)
        gz = Zlib::GzipReader.new(StringIO.new(response.body))    
        uncompressed_string = gz.read
        JSON.parse(uncompressed_string)
    end

    def connection
        @connection ||= Faraday.new(
            url: "https://rest.coinapi.io",
            headers: {
                "X-CoinAPI-Key" => "45BF549B-2860-4AD6-A415-5EE5B5889EF8",
                "Accept-Encoding" => "deflate, gzip"
            }
        )
    end
end