extends Node2D


@export var _player: Player
@export var _spawn_min_range := 500.0
@export var _spawn_max_range := 600.0
@export var _min_spawn_delay: float
@export var _max_spawn_delay: float
@export var _target_offset_range := 50

var _squid_scene := load("res://enemies/Vampire squid/squid.tscn")

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
	var squid := _squid_scene.instantiate() as Squid
	var radius := randf_range(_spawn_min_range, _spawn_max_range)
	var angle := randf() * TAU

	var spawn_pos := _player.global_position + Vector2(cos(angle), sin(angle)) * radius
	if spawn_pos.y > _player.global_position.y:
		spawn_pos.y = _player.global_position.y - (spawn_pos.y - _player.global_position.y)

	add_child(squid)
	squid.global_position = spawn_pos
	squid.direction = (_player.global_position + Vector2(randf_range(-_target_offset_range, _target_offset_range),
			randf_range(-_target_offset_range, _target_offset_range)) - spawn_pos).normalized()
