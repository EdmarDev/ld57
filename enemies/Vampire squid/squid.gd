extends Node2D
class_name Squid


@export var _light_burst_detector: LightBurstDetector
@export var _max_y := 100.0

var _speed := randf_range(50, 150)
var direction := Vector2.DOWN

func _ready():
	_light_burst_detector.detected.connect(_on_light_burst_detected)

func _physics_process(delta):
	if global_position.y > _max_y and direction.y > 0:
		direction = - direction

	var velocity = direction * _speed
	translate(velocity * delta)


func _on_light_burst_detected(pos: Vector2):
	direction = (global_position - pos).normalized()
