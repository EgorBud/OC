
import json
import socket


HOST = "192.168.1.76"  # The server's hostname or IP address
PORT = 1234  # The port used by the server
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    i=0
    while(1):
        data = s.recv(1024).decode('utf8')
        print(data)
        if not data:
            s.close()
            break
        try:
            message = json.loads(data)
            print(message['show'])
            if(message['task']=='get'):
                alias = input()
                m = {"task": alias, "log": "man", "pas": "123", "key":'key'}
                data = json.dumps(m)
                s.sendall((bytes(data, encoding="utf-8")))
            if (message['task']== ('wait')):
                data1=message
                while(data1['task']!='stop'):
                    data1 = json.loads(s.recv(1024).decode('utf8'))
                    print(data1)
                continue
            if (message['task']== ('end')):
                s.close()
                break
        except Exception as e:
            print(e)
        if (i==1):
            i = 2
            continue

'''




    def read_sok():
        while 1:
            data = s.recv(1024)
            if(data.decode('utf-8')==('end')):
                s.close()
                print('s')
                break
            if not data:
                s.close()
                break
            print(data.decode('utf-8'))

    s.connect((HOST, PORT))
    potok = threading.Thread(target=read_sok)
    potok.start()
    i=0
    alias = input()


    m = {"task": alias, "log": "man", "pas": "123"}
    data = json.dumps(m)
    s.sendall((bytes(data,encoding="utf-8")))
    #data = s.recv(1024)
    #print(f"Received {data!r}")
    while i != 1:

        alias = input()

        m = {"task": alias, "log": "man", "pas": "123"}
        data = json.dumps(m)
        try:
            s.sendall((bytes(data, encoding="utf-8")))
        except:
            break
        # data = s.recv(1024)
        # print(f"Received {data!r}")




'''


'''import socket

HOST = "192.168.1.76"  # The server's hostname or IP address
PORT = 1234  # The port used by the server

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))

    alias = input()
    s.sendall(alias.encode())
    alias = input()
    s.sendall(alias.encode())
    alias = input()
    s.sendall(alias.encode())
    data = s.recv(1024)
    print(f"Received {data!r}")

'''