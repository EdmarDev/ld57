extends Node2D


func _ready():
	print(self.global_position)
	get_tree().call_group(LightBurstDetector.GROUP_NAME, "activate", self.global_position)
