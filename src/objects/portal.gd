extends Area3D

@export var destination_id: int = 0

func _init(dest = 0):
	destination_id = dest


func _on_body_entered(body):
	if body is Player:
		print(body)
