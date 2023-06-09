import socket
import json
import sqlite3 as sql
import asyncio

HOST = '0.0.0.0'
PORT = 6666

count=2
active=False

con = sql.connect('./db/users.sql')
cursor = con.cursor()

gamers=[]
gamers.clear()

rpcwaiters= {'dict': socket}
rpcwaiters.clear()

ticwaiters= {'dict': socket}
ticwaiters.clear()

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
async def tictactoe1(conn1, conn2):
    loop = asyncio.get_event_loop()
    try:
        res = await tic(conn1, conn2)
    except Exception as e:
        await asyncio.sleep(0.2)
        print("dd")
        response = {
            "task": "disconnected",
            "response": {
                "code": 400,
                "body": "противник трусливо сбежал"
            }
        }
        try:
            await loop.sock_sendall(conn1, str.encode(json.dumps(response)))
            await loop.sock_sendall(conn2, str.encode(json.dumps(response)))
            q = await asyncio.wait_for(loop.sock_recv(conn1, 1024), timeout=1)

            #print(json.loads(await asyncio.wait_for (loop.sock_recv(conn1, 1024), timeout=3).decode('utf8')))
            if (q==b''):
                res=1
                conn=conn2
            else:
                print("error")
        except asyncio.TimeoutError as e:
            print('timr')
            res=-1
            conn=conn1
        except Exception as e:
            print(e)
            res=1
            conn=conn2
            print(2)
        await asyncio.sleep(0.2)
        m1 = {
            "task": "end",
            "response": {
                "code": 200,
                "body": {
                    "im_tapped": False,
                    "game_start": False,
                    "result": res,
                    "message": "Ты выйграл"
                }
            }
        }
        await loop.sock_sendall(conn, str.encode(str(json.dumps(m1))))
        await asyncio.sleep(0.2)
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'leave', 'show': 'exit from game'})))
    else:
        await asyncio.sleep(0.2)
        print('no')
        mv=str.encode(json.dumps({"task": "wait", "response": {"code" : 200, "body": "waiting for opponents"}}))
        ml=str.encode(json.dumps({"task": 'leave', 'show': 'exit from game'}))
        if res == -1:
            message1 = "Ты проиграл"
            m11=ml
            message2 = "Ты выйграл"
            m22=mv
        elif res == 1:
            message1 = "Ты выйграл"
            m11=mv
            message2 = "Ты проиграл"
            m22=ml
        else:
            message1 = "Ничья"
            message2 = "Ничья"
        m1 = {
            "task": "end",
            "response": {
                "code": 200,
                "body": {
                    "im_tapped": False,
                    "game_start": False,
                    "result": res,
                    "message": message1
                }
            }
        }

        m2 = {
            "task": "end",
            "response": {
                "code": 200,
                "body": {
                    "im_tapped": False,
                    "game_start": False,
                    "result": res,
                    "message": message2
                }
            }
        }

        await loop.sock_sendall(conn1, str.encode((str(json.dumps(m2)))))
        await loop.sock_sendall(conn2, str.encode(str(json.dumps(m1))))
        await asyncio.sleep(0.2)
        print(m22)
        await loop.sock_sendall(conn1, (m22))
        await loop.sock_sendall(conn2, (m11))
        await asyncio.sleep(0.2)
    return res


async def round(player1, player2, n):
    loop = asyncio.get_event_loop()
    res=0
    while(res==0):
        await loop.sock_sendall(player1, str.encode(json.dumps({
            "task": "start",
            "response": {
                "code": 200,
                "body": {
                    "message": "opponent found",
                    "player_token": "X",
                    "im_tapped": True,
                    "game_start": True
                }
            }
        })))
        await loop.sock_sendall(player2, str.encode(json.dumps({
            "task": "start",
            "response": {
                "code": 200,
                "body": {
                    "message": "opponent found",
                    "player_token": "O",
                     "im_tapped": False,
                    "game_start": True
                }
            }
        })))
        res = await asyncio.wait_for(tictactoe1(player1, player2), timeout=None)
    return int(n-(res-1)/2)
