extends Node

enum {CONNECTION_CLEAR, CONNECTION_BLOCKED, CONNECTION_INVISIBLE}
enum {DEATH_VIRUS, DEATH_WUMP, DEATH_VIRUS_SPREAD, WIN}
var text_death_virus = {"text": "The virus infected you and your computer :(\nBetter luck next time", "button": "again!"}
var text_death_virus_spread = {"text": "The virus beat you to the WumpVision goggles!\nTry using the buttons next to the portals to seal off the virus", "button":"Okay!"}
var text_death_wump = {"text": "You got beat to death haha\nDo better", "button": "I'll try..."}
var text_win = {"text": "You killed the DataWump! In his files you found the antidote to the virus,\nand saved the whole damn world", "button": "click to play again if you really want to"}

var goggles_destroyed = false
signal connection_blocked(source: String, dest: String)

var rooms: Array[Room] = []
# {"1": {"5": clear, "2": clear, "8": blocked}}
var connections := {}
var current_room: int
var hidden_room_source: int

func reset():
	rooms = []
	connections = {}
	goggles_destroyed = false

func block_connection(source: String, dest: String):
	GlobalData.connections[source][dest] = GlobalData.CONNECTION_BLOCKED
	GlobalData.connections[dest][source] = GlobalData.CONNECTION_BLOCKED
	connection_blocked.emit(source, dest)
	
