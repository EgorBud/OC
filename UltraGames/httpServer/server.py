import socket
import json
import sqlite3 as sql
import asyncio

HOST = "0.0.0.0"
PORT = 3003

con = sql.connect("./db/users.sql")
cursor = con.cursor()


class user:
    def __init__(self):
        self.login
        self.password
    
    nickname: str
    login: str
    password: str
    toescore: str
    rpsscore: str


"""
while True:
    client_connection, client_address = server_socket.accept()

    request = client_connection.recv(1024).decode('utf-8')
    print(request)

    
    headers = request.split("\n")
    method = headers[0].split()[0]
    path = headers[0].split()[1]

    print()
    #print(headers)
    tmp = ''
    flag = False
    for i in headers:
        if flag:
            tmp += i
            print(i)
        if i == '\r':
            flag = True

    tmp = [i.replace('\r', '') for i in tmp]
    
    print("".join(tmp))
    print(method)
    print(path)

    pathNotFound = 'HTTP/1.1 404 NOT FOUND\n\n' + json.dumps({"error" : "Path Not Found"})    
    methodNotFound = 'HTTP/1.1 404 NOT FOUND\n\n' + json.dumps({"error" : "Method Not Found"})

    match path:
        case "/":
            match method:
                case "GET":
                    body = {
                        "message" : "Hello World!"
                    }
                    response = 'HTTP/1.1 200 OK\n\n' + json.dumps(body)
                case _:
                    response = methodNotFound

        case "/login":
             match method:
                case "POST":
                    #if login:
                    responseBody = json.loads("".join(tmp))
                    print(responseBody['login'])
                    print(responseBody['password'])


                    body = {
                        "message" : "ok"
                    }
                    response = 'HTTP/1.1 200 OK\n\n' + json.dumps(body)
                case _:
                    response = methodNotFound

        case _:
            response = pathNotFound
    

    
    client_connection.sendall(response.encode('utf-8'))
    client_connection.close()
"""

async def client_handler(connection):
    loop = asyncio.get_event_loop()
    while True:
        request = (await loop.sock_recv(connection, 1024)).decode('utf-8')
        print(request)

        try:
            headers = request.split("\n")
            method = headers[0].split()[0]
            path = headers[0].split()[1]

            print(method)
            print(path)

            tmp = ''
            flag = False
            for i in headers:
                if flag:
                    tmp += i
                if i == '\r':
                    flag = True

            tmp = [i.replace('\r', '') for i in tmp]
            
            pathNotFound = 'HTTP/1.1 404 NOT FOUND\n\n' + json.dumps({"error" : "Path Not Found"})    
            methodNotFound = 'HTTP/1.1 404 NOT FOUND\n\n' + json.dumps({"error" : "Method Not Found"})

            match path:
                case "/":
                    match method:
                        case "GET":
                            body = {
                                "message" : "Hello World!"
                            }
                            response = 'HTTP/1.1 200 OK\n\n' + json.dumps(body)
                        case _:
                            response = methodNotFound

                case "/login":
                    match method:
                        case "POST":
                            #if login:
                            responseBody = json.loads("".join(tmp))
                            print(responseBody['login'])
                            print(responseBody['password'])


                            body = {
                                "message" : "ok"
                            }
                            response = 'HTTP/1.1 200 OK\n\n' + json.dumps(body)
                        case _:
                            response = methodNotFound

                case _:
                    response = pathNotFound
        except Exception as e:
            print(e)
            await loop.sock_sendall(connection, str.encode(json.dumps({"error" : str(e)})))

        await loop.sock_sendall(connection, response.encode('utf-8'))
        connection.close()

async def run_server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((HOST, PORT))
    server_socket.listen(1)
    print("listening on port %s " % PORT)

    loop = asyncio.get_event_loop()

    while True:
        client_connection, _ = await loop.sock_accept(server_socket)
        try:
            loop.create_task(client_handler(client_connection))
        except asyncio.CancelledError:
            print("отмена ожидания")

asyncio.run(run_server())