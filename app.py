from mcstatus import JavaServer
server = JavaServer.lookup("localhost:8888")
status = server.status()
print(status.version.name, status.players.online)