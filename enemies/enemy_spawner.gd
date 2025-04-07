extends Node2D


@export var _player: Player
@export var _spawn_min_range := 500.0
@export var _spawn_max_range := 600.0
@export var _min_spawn_delay: float
@export var _max_spawn_delay: float
@export var _high_marker: Marker2D
@export var _low_marker: Marker2D
@export var _enemy_scene: PackedScene

var _timer: Timer

func _ready():
	_timer = Timer.new()
	add_child(_timer)
	_timer.wait_time = _min_spawn_delay
	_timer.timeout.connect(_on_timer_timeout)
	_timer.start()


func _on_timer_timeout():
	_spawn_enemy()
	_timer.wait_time = randf_range(_min_spawn_delay, _max_spawn_delay)


func _spawn_enemy():
	var enemy := _enemy_scene.instantiate() as Node2D
	var spawn_side = [1, -1].pick_random()
	var spawn_x = _player.global_position.x + (randf_range(_spawn_min_range, _spawn_max_range) * spawn_side)
	var spawn_y = randf_range(_low_marker.position.y, _high_marker.position.y)

	if enemy is Enemy:
		enemy.face_direction(-spawn_side)
	add_child(enemy)
	enemy.global_position = Vector2(spawn_x, spawn_y)
