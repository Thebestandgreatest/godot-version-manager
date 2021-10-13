curl -s https://api.github.com/repos/godotengine/godot/releases/latest \
| grep "browser_download_url.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| curl -qi -