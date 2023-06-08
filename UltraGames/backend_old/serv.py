import socket
import json
import sqlite3 as sl
import asyncio

HOST='0.0.0.0'
PORT =3003

con = sl.connect('./db/users.sql')
cursor = con.cursor()
rpcwaiters= {'dict': socket}

ticwaiters= {'dict': socket}
ticwaiters.clear()
rpcwaiters.clear()
'''waiter
print(waiter)
'''
class user:
    def __init__(self, login, password,tscore ,rpsscore ):
        self.login = login
        self.password = password
        self.tscore = tscore
        self.rpsscore = rpsscore

    name: str
    login: str
    password: str
    tscore: int
    rpsscore: int

m = {"task": 'get'}

get= json.dumps(m)


def draw_board(board, conn1, conn2):
    s= ("-------------"+ '\n')
    for i in range(3) :
        s+= ("|"+ str(board[0+i*3])+ "|"+ str(board[1+i*3])+ "|"+ str(board[2+i*3])+ "|"+ '\n')
        s+= ("-------------"+'\n')
        print(s)
'''    await loop.sock_sendall(conn1, str.encode((json.dumps({"task": 'get', 'show':s}))))
    await loop.sock_sendall(conn2, str.encode((json.dumps({"task": 'get', 'show':s}))))
'''
async def take_input(player_token, conn, board, connchat):
    loop = asyncio.get_event_loop()
    valid = False
    #await loop.sock_sendall(conn, str.encode((json.dumps({"task": 'game', 'show': "enter"}))))
    while not valid:

        player_answer =  await chatchoise(conn, connchat)
        try:
            player_answer = int(player_answer)
        except:
             await loop.sock_sendall(conn, str.encode((json.dumps({"task": 'get', 'show':"wrong enter"}))))
             continue
        if player_answer >= 1 and player_answer <= 9:
            if (str(board[player_answer-1]) not in "XO"):
                board[player_answer-1] = (player_token)
                valid = True
                return player_answer
            else:
                 await loop.sock_sendall(conn, str.encode((json.dumps({"task": 'get', 'show': ("place is not empty")}))))
        else:
             await loop.sock_sendall(conn, str.encode((json.dumps({"task": 'get', 'show': ("wrong. enter 1-9")}))))
async def check_win(board):
    win_coord = ((0,1,2),(3,4,5),(6,7,8),(0,3,6),(1,4,7),(2,5,8),(0,4,8),(2,4,6))
    for each in win_coord:
        if board[each[0]] == board[each[1]] == board[each[2]]:
            return board[each[0]]
    return False
async def chat(conn1, conn2):
    loop = asyncio.get_event_loop()

    while 1:

        data = json.loads((await loop.sock_recv(conn1, 1024)).decode('utf8'))

        if(data['task']==('chat')):
            await loop.sock_sendall(conn2, str.encode(str(json.dumps(data))))
            await loop.sock_sendall(conn1, str.encode(json.dumps({"task": 'get', 'show': 'messege recived'})))
        if(data['task']==('end')):
            await loop.sock_sendall(conn1, str.encode(json.dumps({"task": 'end', 'show': 'exit from game'})))
            await loop.sock_sendall(conn2, str.encode(json.dumps({"task": 'end', 'show': 'exit from game'})))
        if not data:
            break
        print(data['show'])
async def chatchoise(conn1, conn2):
    loop = asyncio.get_event_loop()
    task = asyncio.create_task(chat(conn2, conn1))
    while 1:

        data = json.loads((await loop.sock_recv(conn1, 1024)).decode('utf8'))

        if (data['task'] == ('chat')):
            await loop.sock_sendall(conn2, str.encode(str(json.dumps(data))))
            await loop.sock_sendall(conn1, str.encode(json.dumps({"task": 'get', 'show': 'messege recived'})))

        if (data['task'] == ('game')):
            task.cancel()
            return data['choise']
            print('s')
            break

        if not data:
            break
        print(data['show'])
    await task

async def tic( conn1, conn2):
    board = list(range(1, 10))
    loop = asyncio.get_event_loop()
    counter = 0
    win = False
    while not win:
        draw_board(board, conn1, conn2)
        if counter % 2 == 0:
            send=await  take_input("X", conn1, board, conn2)
        else:
            send=await take_input("O", conn2, board, conn1)
        await loop.sock_sendall(conn1, str.encode((json.dumps({"task": 'game', 'move': (send)}))))
        await loop.sock_sendall(conn2, str.encode((json.dumps({"task": 'game', 'move': (send)}))))

        counter += 1
        if counter > 4:
            tmp = await check_win(board)
            if tmp:
                print (tmp, "выиграл!")
                win = True
                if(tmp=='X'):
                    return -1
                else:
                    return 1
                break
        if counter == 9:
            print ("Ничья!")
            return 0
            break
    #await draw_board(board, conn1, conn2)