async def tourmroom(conn, request):
    print('A')
    loop = asyncio.get_event_loop()
    global gamers
    global active
    global count

    if(active==True):
        print('soory')
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": "sorry", "response": {"code" : 200, "body": "tourment is currently happenng try later"}})))
        return
    gamers.append(conn)
    waiting=len(gamers)
    if waiting<count:
        print('A')
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": "wait", "response": {"code" : 200, "body": "waiting for opponents", "waiting":waiting}})))

        asyncio.current_task().cancel()

    else:
        print('B')
        active=True

        while(waiting>1):
            tasks=[]
            print(waiting/2)
            for i in range(int(waiting/2)):
                print(i)
                player1=gamers[i*2]
                player2=gamers[i*2+1]
                tasks.append(asyncio.create_task(round(player1, player2, i*2)))
            print(tasks)
            o=(await asyncio.wait(tasks, return_when=asyncio.ALL_COMPLETED))
            o=o[0]
            print(o)
            for i in o:
                loop.create_task(client_handler(gamers[i.result()]))
                gamers.pop((i.result()))
            waiting=len(gamers)
            print(waiting)
        print('over')
        conn=gamers[0]
        m1 = {
            "task": "end",
            "response": {
                "code": 200,
                "body": {
                    "im_tapped": False,
                    "game_start": False,
                    "result": 3,
                    "message": "Ты выиграл турнир"
                }
            }
        }
        await loop.sock_sendall(conn, str.encode(str(json.dumps(m1))))
        await asyncio.sleep(0.2)
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'leave', 'show': 'exit from game'})))
        loop.create_task(client_handler(conn))
        active=False
        asyncio.current_task().cancel()

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
    print(temp[0])
    if (temp is None):
        await loop.sock_sendall(conn, bytes(json.dumps({'state': 0}), encoding="utf-8"))
        return None
    await loop.sock_sendall(conn, bytes(json.dumps({"state": 2, 'new_score': temp[0]}), encoding="utf-8"))

def btn_click(comp_choise, choise, res=0):
    if choise == comp_choise:
        print("Ничья")
        res= 0
    # к н б
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
    await asyncio.sleep(0.2)
	
    await loop.sock_sendall(conn1, str.encode(json.dumps({"task": 'get', 'show': 'choise'}))) 
    await loop.sock_sendall(conn2, str.encode(json.dumps({"task": 'get', 'show': 'choise'})))
    
    f = await asyncio.gather(loop.sock_recv(conn1, 1024), (loop.sock_recv(conn2, 1024)))
    print(f)
    res=btn_click(json.loads(f[0].decode('utf8'))["choise"],json.loads(f[1].decode('utf8'))["choise"])
    m1 = {"task": 'show', "result":res, "game_start" : False}
    m2 = {"task": 'show', "result":res, "game_start" : False}
    await loop.sock_sendall(conn1, str.encode(str(json.dumps(m1))))
    await loop.sock_sendall(conn2, str.encode(str(json.dumps(m2))))
    
    if(res == 1):
        data1 = json.loads((await loop.sock_recv(conn1, 1024)).decode('utf8'))
        print(data1)
        await rpcpoints(conn1, data1["login"])
    if(res == -1):
        data2 = json.loads((await loop.sock_recv(conn2, 1024)).decode('utf8'))
        print(data2)
        await rpcpoints(conn2, data2["login"])
        
    tasks = [asyncio.create_task(chat(conn2, conn1)), asyncio.create_task(chat(conn1, conn2))]
    await asyncio.wait(tasks, return_when=asyncio.FIRST_COMPLETED)

async def rpcroom(conn, j):
    loop = asyncio.get_event_loop()
    global rpcwaiters
    key = j["key"]

    if ((rpcwaiters.get(key)) is None):
        rpcwaiters[key] = conn
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'wait_rps', 'show': 'waiting for opponent'})))
        asyncio.current_task().cancel()

    else:
        player =  rpcwaiters[key]
        rpcwaiters.pop(key)
        await loop.sock_sendall(player, str.encode(json.dumps({"task": 'start_rps', 'show': 'opponent found', "first_player" : True,  "game_start" : True})))
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'start_rps', 'show': 'opponent found', "first_player" : False, "game_start" : True})))
        await asyncio.wait_for(rpc(player, conn), timeout=None)
        loop.create_task(client_handler(player))



async def chat(conn1, conn2):
    loop = asyncio.get_event_loop()
    while True:
        message = json.loads((await loop.sock_recv(conn1, 1024)).decode('utf8'))
        if message['task'] == 'chat':
            await loop.sock_sendall(conn2, str.encode(json.dumps({
                "task" : "chat",
                "response" : {
                    "message" : message["request"]["message"],
                    "sender" : message["request"]["sender"],
                }
            })))
            await loop.sock_sendall(conn1, str.encode(json.dumps({"task": 'get', 'show': 'messege recived'})))
        if message['task'] == 'leave':
            await loop.sock_sendall(conn1, str.encode(json.dumps({"task": 'leave', 'show': 'exit from game'})))
            await loop.sock_sendall(conn2, str.encode(json.dumps({"task": 'leave', 'show': 'exit from game'})))
            print('0')
            break
        if not message:
            break

