class_name Room extends Node

@export var id: int = 0
@export var contents := []
@export var world_position: Vector3

func _init(room_id: int, room_world_position: Vector3):
	id = room_id
	world_position = room_world_position
