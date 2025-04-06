extends Node2D


@export var _player: Player
@export var _timer: Timer
@export var _ground_marker: Marker2D
@export var _spawn_range := 600.0
@export var _min_spawn_delay: float
@export var _max_spawn_delay: float

var _light_pickup := load("res://pickup/light_pickup.tscn") as PackedScene

func _ready():
	_timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
	_spawn_pickup()
	_timer.wait_time = randf_range(_min_spawn_delay, _max_spawn_delay)


func _spawn_pickup():
	var pickup := _light_pickup.instantiate() as Node2D
	add_child(pickup)
	pickup.global_position = Vector2(_player.global_position.x + randf_range(-_spawn_range, _spawn_range), _ground_marker.position.y)
