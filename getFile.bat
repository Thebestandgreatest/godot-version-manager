set jsondata=curl -s https://api.github.com/repos/godotengine/godot/releases
grep "browser_download_url.*win64.exe.zip"
cut -d : -f 2,3
tr -d \" \
curl -qi-