class_name OverlayUI extends Control

static var CurrentSubtitle : String;
#@export var subtitleRef : NodePath;

var refresh_time_timer = 0.0;
static var overlayAlpha : Color;
static var overlayTexture : Texture2D;
static var overlayPerSecond = 2.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_time_timer = 0.0;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("Subtitle").text = CurrentSubtitle;
	RefreshTime(delta);
	if overlayTexture != null:
		overlayAlpha.a = move_toward(overlayAlpha.a, 0.0, overlayPerSecond * delta)
		var c = get_node("OverlayRect").modulate as Color;
		c.a = overlayAlpha;	
		get_node("OverlayRect").modulate = c;
		if is_zero_approx(overlayAlpha.a):
			overlayTexture = null;
	
static func SetOverlayImage(tex : Texture2D, col : Color = Color.WHITE, time : float = 2.0):
	overlayTexture = tex;
	overlayAlpha = col;
	overlayPerSecond = time;
	
func RefreshTime(delta: float):
	refresh_time_timer -= delta;
	if refresh_time_timer <= 0.0:
		var today = Time.get_datetime_dict_from_system();
		var hour = today.hour;
		if hour >= 12:  #More than 12 PM
			hour -= 12;
		var is_pm = today.hour >= 12;
		var minuteStr = str(today.minute);
		if today.minute < 10:
			minuteStr = "0" + minuteStr;
		
		if hour == 0:  #12 PM or 12 AM
			if is_pm:
				get_node("Time Label").text = str(12, ":", minuteStr, "PM");
			else:
				get_node("Time Label").text = str(12, ":", minuteStr, "AM");
		else:
			if is_pm:
				get_node("Time Label").text = str(hour, ":", minuteStr, "PM");
			else:
				get_node("Time Label").text = str(hour, ":", minuteStr, "AM");
