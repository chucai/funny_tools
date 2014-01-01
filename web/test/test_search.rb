require 'elasticsearch'

client = Elasticsearch::Client.new log: true

client.transport.reload_connections!

client.cluster.health

client.search q: 'test'
