_PLUGIN_CONFIGURATION_PATH=~/.config/mac/defaults

_configure_mac_defaults_restore() {
	if [ ! -e $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/defaults ]; then
		return
	fi

	. $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/defaults

	_SCREENSAVER_NAME="tell application \"System Events\" to set current screen saver to screen saver \"$_CONF_MAC_SCREENSAVER_NAME\""
	_SCREENSAVER_TIMEOUT="tell application \"System Events\" to set delay interval of screen saver preferences to $_CONF_MAC_SCREENSAVER_TIMEOUT -- Number In Seconds"

	osascript -e "$_SCREENSAVER_NAME" -e "$_SCREENSAVER_TIMEOUT"
}
