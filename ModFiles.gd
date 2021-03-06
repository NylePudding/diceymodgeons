extends Node

enum Origin {
	GAME,
	MOD
}

var game_root_path = ""
var mod_root_path = ""

var loaded_files:Dictionary = {}

func _init():
	game_root_path = "res://test"
	mod_root_path = "mods/garfield"
	
func get_mod_path(file_path:String = ""):
	return '%s/%s/%s' % [game_root_path, mod_root_path, file_path]
	
func get_game_path(file_path:String = ""):
	var extra_path = ""
	if OS.get_name() == "OSX":
		extra_path = "diceydungeons.app/Contents/Resources"
	return '%s/%s/%s' % [game_root_path, extra_path, file_path]
	
func get_file_as_text(file_path:String):
	var file = _get_file(file_path)
	if file:
		var result = file.file.get_as_text()
		file.file.close()
		var r = {"text": result, "path": file.path, "origin": file.origin, "changed_text": result}
		loaded_files[file.path] = r
		return r
	
	return null
	
func files_need_save():
	for key in loaded_files:
		var file = loaded_files[key]
		if _file_needs_save(file):
			return true
	return false
	
func save_files():
	for key in loaded_files:
		var obj = loaded_files[key]
		if not _file_needs_save(obj): continue
		var path = obj.path
		if obj.origin == Origin.GAME:
			var fname = path.get_file()
			path = get_mod_path("data/text/generators/%s" % fname)
		
		var file = File.new()
		if file.open(path, File.WRITE) == OK:
			file.store_string(obj.changed_text)
			file.close()
			obj.text = obj.changed_text
		
		
func _file_needs_save(file):
	return file.text.hash() != file.changed_text.hash()
	
func _get_file(file_path:String):
	var mod_path = get_mod_path(file_path)
	var game_path = get_game_path(file_path)
	
	var file := File.new()
	if file.open(mod_path, File.READ) == OK:
		return {"file": file, "path": mod_path, "origin": Origin.MOD}
	elif file.open(game_path, File.READ) == OK:
		return {"file": file, "path": game_path, "origin": Origin.GAME}
	
	return null
