room = {
    "players" : [
        "login1", "login2"
    ],
    "status" : "waiting, game, chatting, game",
    "board" : ["", "", "", "", "", "", "", "", ""],
    "chat_history" : [
        {
            "message1" : {
                "sender" : "login1",
                "body" : "some text",
                "time" : "when send"
            }
        },
        {
            "message1" : {
                "sender" : "login2",
                "body" : "some text",
                "time" : "when send"
            }
        }
    ],
}

rooms = [
    {"key" , room}
]


print(rooms[0])