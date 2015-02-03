require 'webrick'
require 'json'

comments = react_version =
	JSON.parse File.read('src/comments.json')

puts 'Server started: http://localhost:3000/'

root = File.expand_path './src'
server = WEBrick::HTTPServer.new Port: 3000, DocumentRoot: root

server.mount_proc '/comments.json' do |req, res|
	if req.request_method == 'POST'
		comments << req.query
		File.write('src/comments.json', comments.to_json)
	end

	res['Content-Type'] = 'application/json'
	res.body = comments.to_json
end

trap 'INT' do server.shutdown end

server.start