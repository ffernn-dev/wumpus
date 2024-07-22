class_name Pickup extends Node3D

var item_id := "blank_item"
var n: int = 1
var parent_room: Room

func _on_area_3d_body_entered(body):
	if body is Player:
		body.inventory.pickup(item_id, n)
		parent_room.contents.erase(self)
		queue_free()

func _ready():
	var scene = load("res://objects/pickups/" + item_id + ".tscn").instantiate()
	add_child(scene)
	scene.get_node("Main/Area3D").body_entered.connect(_on_area_3d_body_entered)
