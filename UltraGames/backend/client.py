
import json
import socket

HOST = '127.0.0.1'
PORT = 3003

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    i = 0
    while True:
        data = s.recv(1024).decode('utf8')
        print(data)
        if not data:
            s.close()
            break
        try:
            message = json.loads(data)
            print(message['show'])
            if message['task'] == 'get':
        
                alias = input()
                m = {
                    "task": str(alias), 
                    "log": "man", 
                    "pas": "123", 
                    "key":'key'
                }
                data = json.dumps(m)
                try:
                    s.sendall((bytes(data, encoding="utf-8")))
                except(e):
                    print(e)
                    s.close()
                    break
            if message['task'] == 'wait':
                data1=message
                while (data1['task'] != 'stop'):
                    data1 = json.loads(s.recv(1024).decode('utf8'))
                    print(data1)
                continue
            if message['task'] == 'end':
                s.close()
                break
            
        except Exception as e:
            print(e)
            
        if i == 1:
            i = 2
            continue

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