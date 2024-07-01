class_name WorldManager extends Node3D

const grass_plane_radius = 8 #m

var portal_scene := preload("res://objects/portal/portal.tscn")
var arrow_scene := preload("res://objects/pickups/arrow.tscn")
#var goggles_scene := preload("res://objects/portal/portal.tscn")
@onready var room_container = $RoomContainer


func _ready():
	create_rooms()
	create_conections()
	for i in range(4):
		var arrow = Arrow.new()
		GlobalData.rooms[randi_range(0, 19)].contents.append(arrow)
	# TODO: populate virus first so that Wump room can't connect to virus room
	GlobalData.hidden_room_source = randi_range(0, 19) 
	create_hidden_room(GlobalData.hidden_room_source)
	load_room(GlobalData.hidden_room_source)


func create_rooms():
	# Standard dodecahedron rooms
	for i in range(20):
		var vertex_position = DodecahedronData.vertices[i]
		var room = Room.new(i, vertex_position)
		GlobalData.rooms.append(room)

func create_conections():
	for edge in DodecahedronData.edges:
		var start = str(edge[0])
		var end = str(edge[1])
		if not GlobalData.connections.get(start): GlobalData.connections[start] = {}
		if not GlobalData.connections.get(end): GlobalData.connections[end] = {}
		GlobalData.connections[start][end] = GlobalData.CONNECTION_CLEAR
		GlobalData.connections[end][start] = GlobalData.CONNECTION_CLEAR

func create_hidden_room(connecting_room_id):
	var connecting_room = GlobalData.rooms[connecting_room_id]
	var _connecting_room_direction = connecting_room.world_position.normalized()
	var _connecting_room_distance = connecting_room.world_position.distance_to(Vector3.ZERO)
	var hidden_room_position = _connecting_room_direction * (_connecting_room_distance + 1)
	
	var hidden_room := Room.new(20, hidden_room_position)
	GlobalData.rooms.append(hidden_room)
	
	GlobalData.connections["20"] = {}
	GlobalData.connections["20"][str(connecting_room_id)] = GlobalData.CONNECTION_CLEAR
	GlobalData.connections[str(connecting_room_id)]["20"] = GlobalData.CONNECTION_INVISIBLE

func load_room(id: int):
	GlobalData.current_room = id
	$Player.can_move = false
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($UI/BlackScreen, "color", Color.BLACK, 0.5)
	tween.tween_callback(finish_load_room)

func finish_load_room():
	for n in room_container.get_children():
		room_container.remove_child(n)
		n.queue_free()
		
	$Player.position = Vector3(2, 1, 0)
	
	var neighbors: Dictionary = GlobalData.connections[str(GlobalData.current_room)]
	
	var _conn_vals := neighbors.values()
	var num_portals: int
	if true: # TODO: replace with "player has glasses"
		num_portals = _conn_vals.size()
	else:
		num_portals = _conn_vals.filter(func(i): return int(i) != GlobalData.CONNECTION_INVISIBLE).size()
	
	var angle_step = 2 * PI / num_portals
	var i = 0
	
	for room in neighbors:
		if neighbors[room] == GlobalData.CONNECTION_INVISIBLE and not(true):
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
	
	for room in GlobalData.rooms:
		room.tick()
	
	var map_room = GlobalData.current_room
	if map_room == 20:
		$Minimap.hide()
	else:
		$Minimap.show()
		$Minimap.set_dodec_rotation(map_room)
	
	var room = GlobalData.rooms[GlobalData.current_room]
	for item in room.contents:
		if item is Virus:
			pass # TODO: gameover
		elif item is Arrow:
			var entity = arrow_scene.instantiate()
			var pos = random_point_on_circle(grass_plane_radius - 2, 0.5)
			entity.transform.origin = Vector3(pos.x, 0, pos.y)
			room_container.add_child(entity)
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($UI/BlackScreen, "color", Color(0.0, 0.0, 0.0, 0.0), 1)
	$Player.can_move = true


func random_point_on_circle(radius: float, deadzone: float):
	var r = radius * sqrt(randf()) + deadzone
	var theta = randf() * 2 * PI
	return Vector2(r * cos(theta), r * sin(theta))