async def chatchoise(conn1, conn2):
    loop = asyncio.get_event_loop()
    task = asyncio.create_task(chat(conn2, conn1))

    while True:
        message = json.loads((await loop.sock_recv(conn1, 1024)).decode('utf8'))

        if message["task"] == "chat":
            await loop.sock_sendall(conn2, str.encode(json.dumps({
                "task" : "chat",
                "response" : {
                    "message" : message["request"]["message"],
                    "sender" : message["request"]["sender"],
                }
            })))
            await loop.sock_sendall(conn1, str.encode(json.dumps({"task": 'get', 'show': 'messege recived'})))

        if message["task"] == "game":
            task.cancel()
            return message["request"]["move"]

        if not message:
            break
    await task
    
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
    temp = cursor.fetchall()
    print(temp[0])
    if (temp is None):
        await loop.sock_sendall(conn, bytes(json.dumps({'state': 0}), encoding="utf-8"))
        return None
    await loop.sock_sendall(conn, bytes(json.dumps({"state": 1, 'new_score': temp[0]}), encoding="utf-8"))
    
async def ticroom(conn, request):
    loop = asyncio.get_event_loop()
    global ticwaiters
    key = request["key"]
    if ticwaiters.get(key) is None:
        ticwaiters[key] = conn
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": "wait", "response": {"code" : 200, "body": "waiting for opponent"}})))
        asyncio.current_task().cancel()

    else:
        player = ticwaiters[key]
        ticwaiters.pop(key)
        await loop.sock_sendall(player, str.encode(json.dumps({
            "task": "start", 
            "response": {
                "code" : 200, 
                "body": {
                    "message" : "opponent found",
                    "player_token" : "X",
                    "im_tapped": True,
                    "game_start" : True
                }
            }
        })))
        await loop.sock_sendall(conn, str.encode(json.dumps({
            "task": "start", 
            "response": {
                "code" : 200,
                "body": {
                    "message" : "opponent found",
                    "player_token" : "O",
                    "im_tapped": False,
                    "game_start" : True
                }
            }
        })))
        await asyncio.wait_for(tictactoe(player, conn), timeout=None)
        loop.create_task(client_handler(player))

async def tictactoe(conn1, conn2):
    loop = asyncio.get_event_loop()
    try:
        res = await tic(conn1, conn2)
    except Exception as e:
        await asyncio.sleep(0.2)
        print("dd")
        response = {
            "task": "disconnected",
            "response": {
                "code": 400,
                "body": "противник трусливо сбежал"
            }
        }
        try:
            await loop.sock_sendall(conn1, str.encode(json.dumps(response)))
            await loop.sock_sendall(conn2, str.encode(json.dumps(response)))
            q = await asyncio.wait_for(loop.sock_recv(conn1, 1024), timeout=1)
            print(q)
            #print(json.loads(await asyncio.wait_for (loop.sock_recv(conn1, 1024), timeout=3).decode('utf8')))
            if (q==b''):
                res=1
                conn=conn2
            else:
                print("error")
        except asyncio.TimeoutError as e:
            print('timr')
            res=-1
            conn=conn1
        except Exception as e:
            print(e)
            res=1
            conn=conn2
            print(2)
        await asyncio.sleep(0.2)
        m1 = {
            "task": "end",
            "response": {
                "code": 200,
                "body": {
                    "im_tapped": False,
                    "game_start": False,
                    "result": res,
                    "message": "Ты выйграл"
                }
            }
        }
        await loop.sock_sendall(conn, str.encode(str(json.dumps(m1))))
        await asyncio.sleep(0.2)
        await loop.sock_sendall(conn, str.encode(json.dumps({"task": 'leave', 'show': 'exit from game'})))
    else:
        await asyncio.sleep(0.2)
        print('no')
        if res == -1:
            message1 = "Ты проиграл"
            message2 = "Ты выиграл"
        elif res == 1:
            message1 = "Ты выиграл"
            message2 = "Ты проиграл"
        else:
            message1 = "Ничья"
            message2 = "Ничья"
            
        m1 = {
            "task": "end",
            "response": {
                "code": 200,
                "body": {
                    "im_tapped": False,
                    "game_start": False,
                    "result": res,
                    "message": message1
                }
            }
        }

        m2 = {
            "task": "end",
            "response": {
                "code": 200,
                "body": {
                    "im_tapped": False,
                    "game_start": False,
                    "result": res,
                    "message": message2
                }
            }
        }

        await loop.sock_sendall(conn1, str.encode((str(json.dumps(m2)))))
        await loop.sock_sendall(conn2, str.encode(str(json.dumps(m1))))
        
        if res == -1:
            data = json.loads((await loop.sock_recv(conn1, 1024)).decode('utf8'))
            await tpoints(conn1, data["login"])
        elif res == 1:
            data = json.loads((await loop.sock_recv(conn2, 1024)).decode('utf8'))
            await tpoints(conn2, data["login"])
        
        

        tasks = [asyncio.create_task(chat(conn2, conn1)), asyncio.create_task(chat(conn1, conn2))]
        await asyncio.wait(tasks, return_when=asyncio.FIRST_COMPLETED)
    return res


