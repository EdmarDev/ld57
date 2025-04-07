extends CharacterBody2D
class_name Player


@export var _acceleration := 1700.0
@export var _max_speed := 850.0
@export var _drag := 1000.0
var _flipped := false
var _look_tween_duration := 0.2
var _look_tween: Tween
var _look_angle := 15
var _max_charges := 1
var _current_charges := 0

var _light_burst := load("res://player/light_burst.tscn") as PackedScene

@export var killable: Killable
@onready var _sprite := %Sprite as Sprite2D
@onready var _spit_pos := %SpitPosition as Marker2D
@onready var _spit_sfx := $SFX/Spit as AudioStreamPlayer2D
@onready var _death_sfx := $SFX/Death as AudioStreamPlayer2D
@onready var _charge_sfxs := $SFX/Charge.get_children().map(func(child): return child as AudioStreamPlayer2D)

signal charged
signal charge_depleted

func _ready():
	killable.killed.connect(_on_killed)


func _process(_delta):
	if Input.is_action_just_pressed("spit") && _current_charges > 0:
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
	_current_charges -= 1
	if _current_charges == 0:
		charge_depleted.emit()
	
	velocity = Vector2.ZERO

	var burst := _light_burst.instantiate() as Node2D
	burst.global_position = _spit_pos.global_position
	get_parent().add_child(burst)
	if _flipped:
		burst.scale.x = -1
	
	_spit_sfx.play()


func charge():
	_current_charges = min(_max_charges, _current_charges + 1)
	_charge_sfxs.pick_random().play()
	charged.emit()


func is_charged():
	return _current_charges > 0


func _on_killed():
	set_process(false)
	set_physics_process(false)
	visible = false
	_death_sfx.play()
	var timer = get_tree().create_timer(3.5)
	timer.timeout.connect(get_tree().reload_current_scene)
