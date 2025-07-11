class_name HannahMusicController extends Node3D

signal Song1;
signal Song2;
signal Song3;

@export var StartingDialogue : DialogueGrid;
@export var TargetLeftPrefab : PackedScene;
@export var TargetRightPrefab : PackedScene;
@export var TargetMinePrefab : PackedScene;
@export var TargetShatterLeftPrefab : PackedScene;
@export var TargetShatterRightPrefab : PackedScene;
@export var TargetShatterMinePrefab : PackedScene;
static var HitTargets = 0;
static var TotalTargets = 0;
static var SongStr = 0;
@export var LeftGun : NodePath;
@export var RightGun : NodePath;

static var isPlaying = false;

@onready var song1_res = preload("res://Mine/Models/Hannah/song1.res");
@onready var song2_res = preload("res://Mine/Models/Hannah/song2.res");
@onready var song3_res = preload("res://Mine/Models/Hannah/song3.res");
var CurrentSong : BeatList;

var songNode : AudioStreamPlayer3D;

func _ready() -> void:
	awaiting_start_song = false;
	get_node(LeftGun).call("SetVisible", false);
	get_node(RightGun).call("SetVisible", false);
	isPlaying = false;
	Node3DPool.InitPoolItem(get_tree(), "Target1", TargetLeftPrefab, 10);
	Node3DPool.InitPoolItem(get_tree(), "Target2", TargetRightPrefab, 10);
	Node3DPool.InitPoolItem(get_tree(), "Target3", TargetMinePrefab, 10);
	Node3DPool.InitPoolItem(get_tree(), "Explosion1", TargetShatterLeftPrefab, 12);
	Node3DPool.InitPoolItem(get_tree(), "Explosion2", TargetShatterRightPrefab, 12);
	Node3DPool.InitPoolItem(get_tree(), "Explosion3", TargetShatterMinePrefab, 12);
	
	songNode = get_node("AudioStreamPlayer3D");
var lastKeyframeID = -1;
var currentPointInSong = 0.0;
var lastPaused = true;

var firstPlayingStep = true;
func _process(delta: float) -> void:
	if isPlaying == false and DialogueHandler.IsRunning == false and awaiting_start_song == false:
		get_node(LeftGun).call("SetVisible", false);
		get_node(RightGun).call("SetVisible", false);
		DialogueHandler.Instance.StartDialogue(StartingDialogue);
		firstPlayingStep = true;
		return;
	
	if isPlaying == true:
		if firstPlayingStep == true:
			get_node(LeftGun).call("Reset");
			get_node(RightGun).call("Reset");
			firstPlayingStep = false;
		#if Engine.time_scale < 0.5:
		#	lastPaused = true;
		#	songNode.stop();
		#	return;
		#if lastPaused and Engine.time_scale > 0.5:
		#	songNode.play(currentPointInSong);
		#	lastPaused = false;
		songNode.stream_paused = (Engine.time_scale < 0.5);  #Only pause it while the game is paused
		if songNode.playing == false and Engine.time_scale > 0.5:
			isPlaying = false;
			DialogueHandler.IsRunning = false;
			awaiting_start_song = false;
			lastPaused = false;
			return;
		currentPointInSong = songNode.get_playback_position();
		var correctedPoint = currentPointInSong - HannahTarget.SCALE_TOTAL_TIME;
		if correctedPoint < 0.0:
			correctedPoint = 0.0;
		var newID = CurrentSong.GetNextKeyframeID(currentPointInSong);
		if newID != lastKeyframeID:
			
			var nextBeat = CurrentSong.Beats[newID];
			if (currentPointInSong) >= (nextBeat.BTime - HannahTarget.SCALE_TOTAL_TIME):
				CreateTargets(nextBeat);
				lastKeyframeID = newID;

func CreateTargets(bs : BeatEntry):
	for i in range(0, bs.Targets.size()):
		var originPt = get_node(str("TargetOrigin", i));
		var tkey = ""
		if bs.Targets[i] == 1:  #Left hand
			tkey = "Target1";
		if bs.Targets[i] == 2:  #Right hand
			tkey = "Target2";
		if bs.Targets[i] == 3:  #Mine
			tkey = "Target3";
		
		if !tkey.is_empty():
			var inst = Node3DPool.GetInstance(tkey);
			inst.position = originPt.global_position;
			inst.rotation_degrees = originPt.global_rotation_degrees;
	
var awaiting_start_song = false;
func StartSong(id : int):
	lastPaused = false;
	currentPointInSong = 0.0;
	awaiting_start_song = false;
	lastKeyframeID = -1;
	HitTargets = 0;
	TotalTargets = 0;
	var songPath = "";
	if id == 1:
		CurrentSong = song1_res;
		SongStr = "Engage the Maya"
		#PlayMusic.PlaySong("Engage the Maya.mp3");
		songPath = "res://Audio/Music/Engage the Maya.mp3";
	if id == 2:
		SongStr = "One More Time"
		CurrentSong = song2_res;
		#PlayMusic.PlaySong("One More Time.mp3");
		songPath = "res://Audio/Music/One More Time.mp3";
	if id == 3:
		CurrentSong = song3_res;
		SongStr = "The Hungry Cat"
		#PlayMusic.PlaySong("The Hungry Cat.mp3");
		songPath = "res://Audio/Music/The Hungry Cat.mp3";


	HannahScoreCanvas.Update = true;
	songNode.stream = load(songPath);
	
	get_node(LeftGun).call("Reset");
	get_node(RightGun).call("Reset");
	awaiting_start_song = true;
	await get_tree().create_timer(1.0).timeout;
	awaiting_start_song = false;
	songNode.play();
	isPlaying = true;


func _on_song_1() -> void:
	StartSong(1);


func _on_song_2() -> void:
	StartSong(2);


func _on_song_3() -> void:
	StartSong(3);
