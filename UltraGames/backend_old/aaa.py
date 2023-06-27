import json
import socket

HOST = '127.0.0.1'
PORT = 3003

q=[6]
q[0]=0
q.append(99)
s=socket.socket()
q.append(s)

print(q)

'''
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

    def read():
        while 1:
            data = json.loads(s.recv(1024).decode('utf8'))
            print(data)
            if (data["task"] == ('chat')):
                print(data["show"])
            if (data["task"] == ("game")):
                print("change board and let next move")
                print(data["move"])
            if (data["task"] == ("show")):
                print("result:")
                print(data["result"])
                if(data["result"]==1):
                    m = {"task": "add", "log": user[0]}
                    data1 = json.dumps(m)
                    s.sendall((bytes(data1, encoding="utf-8")))
                    data1 = json.loads(s.recv(1024).decode('utf8'))
                    print(data1)
                else:
                    m = {"task": "loh", "log": user[0]}
                    data1 = json.dumps(m)
                    s.sendall((bytes(data1, encoding="utf-8")))
                    print(data1)
            if(data['task']=="disconnected"):
                m = {"task": "add", "log": user[0]}
                data1 = json.dumps(m)
                s.sendall((bytes(data1, encoding="utf-8")))
                data1 = json.loads(s.recv(1024).decode('utf8'))
                print(data1)
            if (data["task"] == ("end")):
                break
            if not data:
                break
    s.connect((HOST, PORT))
    data = s.recv(1024).decode('utf8')
    i=0#log in or new user

    if(i==1):
        i = 0
        while(i!=1):

            #newuser
            login="man4"
            password="123"
            #login=input()
            #password=input()
            m = {"task": "new", "log": login, "pas": password}
            data = json.dumps(m)
            s.sendall((bytes(data, encoding="utf-8")))
            data = json.loads(s.recv(1024).decode('utf8'))
            print(data)
            i=data["state"]
            if(i!=1):
                print(i)

    while(i!=1):
        #olduser
        login="man"
        password="123"
        #login=input()
        #password=input()
        m = {"task": "load", "log": login, "pas": password}
        data = json.dumps(m)
        s.sendall((bytes(data, encoding="utf-8")))
        data = json.loads(s.recv(1024).decode('utf8'))
        i=data["state"]
        if(i!=1):
            print(i)
    user = data["user"]
    print(user)
    g="fun"
    m = {"task": g, "key": 'key'}
    data = json.dumps(m)
    s.setblocking(True)
    try:
        q=s.sendall((bytes(data, encoding="utf-8")))
        print(q)
        print("D")
    except:
        print(1)

    try:
        data = json.loads(s.recv(1024).decode('utf8'))
        print(data)
    except:
        print(2)
    g=input()
'''