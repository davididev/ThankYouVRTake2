extends Control

var last_score = -1;

func _process(delta: float) -> void:
	if last_score != LightningChainGun.Score:
		last_score = LightningChainGun.Score;
		get_node("TextureRect/Label_Score").text = str(last_score);
