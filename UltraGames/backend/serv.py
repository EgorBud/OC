import socket
from _thread import *
import json
import sqlite3 as sl
import asyncio

HOST='0.0.0.0'
PORT=3003

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

async def draw_board(board, conn1, conn2):
    loop = asyncio.get_event_loop()
    s= ("-------------"+ '\n')
    for i in range(3) :
        s+= ("|"+ str(board[0+i*3])+ "|"+ str(board[1+i*3])+ "|"+ str(board[2+i*3])+ "|"+ '\n')
        s+= ("-------------"+'\n')
        print(s)
'''    await loop.sock_sendall(conn1, str.encode((json.dumps({"task": 'get', 'show':s}))))
    await loop.sock_sendall(conn2, str.encode((json.dumps({"task": 'get', 'show':s}))))
'''
async def take_input(player_token, conn, board):
    loop = asyncio.get_event_loop()
    valid = False
    await loop.sock_sendall(conn, str.encode((json.dumps({"task": 'get', 'show': "enter"}))))
    while not valid:

        player_answer =   json.loads((await loop.sock_recv(conn, 1024)).decode('utf8'))['task']
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

async def tic(conn1, conn2):
    board = list(range(1, 10))
    loop = asyncio.get_event_loop()
    counter = 0
    win = False
    while not win:
        await draw_board(board, conn1, conn2)
        if counter % 2 == 0:
            send=await  take_input("X", conn1, board)
        else:
            send=await take_input("O", conn2, board)
        await loop.sock_sendall(conn1, str.encode((json.dumps({"task": 'move', 'show': (send)}))))
        await loop.sock_sendall(conn2, str.encode((json.dumps({"task": 'move', 'show': (send)}))))

        counter += 1
        if counter > 4:
            tmp = await check_win(board)
            if tmp:
                print (tmp, "выиграл!")
                win = True
                if tmp == 'X':
                    return -1
                else:
                    return 1
        if counter == 9:
            print ("Ничья!")
            return 0
    await draw_board(board, conn1, conn2)


async def tictactoe(conn1, conn2):
    loop = asyncio.get_event_loop()
    res=(await tic(conn1, conn2))
    m1 = {"task": 'show', "result": res}
    m2 = {"task": 'show', "result": -res}
    await loop.sock_sendall(conn1, str.encode((str(json.dumps(m2)))))
    await loop.sock_sendall(conn2, str.encode(str(json.dumps(m1))))
    
async def new(conn, json):
    passw=json['pas']
    log=json['log']
    sql = 'INSERT INTO users ( login,    password, tscore,   rpsscore ) values(?, ?, ?, ?)'
    data = [
        (log, passw, 0, 0)
    ]

    with con:
        con.executemany(sql, data)

    #login, socket    


async def load(conn:socket, data):
    loop = asyncio.get_event_loop()
    pas=data['pas']
    log=data['log']
    cursor.execute("SELECT login, password, tscore,  rpsscore  FROM users WHERE login=?", [(log)])
    temp = (cursor.fetchone())
    if (temp is None):
        await loop.sock_sendall(conn, str.encode(('user not found')))
        return None
    if(temp[1]!=pas):
        await loop.sock_sendall(conn, str.encode('wrong password'))
        return error
    us = user(temp[0], temp[1], temp[2], temp[3])
    '''us.login    = temp[0]
    us.password = temp[1]
    us.tscore   = temp[2]
    us.rpsscore = temp[3]
    '''

    await loop.sock_sendall(conn, bytes(json.dumps(temp),encoding="utf-8"))
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
ThreadCount = 0
async def rpc(conn1, conn2):
    loop = asyncio.get_event_loop()
    await asyncio.wait([loop.sock_sendall(conn1, str.encode(json.dumps({"task": 'get', 'show': 'choise'}))), loop.sock_sendall(conn2, str.encode(json.dumps({"task": 'get', 'show': 'choise'})))])
    f= await asyncio.gather(loop.sock_recv(conn1, 1024), (loop.sock_recv(conn2, 1024)))
    #await asyncio.wait(btn_click((loop.sock_recv(conn1, 1024)).decode('utf8'), (loop.sock_recv(conn2, 1024)).decode('utf8'), res))
    print(f)
    res=btn_click(json.loads(f[0].decode('utf8')),json.loads(f[1].decode('utf8')))
    m1 = {"task": 'show', "result":res}
    m2 = {"task": 'show', "result":-res}
    await loop.sock_sendall(conn1, str.encode((str(json.dumps(m2)))))
    await loop.sock_sendall(conn2, str.encode(str(json.dumps(m1))))
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
        await loop.sock_sendall(rpcwaiters[key], str.encode(json.dumps({"task": 'stop', 'show': 'opponent found'})))
        await asyncio.wait_for(rpc(rpcwaiters[key], conn), timeout=None)
        loop.create_task(client_handler(rpcwaiters[key]))
        rpcwaiters[key] = None
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
        ticwaiters[key]=None
        await loop.sock_sendall(player, str.encode(json.dumps({"task": 'stop', 'show': 'opponent found'})))
        await asyncio.wait_for(tictactoe(player, conn), timeout=None)
        loop.create_task(client_handler(player))

async def fun(conn, j):
    print('ok')
async def skip(conn, j):
    print('nok')

async def client_handler(conn):
    loop = asyncio.get_event_loop()
    print(conn)
    while True:
        #await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'get', 'show': 'connected'})))
        data = (await loop.sock_recv(conn, 1024)).decode('utf8')
        if not data :
            continue
        print(data)
        message = json.loads(data)

        print(message['task'])
        if message['task'] == 'end':
            break

        try:
            func = globals()[message['task']]
            await func(conn, message)
        except Exception as e:
            print(e)
            await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'error', 'show': str(e)})))
    await loop.sock_sendall(conn, str.encode('end'))
    conn.close()






def accept_connections(ServerSocket):
    Client, address = ServerSocket.accept()
    print('Connected to: ' + address[0] + ':' + str(address[1]))
    start_new_thread(client_handler, (Client, ))

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
