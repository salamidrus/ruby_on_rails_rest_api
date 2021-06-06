# To update SKU in another server
class UpdateSkuJob < ApplicationJob
  queue_as :default

  def perform(book_name)
    uri = URI('http://localhost:4567/update_sku')
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'applciation/json')
    req.body = { sku: '123', name: book_name }.to_json
    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end
end
