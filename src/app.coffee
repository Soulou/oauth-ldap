ldap = require 'ldapjs'
http = require 'http'

authenticate = (username, password, path, callback) ->
  http.get
    host: 'localhost'
    port: 3000
    auth: "#{username}:#{password}"
    path: path
    headers:
      Accept: 'application/json'
    (res) ->
      res.on 'data', (chunk) ->
        data = JSON.parse(chunk.toString('utf-8'))
        callback(data)

# GLOBALS
basedn= 'dc=ares'

server = ldap.createServer()


server.bind 'dc=ares', (req, res, next) ->
  if (!req.connection.ldap.bindDN.equals('cn=pam_ldap, dc=ares'))
    return next(new ldap.InsufficientAccessRightsError())
  next()


test_response =
  dn: 'cn=root, dc=ares'
  attributes: 
    name: 'toto'
    objectclass: 'unixUser'

server.search 'dc=ares', (req, res, next) ->
  authenticate 'chobert2010', 'toto123', '/users/self', (data) ->
    res.send
      dn: 'cn=root, dc=ares'
      attributes: data
    res.end()
  return next()




server.listen 1389, ->
  console.log 'LDAP server up at: %s', server.url

