class_name HannahScoreCanvas extends Control

static var Update = false;

func _process(delta: float) -> void:
	get_node("TextureRect/LabelSongName").visible = HannahMusicController.isPlaying;
	get_node("TextureRect/LabelAccuracy").visible = HannahMusicController.isPlaying;
	if HannahMusicController.isPlaying:
		if Update == true:
			get_node("TextureRect/LabelSongName").text = HannahMusicController.SongStr;
			if HannahMusicController.TotalTargets == 0:
				get_node("TextureRect/LabelAccuracy").text = "100%";
			else:
				var perc = HannahMusicController.HitTargets * 100 / HannahMusicController.TotalTargets;
				get_node("TextureRect/LabelAccuracy").text = str(perc, "%")
				
			Update = false;
