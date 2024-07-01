extends Node

enum {CONNECTION_CLEAR, CONNECTION_BLOCKED, CONNECTION_INVISIBLE}

var rooms: Array[Room] = []
# {"1": {"5": clear, "2": clear, "8": blocked}}
var connections := {}
var current_room: int
var hidden_room_source: int

