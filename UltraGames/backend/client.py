import json
import socket

HOST = '127.0.0.1'
PORT = 6666
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    while True:
        try:
            
            task = "ticroom"
            key = "12"
            #login = input()
            #password = input()

            login = "man"
            password = "123"
            
            data = {
                "task" : task,
                "request": {
                    "key" : key
                }
            }

            print(data)
            message = json.dumps(data)
            s.sendall(bytes(message, encoding="utf-8"))
            
            data = json.loads(s.recv(1024).decode('utf8'))
            print(data)
            input()



        except Exception as e:
            print(e)
            s.close()