http = require('http')

http.get
  host: 'localhost'
  port: 3000
  auth: 'chobert2010:toto123'
  path: '/users/self'
  headers:
    Accept: 'application/json'
  (res) ->
    res.on 'data', (chunk) ->
      console.log JSON.parse(chunk.toString('utf-8'))