async def tic(conn1, conn2):
    board = list(range(0, 9))
    loop = asyncio.get_event_loop()
    counter = 0
    win = False
    while not win:
        whoTapped = counter % 2 == 0
        board_token = "X" if whoTapped else "O"
        if whoTapped:
            send = await take_input("X", conn1, board, conn2)
        else:
            send = await take_input("O", conn2, board, conn1)

        response1 = {
            "task": "game",
            "response" : {
                "code" : 200,
                "body" : {
                    "position" : send,
                    "im_tapped" : not whoTapped,
                    "board_token" : board_token
                }
            }
        }

        response2 = {
            "task": "game",
            "response" : {
                "code" : 200,
                "body" : {
                    "position" : send,
                    "im_tapped" : whoTapped,
                    "board_token" : board_token
                }
            }
        }

        await loop.sock_sendall(conn1, str.encode((json.dumps(response1))))
        await loop.sock_sendall(conn2, str.encode((json.dumps(response2))))

        counter += 1
        if counter > 4:
            tmp = await check_win(board)
            if tmp:
                win = True
                if tmp == "X":
                    return -1
                else:
                    return 1

        if counter == 9:
            return 0

async def take_input(player_token, conn, board, connchat):
    player_answer = await chatchoise(conn, connchat)
    board[player_answer] = player_token
    return player_answer
        
async def check_win(board):
    win_coord = ((0,1,2),(3,4,5),(6,7,8),(0,3,6),(1,4,7),(2,5,8),(0,4,8),(2,4,6))
    for each in win_coord:
        if board[each[0]] != "":
            if board[each[0]] == board[each[1]] == board[each[2]]:
                return board[each[0]]
    return False

async def new(conn, request):
    loop = asyncio.get_event_loop()
    nickname = request["nickname"]
    password = request["password"]
    login = request["login"]

    sql = "INSERT INTO users (nickname, login, password) values(?, ?, ?)"
    data = (nickname, login, password,)
    with con:
        try:
            con.execute(sql, data)
            response = {
            "task": "new",
            "response": {
                "code" : 200,
                "body" : "User added to db",
                "nickname" : nickname
                }
            }
            await loop.sock_sendall(conn, bytes(json.dumps(response), encoding="utf-8"))

        except Exception as e:
            response = {
            "task": "new",
            "response": {
                "code" : 400,
                "body" : "Такой логин уже есть"
                }
            }
            await loop.sock_sendall(conn, str.encode(json.dumps(response)))

async def load(conn, request):
    loop = asyncio.get_event_loop()
    password = request["password"]
    login = request["login"]
    cursor.execute("SELECT nickname, login, password, tscore, rpsscore FROM users WHERE login=? AND password=?", (login, password))
    temp = cursor.fetchone()

    if temp is not None:
        response = {
        "task": "load",
        "response": {
            "code" : 200,
            "body" : "Signed in",
            "nickname" : temp[0],
            "tic_score" : temp[3],
            "rps_score" : temp[4],
            }
        }
        await loop.sock_sendall(conn, bytes(json.dumps(response), encoding="utf-8"))
    else:
        response = {
        "task": "load",
        "response": {
            "code" : 403,
            "body" : "Неверный пароль или логин"
            }
        }
        await loop.sock_sendall(conn, bytes(json.dumps(response), encoding="utf-8"))


async def client_handler(conn):
    loop = asyncio.get_event_loop()
    while True:
        data = (await loop.sock_recv(conn, 1024)).decode('utf8')
        if(data==None):
            continue
        print(data)
        try:
            message = json.loads(data)
        except Exception as e:
            print(e)
            print("SS")
            conn.close()
            break
        try:
            '''            
            if(message["task"]=="load"):
                await load(conn, message["request"])
            elif(message["task"]=="reqest"):
                await new(conn, message["request"])
            elif (message["task"] == "new"):
                await new(conn, message["request"])
            elif (message["task"] == "ticroom"):
                await ticroom(conn, message["request"])
            else:
                await loop.sock_sendall(conn, str.encode(
                    json.dumps({"task": "", "response": {"code": 400, "body": "No such command"}})))
            '''
            match message["task"]:
                case "load":
                    await load(conn, message["request"])
                case "new":
                    await new(conn, message["request"])
                case "ticroom":
                    await ticroom(conn, message["request"])
                case "tourmroom":
                    await tourmroom(conn, message["request"])
                case "rpcroom":
                    await rpcroom(conn, message["request"])
                case _:
                    await loop.sock_sendall(conn, str.encode(json.dumps({"task" : "", "response" : {"code" : 400, "body" : "No such command"}})))

        except Exception as e:
            print(e)
            print('e')
            await loop.sock_sendall(conn, str.encode(json.dumps({"error" : str(e)})))
            conn.close()
            break

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