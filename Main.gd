extends Control

var versionName

export(NodePath) var dropDownPath
onready var dropDown = get_node(dropDownPath)

func _ready():
	print("requesting releases")
	$"Versions Request".request("https://api.github.com/repos/godotengine/godot/releases")

func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	print("requests complete")
	if response_code != 200:
		push_error("Unable to get JSON data error %d" % [response_code])
		return
	var jsonData = JSON.parse(body.get_string_from_utf8())
	
	if typeof(jsonData.result) == TYPE_ARRAY:
		var file = File.new()
		file.open("res://versions.json", File.WRITE)
		file.store_string(JSON.print(jsonData.result))
		file.close()
		
		for i in jsonData.result.size():
			dropDown.add_item(jsonData.result[i].name)
	else:
		push_error("JSON parsing fail")

func _on_Version_Selector_item_selected(index):
	print(index)
	print(dropDown.get_item_text(index))
	versionName = dropDown.get_item_text(index)

func _on_Launch_Version_pressed():
	var file = File.new()
	if file.file_exists("user://%s.exe" % [versionName]):
		var _output = OS.execute("user://%s.exe" % [versionName], [])
	else:
		$"Confirm Download".set_text("Are you sure you want to download %s?" % [versionName])
		$"Confirm Download".popup_centered()


func _on_ConfirmationDialog_confirmed():
	print("confirmed download")
	$"Version Download".request("https://api.github.com/repos/godotengine/godot/releases/%s" % [versionName])


func _on_Version_Download_request_completed(_result, response_code, _headers, body):
	print(body)
