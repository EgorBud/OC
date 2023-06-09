import json
import socket

HOST = '127.0.0.1'
PORT = 3003
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
                if(alias in '123456789'):
                    m = {"task": "game","choise":alias, "log": "man", "pas": "123", "key":'key'}
                else:
                    m = {"task": "chat", "show": alias, "log": "man", "pas": "123", "key": 'key'}
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