extends Area2D


func _ready():
	body_entered.connect(_try_kill)
	area_entered.connect(_try_kill)


func _try_kill(node: Node):
	var killable := node.get_node_or_null(Killable.COMPONENT_NAME) as Killable
	if !killable:
		return
	killable.kill()
