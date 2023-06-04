import threading
import json
import socket

HOST = '127.0.0.1'
PORT = 3003
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
<<<<<<< HEAD
            if (data["task"] == ("end")):
                print("result:")
                print(data["result"])
=======
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

            if (data["task"] == ("end")):
>>>>>>> a309de28812aa92e4fbcb3007b1abcd5b848faa3
                break
            if not data:
                break
    s.connect((HOST, PORT))
    data = s.recv(1024).decode('utf8')
<<<<<<< HEAD
    i=0
    while(i!=1):
        login="man"
        password="123"
=======
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
        login="man8"
        password="333"
>>>>>>> a309de28812aa92e4fbcb3007b1abcd5b848faa3
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
<<<<<<< HEAD
    #g=input()
    g='r'
    if(g=="t"):
=======
    #game=input()
    game='t'
    if(game=="t"):
>>>>>>> a309de28812aa92e4fbcb3007b1abcd5b848faa3
        #key=input()
        key="any"
        m = {"task": "ticroom", "key":key}
        data = json.dumps(m)
        s.sendall((bytes(data, encoding="utf-8")))
        data = json.loads(s.recv(1024).decode('utf8'))
        print(data)
        if(data['task']=="wait"):
            print("wait")
            data = json.loads(s.recv(1024).decode('utf8'))
        print(data)
        potok = threading.Thread(target=read)
        print(22)
        potok.start()
<<<<<<< HEAD

        while(potok.is_alive()):
            g=input()
            if(g != '1'):
=======
        i=0
        while(potok.is_alive()):
            g=input()
            if(g != '1'):
                if (g == '0'):
                    m = {"task": "end"}
                    data = json.dumps(m)
                    s.sendall((bytes(data, encoding="utf-8")))
>>>>>>> a309de28812aa92e4fbcb3007b1abcd5b848faa3
                mes=g
                m = {"task": "chat", "show": mes}
                data = json.dumps(m)
                s.sendall((bytes(data, encoding="utf-8")))
            else:
                print("turn")
<<<<<<< HEAD
                t=input()
                m = {"task": "game", "choise": t}
                data = json.dumps(m)
                s.sendall((bytes(data, encoding="utf-8")))
    if (g == "r"):
=======

                t=input()

                m = {"task": "game", "choise": t}
                data = json.dumps(m)
                s.sendall((bytes(data, encoding="utf-8")))
    if (game == "r"):
>>>>>>> a309de28812aa92e4fbcb3007b1abcd5b848faa3
        # key=input()
        key = "any"
        m = {"task": "rpcroom", "key": key}
        data = json.dumps(m)
        s.sendall((bytes(data, encoding="utf-8")))
        data = json.loads(s.recv(1024).decode('utf8'))
        print(data)
        if (data['task'] == "wait"):
            print("wait")
            data = json.loads(s.recv(1024).decode('utf8'))
        print(data)
        potok = threading.Thread(target=read)
        print(22)
        potok.start()
<<<<<<< HEAD
        t = input()
=======
        #t = input()
        t=1
>>>>>>> a309de28812aa92e4fbcb3007b1abcd5b848faa3
        m = {"task": "game", "choise": t}
        data = json.dumps(m)
        s.sendall((bytes(data, encoding="utf-8")))
        while (potok.is_alive()):

            g = input()
<<<<<<< HEAD
=======
            if(g=='0'):
                m = {"task": "end"}
                data = json.dumps(m)
                s.sendall((bytes(data, encoding="utf-8")))

>>>>>>> a309de28812aa92e4fbcb3007b1abcd5b848faa3
            mes = g
            m = {"task": "chat", "show": mes}
            data = json.dumps(m)
            s.sendall((bytes(data, encoding="utf-8")))

<<<<<<< HEAD







=======
>>>>>>> a309de28812aa92e4fbcb3007b1abcd5b848faa3
    s.close()


'''
    m = {"task": "ticroom", "log": "man", "pas": "123", "key": 'key'}
    data = json.dumps(m)
    s.sendall((bytes(data, encoding="utf-8")))

    while (1):
        data = s.recv(1024).decode('utf8')
        print(data)
        if not data:
            s.close()
            break
        try:
            message = json.loads(data)
            print(message['show'])
            if (message['task'] == 'get'):
                alias = input()
                if (alias in '123456789'):
                    m = {"task": "game", "choise": alias, "log": "man", "pas": "123", "key": 'key'}
                else:
                    m = {"task": "chat", "show": alias, "log": "man", "pas": "123", "key": 'key'}
                data = json.dumps(m)
                s.sendall((bytes(data, encoding="utf-8")))
            if (message['task'] == ('wait')):
                data1 = message
                while (data1['task'] != 'stop'):
                    data1 = json.loads(s.recv(1024).decode('utf8'))
                    print(data1)
                continue
            if (message['task'] == ('end')):
                s.close()
                break
        except Exception as e:
            print(e)
        if (i == 1):
            i = 2
            continue
'''
'''
import json
import socket
import threading
import pickle

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
            if(i==2 and message['task']=='get'):
                m = {"task": 'skip'}
                data = json.dumps(m)
                s.sendall((bytes(data, encoding="utf-8")))
                i=0
                continue
            if(message['task']=='get' and i==0):
                alias = input()
                m = {"task": alias, "log": "man", "pas": "123"}
                data = json.dumps(m)
                s.sendall((bytes(data, encoding="utf-8")))
            if (message['task']== ('wait')):
                i=1
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