class_name Room extends Node

@export var id: int = 0
@export var contents := []
@export var world_position: Vector3

func _init(room_id: int, room_world_position: Vector3):
	id = room_id
	world_position = room_world_position

func create_virus():
	var virus = Virus.new(id)
	contents.append(virus)

func create_arrow():
	var arrow = Arrow.new()
	arrow.parent_room = self
	contents.append(arrow)

func create_goggles():
	var goggles = Goggles.new()
	goggles.parent_room = self
	contents.append(goggles)

func tick():
	for item in contents:
		if item is Virus:
			item.tick()
