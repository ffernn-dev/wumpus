class_name WorldManager extends Node3D

const grass_plane_radius = 8 #m
enum {CONNECTION_CLEAR, CONNECTION_BLOCKED, CONNECTION_INVISIBLE}

var portal_scene := preload("res://objects/portal/portal.tscn")
@onready var room_container = $RoomContainer

var rooms: Array[Room] = []
# {"1": {"5": clear, "2": clear, "8": blocked}}
var connections := {}
var current_room: int

func _ready():
	create_rooms()
	create_conections()
	# TODO: populate virus first so that Wump room can't connect to virus room
	var hidden_room_source: int = randi_range(0, 19) 
	create_hidden_room(hidden_room_source)
	load_room(hidden_room_source)


func create_rooms():
	# Standard dodecahedron rooms
	for i in range(20):
		var vertex_position = DodecahedronData.vertices[i]
		var room = Room.new(i, vertex_position)
		rooms.append(room)

func create_conections():
	for edge in DodecahedronData.edges:
		var start = str(edge[0])
		var end = str(edge[1])
		if not connections.get(start): connections[start] = {}
		if not connections.get(end): connections[end] = {}
		connections[start][end] = CONNECTION_CLEAR
		connections[end][start] = CONNECTION_CLEAR

func create_hidden_room(connecting_room_id):
	var connecting_room = rooms[connecting_room_id]
	var _connecting_room_direction = connecting_room.world_position.normalized()
	var _connecting_room_distance = connecting_room.world_position.distance_to(Vector3.ZERO)
	var hidden_room_position = _connecting_room_direction * (_connecting_room_distance + 1)
	
	var hidden_room := Room.new(20, hidden_room_position)
	
	connections["20"] = {}
	connections["20"][str(connecting_room_id)] = CONNECTION_CLEAR
	connections[str(connecting_room_id)]["20"] = CONNECTION_INVISIBLE

func load_room(id: int):
	current_room = id
	$Player.can_move = false
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($UI/BlackScreen, "color", Color.BLACK, 0.5)
	tween.tween_callback(finish_load_room)

func finish_load_room():
	for n in room_container.get_children():
		room_container.remove_child(n)
		n.queue_free()
		
	$Player.position = Vector3(0, 1, 0)
	
	var neighbors: Dictionary = connections[str(current_room)]
	
	var _conn_vals := neighbors.values()
	var num_portals: int
	if false: # TODO: replace with "player has glasses"
		num_portals = _conn_vals.size()
	else:
		num_portals = _conn_vals.filter(func(i): return int(i) != CONNECTION_INVISIBLE).size()
	
	var angle_step = 2 * PI / num_portals
	var i = 0
	
	for room in neighbors:
		if neighbors[room] == CONNECTION_INVISIBLE and not(false):
			continue 
		
		var portal: Portal = portal_scene.instantiate()
		portal.destination_id = int(room)
		portal.portal_entered.connect(load_room)
		
		var theta = i * angle_step
		var x = (grass_plane_radius + 0.02) * cos(theta)
		var y = (grass_plane_radius + 0.02) * sin(theta)
		portal.transform.origin = Vector3(x, 0, y)
		room_container.add_child(portal)
		portal.look_at(Vector3.ZERO)
		i += 1

	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($UI/BlackScreen, "color", Color(0.0, 0.0, 0.0, 0.0), 1)
	$Player.can_move = true
