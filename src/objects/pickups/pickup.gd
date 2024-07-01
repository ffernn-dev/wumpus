class_name Pickup extends Node3D

var item_id := "blank_item"
var n: int = 1

func _on_area_3d_body_entered(body):
	if body is Player:
		print(n)
		body.inventory.pickup(item_id, n)
		queue_free()
