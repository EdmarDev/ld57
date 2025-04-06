extends VisibleOnScreenNotifier2D
class_name VisibilityDespawner

@export var _minimum_time := 2.0

var _timer: Timer


func _ready():
	set_process(false)
	_timer = Timer.new()
	add_child(_timer)
	_timer.wait_time = _minimum_time
	_timer.timeout.connect(set_process.bind(true))
	_timer.start()


func _process(_delta):
	if !is_on_screen():
		get_parent().queue_free()