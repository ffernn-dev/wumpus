class_name Pickup extends Node3D

var item_id := "blank_item"
var n: int = 1

func _on_area_3d_body_entered(body):
	if body is Player:
		body.inventory.pickup(item_id)
		queue_free()
