# backup user's current intellij configuration
# @see: https://www.jetbrains.com/help/idea/configuring-project-and-ide-settings.html#5d73c32d
_conf_intellij_get_directory() {
	_PLUGIN_CONFIGURATION_PATH=$(find "$1" -type d -iname 'IntelliJ*' -maxdepth 1 2>/dev/null)
	unset _PLUGIN_CONFIGURATION_PATH

	if [ $? -gt 0 ]; then
		return
	fi

	_PLUGIN_CONFIGURATION_PATH_IS_DIR=1
	_PLUGIN_INCLUDE="keymaps options/$(printf '%s' $_PLATFORM | tr '[:upper:]' '[:lower:]')"
}

case $_PLATFORM in
Windows)
	_conf_intellij_get_directory ~/AppData
	;;
Apple)
	_conf_intellij_get_directory ~/Library/"Application Support"/JetBrains
	;;
Linux | FreeBSD)
	_conf_intellij_get_directory ~/.config/JetBrains
	;;
esac