async def tictactoe(conn1, conn2):
    loop = asyncio.get_event_loop()
    res=(await tic(conn1, conn2))
    m1 = {"task": 'end', "result": res}
    m2 = {"task": 'end', "result": -res}
    await loop.sock_sendall(conn1, str.encode((str(json.dumps(m2)))))
    await loop.sock_sendall(conn2, str.encode(str(json.dumps(m1))))
    data1 = json.loads((await loop.sock_recv(conn1, 1024)).decode('utf8'))
    data2 = json.loads((await loop.sock_recv(conn2, 1024)).decode('utf8'))
    print(data2)
    print(data1)
    if(data2["task"]=="add"):
        await tpoints(conn2, data2["log"])
    if(data1["task"]=="add"):
        await tpoints(conn1, data1["log"])
    await asyncio.gather(chat(conn1, conn2), chat(conn2, conn1))
    
async def new(conn, data):
    loop = asyncio.get_event_loop()
    passw=data['pas']
    log=data['log']

    sql = 'INSERT INTO users ( login,    password, tscore,   rpsscore ) values(?, ?, ?, ?)'
    data = [
        (log, passw, 0, 0)

    ]
    with con:
        try:
            con.execute(sql, data)
        except Exception as e:
            print(e)
            await loop.sock_sendall(conn, str.encode(json.dumps({"state": 0, 'show': str(e)})))
            return None
    await loop.sock_sendall(conn, bytes(json.dumps({"state": 1 , "user":(log, passw, 0, 0)}), encoding="utf-8"))
async def tpoints(conn, log):
    loop = asyncio.get_event_loop()
    print(log)
    sql = "UPDATE users SET tscore = (tscore + 1) WHERE login=?"
    with con:
        try:
            con.execute(sql, [log])
        except Exception as e:
            print(e)
            await loop.sock_sendall(conn, str.encode(json.dumps({"state": 0, 'show': str(e)})))
            return None
    cursor.execute("SELECT tscore FROM users WHERE login=?", [(log)])
    print(3)
    temp = (cursor.fetchall())
    print(temp)
    if (temp is None):
        await loop.sock_sendall(conn, bytes(json.dumps({'state': 0}), encoding="utf-8"))
        return None
    await loop.sock_sendall(conn, bytes(json.dumps({"state": 1, 'newscore': temp}), encoding="utf-8"))
async def rpcpoints(conn, log):
    loop = asyncio.get_event_loop()
    print(log)
    sql = "UPDATE users SET rpsscore = (rpsscore + 1) WHERE login=?"
    with con:
        try:
            con.execute(sql, [log])
        except Exception as e:
            print(e)
            await loop.sock_sendall(conn, str.encode(json.dumps({"state": 0, 'show': str(e)})))
            return None
    cursor.execute("SELECT rpsscore FROM users WHERE login=?", [(log)])
    print(3)
    temp = (cursor.fetchall())
    print(temp)
    if (temp is None):
        await loop.sock_sendall(conn, bytes(json.dumps({'state': 0}), encoding="utf-8"))
        return None
    await loop.sock_sendall(conn, bytes(json.dumps({"state": 1, 'newscore': temp}), encoding="utf-8"))

async def load(conn:socket, data):
    loop = asyncio.get_event_loop()
    pas=data['pas']
    log=data['log']
    cursor.execute("SELECT login,    password, tscore,  rpsscore  FROM users WHERE login=?", [(log)])
    temp = (cursor.fetchone())

    if (temp is None):
        await loop.sock_sendall(conn, bytes(json.dumps({'state':0}),encoding="utf-8"))
        return None
    if(temp[1]!=pas):
        await loop.sock_sendall(conn, bytes(json.dumps({'state':-1}),encoding="utf-8"))
        return 'error'
    us = user(temp[0], temp[1], temp[2], temp[3])
    '''us.login    = temp[0]
    us.password = temp[1]
    us.tscore   = temp[2]
    us.rpsscore = temp[3]
    '''

    await loop.sock_sendall(conn, bytes(json.dumps({"state":1, 'user':temp}),encoding="utf-8"))
    return us


