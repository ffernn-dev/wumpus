class_name Player extends CharacterBody3D


const MAX_SPEED = 5.0 #m/s
const ACCEL = 100 #m/s^2
const JUMP_HEIGHT = 1.5 #m
const CAMERA_SENSITIVITY = 1

var jumping := false
var mouse_captured := false

# Default project gravity to sync with physics objects
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera := $Neck/Eyes
@onready var raycast := $Neck/Eyes/RayCast3D
@onready var inventory := $Inventory

var input_vec: Vector2 # Movement direction given by input keys
var look_vec: Vector2 # Input direction for look/aim

var walk_vel: Vector3
var gravity_vel: Vector3
var jump_vel: Vector3

var can_move := true
var raycast_was_colliding = false
var last_hovered_portal

var active_arrows = []
var arrow_scene := preload("res://objects/moving_arrow/moving_arrow.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_vec = event.relative * 0.001
		_rotate_camera()

func fire():
	if GlobalData.current_room != 20:
		return
	if inventory.has_arrow():
		inventory.use_arrow()
		var arrow: RigidBody3D = arrow_scene.instantiate()
		arrow.transform = camera.global_transform
		active_arrows.append(arrow)
		get_parent().add_child(arrow)


func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_vec.x * CAMERA_SENSITIVITY * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_vec.y * CAMERA_SENSITIVITY * sens_mod, -1.5, 1.5)


func _walk(delta: float):
	input_vec = Input.get_vector("left", "right", "forward", "backward")
	var forward: Vector3 = camera.global_transform.basis * Vector3(input_vec.x, 0, input_vec.y)
	var global_walk_dir: Vector3 = Vector3(forward.x, 0, forward.z).normalized()
	walk_vel = walk_vel.move_toward(global_walk_dir * MAX_SPEED * input_vec.length(), ACCEL * delta)
	return walk_vel


func _gravity(delta: float) -> Vector3:
	gravity_vel = Vector3.ZERO if is_on_floor() else gravity_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return gravity_vel


func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * JUMP_HEIGHT * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"): jumping = true
	if Input.is_action_just_pressed("exit"): get_tree().quit()
	if Input.is_action_just_pressed("toggle_mouse_capture"): toggle_mouse_capture()
	if Input.is_action_just_pressed("fire"): fire()
	velocity = _walk(delta) + _jump(delta) + _gravity(delta)
	velocity *= int(can_move)
	move_and_slide()
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.name == "Switch":
			# Janky :(
			var portal = collider.get_parent().get_parent()
			last_hovered_portal = portal
			portal.button_hover()
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				portal.close_door()
			raycast_was_colliding = true
		else:
			if raycast_was_colliding:
				last_hovered_portal.button_unhover()
				raycast_was_colliding = false
	else:
		if raycast_was_colliding:
			last_hovered_portal.button_unhover()
			raycast_was_colliding = false

func toggle_mouse_capture():
	var mode = Input.MOUSE_MODE_VISIBLE if mouse_captured else Input.MOUSE_MODE_CAPTURED
	Input.set_mouse_mode(mode)
	mouse_captured = !mouse_captured

func take_damage(n):
	inventory.take_damage(n)
