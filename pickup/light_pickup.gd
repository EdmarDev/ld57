extends Area2D


var _floating_speed := randf_range(20, 100)
var _sway_distance := randf_range(-75, 75)
var _sway_duration := randf_range(0.5, 2.0)
var _sway_vector := Vector2.ZERO
var _tween: Tween

func _ready():
	_tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(self, "_sway_vector", Vector2.RIGHT * _sway_distance, _sway_duration)
	_tween.tween_property(self, "_sway_vector", Vector2.LEFT * _sway_distance, _sway_duration)
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float):
	var velocity = (Vector2.UP * _floating_speed * delta) + (_sway_vector * delta)
	translate(velocity)


func _on_body_entered(body: Node2D):
	if body is Player:
		(body as Player).charge()
		queue_free()