def btn_click(comp_choise, choise, res=0):
    if choise == comp_choise:
        print("Ничья")
        res= 0

    elif choise == '1' and comp_choise == '2' \
            or choise == '2' and comp_choise == '3' \
            or choise == '3' and comp_choise == '1':
        print("Победа 1")
        res= 1
    else:
        print("Проигрыш 1")
        res= -1
    return res
async def rpc(conn1, conn2):
    loop = asyncio.get_event_loop()
    await asyncio.wait([loop.sock_sendall(conn1, str.encode(json.dumps({"task": 'get', 'show': 'choise'}))), loop.sock_sendall(conn2, str.encode(json.dumps({"task": 'get', 'show': 'choise'})))])
    f= await asyncio.gather(loop.sock_recv(conn1, 1024), (loop.sock_recv(conn2, 1024)))
    #await asyncio.wait(btn_click((loop.sock_recv(conn1, 1024)).decode('utf8'), (loop.sock_recv(conn2, 1024)).decode('utf8'), res))
    print(f)
    res=btn_click(json.loads(f[0].decode('utf8'))["choise"],json.loads(f[1].decode('utf8'))["choise"])
    m1 = {"task": 'show', "result":res}
    m2 = {"task": 'show', "result":-res}
    await loop.sock_sendall(conn1, str.encode(str(json.dumps(m2))))
    await loop.sock_sendall(conn2, str.encode(str(json.dumps(m1))))
    data1 = json.loads((await loop.sock_recv(conn1, 1024)).decode('utf8'))
    data2 = json.loads((await loop.sock_recv(conn2, 1024)).decode('utf8'))
    print(data2)
    print(data1)
    if(data2["task"]=="add"):
        await rpcpoints(conn2, data2["log"])
    if(data1["task"]=="add"):
        await rpcpoints(conn1, data1["log"])
    await asyncio.gather(chat(conn1, conn2), chat(conn2, conn1))
async  def jail():
    await asyncio.wait(10)
    print('jil')

async def rpcroom(conn, j):
    loop = asyncio.get_event_loop()
    global rpcwaiters
    key = j["key"]

    if ((rpcwaiters.get(key)) is None):
        rpcwaiters[key] = conn
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'wait', 'show': 'waiting for opponent'})))
        asyncio.current_task().cancel()

    else:
        player =  rpcwaiters[key]
        rpcwaiters.pop(key)
        await loop.sock_sendall(player, str.encode(json.dumps({"task": 'stop', 'show': 'opponent found'})))
        await asyncio.wait_for(rpc(player, conn), timeout=None)
        loop.create_task(client_handler(player))
async def ticroom(conn,j):
    loop = asyncio.get_event_loop()
    global ticwaiters
    key=j['key']
    if((ticwaiters.get(key)) is None):
        ticwaiters[key]=conn
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'wait', 'show': 'waiting for opponent'})))
        asyncio.current_task().cancel()

    else:
        player=ticwaiters[key]
        ticwaiters.pop(key)
        await loop.sock_sendall(player, str.encode(json.dumps({"task": 'start', 'show': 'opponent found'})))
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'start', 'show': 'opponent found'})))
        await asyncio.wait_for(tictactoe(player, conn), timeout=None)
        loop.create_task(client_handler(player))


async def fun(conn, j):
    print('ok')
async def skip(conn, j):
    print('nok')

async def client_handler(conn):
    loop = asyncio.get_event_loop()
    print(conn)
    await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'get', 'show': 'connected'})))
    while True:

        data = (await loop.sock_recv(conn, 1024)).decode('utf8')
        if not data :
            continue
        print(data)
        message = json.loads(data)
    #message = data

        print(message['task'])
        if(message['task']=='end'):
            break

        try:
            func = globals()[message['task']]
            await func(conn, message)
        except Exception as e:
            print(e)
            await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'error', 'show': str(e)})))
    await loop.sock_sendall(conn, str.encode('end'))
    conn.close()

async def run_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((HOST, PORT))
    server.listen()
    server.setblocking(False)

    loop = asyncio.get_event_loop()

    while True:
        client, _ = await loop.sock_accept(server)
        try:
            loop.create_task(client_handler(client))
        except asyncio.CancelledError:
            print('cancel_me(): отмена ожидания')


asyncio.run(run_server())