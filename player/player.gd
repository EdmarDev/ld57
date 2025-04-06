extends CharacterBody2D

var _acceleration := 1700.0
var _max_speed := 850.0
var _drag := 1000.0
var _flipped := false
var _look_tween_duration := 0.2
var _look_tween: Tween
var _look_angle := 15

var _light_burst := load("res://player/light_burst.tscn") as PackedScene

@onready var _sprite := %Sprite as Sprite2D
@onready var _spit_pos := %SpitPosition as Marker2D

func _process(_delta):
	if Input.is_action_just_pressed("spit"):
		_spit_light()


func _physics_process(delta: float):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity += direction * (_acceleration * delta)

	if velocity.length() > 0:
		var drag_vec = velocity.normalized() * _drag * delta
		if drag_vec.length() > velocity.length():
			velocity = Vector2.ZERO
		else:
			velocity -= drag_vec

	velocity = velocity.limit_length(_max_speed)
	
	if direction.x < 0 and !_flipped:
		self.transform.x *= -1
		_flipped = true
	elif direction.x > 0 and _flipped:
		self.transform.x *= -1
		_flipped = false
	
	if direction.y < 0:
		_tween_look_at(-_look_angle)
	elif direction.y > 0:
		_tween_look_at(_look_angle)
	else:
		_tween_look_at(0)
	
	move_and_slide()


func _tween_look_at(angle: float):
	if !!_look_tween:
			_look_tween.kill()
	_look_tween = create_tween()
	_look_tween.tween_property(_sprite, "rotation", deg_to_rad(angle), _look_tween_duration)


func _spit_light():
	var burst := _light_burst.instantiate() as Node2D
	get_parent().add_child(burst)
	burst.global_position = _spit_pos.global_position
	if _flipped:
		burst.scale.x = -1
	velocity = Vector2.ZERO
