# backup user's current datagrip configuration
# @see: https://www.jetbrains.com/help/datagrip/configuring-project-and-ide-settings.html#859b82ca
_conf_datagrip_get_directory() {
	_PLUGIN_CONFIGURATION_PATH=$(find "$1" -type d -name 'DataGrip*' -maxdepth 1 2>/dev/null)
	unset _PLUGIN_CONFIGURATION_PATH

	if [ $? -gt 0 ]; then
		return
	fi

	_PLUGIN_CONFIGURATION_PATH_IS_DIR=1
	_PLUGIN_INCLUDE="keymaps workspace options"
}

case $_PLATFORM in
Windows)
	_conf_datagrip_get_directory ~/AppData
	;;
Apple)
	_conf_datagrip_get_directory ~/Library/"Application Support"/JetBrains
	;;
Linux | FreeBSD)
	_conf_datagrip_get_directory ~/.config/JetBrains
	;;
esac
