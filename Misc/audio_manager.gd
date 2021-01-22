extends Node


signal effect_finished(name)

const VolumeFilePath := "user://settings.json"


var music_volume := 0.8 setget set_music_volume
var effects_volume := 0.8  setget set_effects_volume

onready var effects := {
	"hover": $Effects/Hover,
	"select": $Effects/Select,
	"explosion": $Effects/Explosion,
	"tower_explosion": $Effects/TowerExplosion,
}

onready var base_volumes = _get_base_volumes()
onready var base_music_volume = $MusicPlayer.volume_db


func _ready() -> void:
	load_volumes()
	
	for key in effects.keys():
		var effect: AudioStreamPlayer = effects[key]
		assert(effect.connect("finished", self, "_on_Effect_finished", [key]) == OK)


func play_music() -> void:
	$MusicPlayer.play()

func stop_music() -> void:
	$MusicPlayer.stop()


func play_effect(name: String) -> void:
	if not effects.has(name):
		DebugService.error("Can't play sound effect '%s'" % name)
		return
	
	var player: AudioStreamPlayer = effects[name]
	player.play()
	DebugService.info("Playing effect %s" % name)
	yield(player, "finished")


func load_volumes() -> void:
	DebugService.info("Loading volume info...")
	var file := File.new()

	if not file.file_exists(VolumeFilePath):
		DebugService.warning("No volume file to load")
		return

	if file.open(VolumeFilePath, File.READ) != OK:
		DebugService.error("Can't open file '%s' in READ mode" % VolumeFilePath)
		return
	
	var data = parse_json(file.get_line())
	self.music_volume = data["music"]
	self.effects_volume = data["effects"]
	DebugService.info("Loaded %s" % data)
	
	file.close()


func save_volumes() -> void:
	DebugService.debug("Saving volume info...")
	var file := File.new()

	if file.open(VolumeFilePath, File.WRITE) != OK:
		DebugService.error("Can't open file '%s' in WRITE mode" % VolumeFilePath)
		return
	
	var data = to_json({ "music": music_volume, "effects": effects_volume })
	file.store_line(data)
	DebugService.debug("%s" % data)
	
	file.close()


func set_music_volume(value: float) -> void:
	music_volume = value
	$MusicPlayer.volume_db = _volume_percent_as_db(base_music_volume, value)
	save_volumes()


func set_effects_volume(value: float) -> void:
	effects_volume = value
	for key in effects.keys():
		var player = effects[key]
		player.volume_db = _volume_percent_as_db(base_volumes[key], value)
	save_volumes()


func _volume_percent_as_db(base: float, percentage: float) -> float:
	if percentage == 0:
		DebugService.info("Volume at 0%. Returning -80 dB")
		return -80.0
	return 60.0 * percentage - 40.0 + base


func _get_base_volumes() -> Dictionary:
	var dict = Dictionary()
	
	for key in effects.keys():
		var volume = effects[key].volume_db
		dict[key] = volume
	
	return dict


func _on_Effect_finished(name: String) -> void:
	emit_signal("effect_finished", name)
