extends Node


@export var _enemy: Enemy
@export var _light_burst_detector: LightBurstDetector
@export var _speed := 80.0
@export var _angle_variation := 30.0

var _direction: Vector2

func _ready():
	_direction = Vector2.RIGHT * _enemy.facing_direction
	_direction = _direction.rotated(deg_to_rad(randf_range(-_angle_variation, _angle_variation)))
	_light_burst_detector.detected.connect(_on_light_burst_detected)


func _physics_process(_delta):
	_enemy.velocity = _direction * _speed


func _on_light_burst_detected(pos: Vector2):
	var burst_dir = sign(pos.x - _enemy.global_position.x)
	if burst_dir == _enemy.facing_direction:
		_direction.x *= -1
		_enemy.face_direction(-_enemy.facing_direction)
