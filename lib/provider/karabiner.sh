# backup user's current karabiner-elements configuration
case $_PLATFORM in
Apple)
	_PLUGIN_CONFIGURATION_PATH=~/.config/karabiner
	_PLUGIN_CONFIGURATION_PATH_IS_DIR=1
	_PLUGIN_INCLUDE="assets/complex_modifications/*.json karabiner.json"
	;;
esac
