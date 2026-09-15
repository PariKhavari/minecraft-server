import sys
from mcstatus import JavaServer
 
address = sys.argv[1]
server = JavaServer.lookup(address)
status = server.status()
 
print(f"Server:  {address}")
print(f"Version: {status.version.name}")
print(f"Players: {status.players.online}/{status.players.max}")