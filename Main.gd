extends Control

var versionName

export(NodePath) var dropDownPath
onready var dropDown = get_node(dropDownPath)

func _ready():
	print("Requesting Releases")
	$"Versions Request".request("https://api.github.com/repos/godotengine/godot/releases")

func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	print("Request Complete")
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
		dropDown.select(0)
		versionName = dropDown.get_item_text(0)
	else:
		push_error("JSON parsing fail")

func _on_Version_Selector_item_selected(index):
	versionName = dropDown.get_item_text(index)

func _on_Launch_Version_pressed():
	var file = File.new()
	if file.file_exists("user://%s.exe" % [versionName]):
		var output = OS.execute(ProjectSettings.globalize_path("user://%s" % [versionName]), ["-p"], true)
		print(output)
	else:
		$"Confirm Download".set_text("Are you sure you want to download %s?" % [versionName])
		$"Confirm Download".popup_centered()

func _on_ConfirmationDialog_confirmed():
	print("confirmed download")
	downloadFile(versionName)

func downloadFile(version):
	var file = File.new()
	file.open("res://versions.json", File.READ)
	var data = file.get_as_text()
	file.close()
	var jsonData = JSON.parse(data)
	
	if typeof(jsonData.result) != TYPE_ARRAY:
		push_error("json fail")
		return
	
	for i in range(jsonData.result.size()):
		if jsonData.result[i].name == version:
			var output = OS.execute('curl', [str("%s" % [jsonData.result[i].assets[20].browser_download_url]), "-L", "-O", '"', ProjectSettings.globalize_path("user://%s.exe.zip" % [version]), '"'], true, [])
			print(output)
