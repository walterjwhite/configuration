case $_PLATFORM in
Linux | FreeBSD)
	_PLUGIN_CONFIGURATION_PATH=~/.local/share/TelegramDesktop
	_PLUGIN_CONFIGURATION_PATH_IS_DIR=1
	_PLUGIN_EXCLUDE="tdata/dictionaries tdata/emoji log.txt tdata/countries tdata/user_data tdata/shortcuts-default.json usertag"
	;;
esac
