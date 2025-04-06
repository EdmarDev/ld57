extends Node2D
class_name LightBurstDetector

const GROUP_NAME = "light_burst_detectors"

@export var _detection_range := 100.0
var _square_range := _detection_range ** 2

signal detected(pos: Vector2)

func _ready():
	add_to_group(GROUP_NAME)


func activate(pos: Vector2):
	print("Trying to detect light burst. %s, %s, %s" % [pos, global_position, pos.distance_squared_to(global_position) < _square_range])
	
	if pos.distance_squared_to(global_position) < _square_range:
		detected.emit(pos)