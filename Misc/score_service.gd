extends Node

const ScoreFilePath := "user://scores.json"


func load_scores() -> Array:
	DebugService.info("Loading scores...")
	var file := File.new()

	if not file.file_exists(ScoreFilePath):
		DebugService.warning("No score file to load")
		return []

	if file.open(ScoreFilePath, File.READ) != OK:
		DebugService.error("Can't open file '%s' in READ mode" % ScoreFilePath)
		return []
	
	var data = parse_json(file.get_as_text())
	DebugService.info("Loaded %s" % data)
	
	file.close()
	return data["scores"]


func save_scores(scores: Array) -> void:
	DebugService.debug("Saving scores...")
	var file := File.new()

	if file.open(ScoreFilePath, File.WRITE) != OK:
		DebugService.error("Can't open file '%s' in WRITE mode" % ScoreFilePath)
		return
	
	var data = to_json({ "scores": scores })
	file.store_string(data)
	DebugService.debug("%s" % data)
	
	file.close()
