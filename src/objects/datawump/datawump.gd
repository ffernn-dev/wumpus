@tool
extends CharacterBody3D

enum STATE {DISABLE, IDLE, TARGET_PLAYER, ATTACK, DEAD}

@export var state: STATE = STATE.IDLE
var prev_state: STATE
var disabled = false
var health = 7

@export var speed = 4.0

@onready var attack_cooldown := $AttackCooldown
@onready var animator: AnimationTree = $AnimationTree

func disable():
	hide()
	self.position.y = -100 # hack to avoid loading/unloading him
	disabled = true
	state = STATE.DISABLE
	animator.set("parameters/Reset/blend_amount", 1)

func enable():
	show()
	self.position.y = 0
	disabled = false
	state = STATE.IDLE
	animator.set("parameters/Reset/blend_amount", 0)

func end_of_attack():
	state = STATE.IDLE
	attack_cooldown.wait_time = 0.5
	attack_cooldown.start()

func _ready():
	disable()

func _process(delta):
	var player_exists := get_node_or_null("%Player") != null
	if player_exists and !disabled:
		if %Player.position.distance_to(self.position) > 2.4:
			state = STATE.TARGET_PLAYER
			var forward = -global_transform.basis.z.normalized()
			forward.y = 0  # Ignore the y component to keep movement horizontal
			velocity = forward * speed
		else:
			if attack_cooldown.time_left == 0:
				state = STATE.ATTACK
				velocity = Vector3.ZERO
	
	match state:
		STATE.DISABLE:
			return
		STATE.DEAD:
			return
		STATE.TARGET_PLAYER:
			if prev_state != state:
				var tween = get_tree().create_tween()
				tween.tween_property(animator, "parameters/Walk/blend_amount", 1, 0.3)
			if player_exists:
				look_at(%Player.position * Vector3(1, 0, 1))
		STATE.IDLE:
			if prev_state != state:
				var tween = get_tree().create_tween()
				tween.tween_property(animator, "parameters/Walk/blend_amount", 0, 0.3)
		STATE.ATTACK:
			if prev_state != state:
				animator.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
	move_and_slide()
	prev_state = state

func take_damage(n: int):
	health -= n
	if health <= 0:
		die()

func die():
	disabled = true
	state = STATE.DEAD
	animator.set("parameters/Die/blend_amount", 1)

func die_anim_finish():
	get_parent().end_game(GlobalData.WIN)

func _on_bat_body_entered(body):
	if body is Player:
		body.take_damage(1)
