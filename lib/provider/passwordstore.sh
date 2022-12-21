_PLUGIN_CONFIGURATION_PATH=~/.password-store
_PLUGIN_CONFIGURATION_PATH_IS_DIR=1

_configure_plugin_backup_passwordstore() {
	if [ ! -e $_PLUGIN_CONFIGURATION_PATH/.git ]; then
		_PLUGIN_INCLUDE=".gpg-id"
		return 1
	fi

	if [ $(git -C $_PLUGIN_CONFIGURATION_PATH remote -v | wc -l) -eq 0 ]; then
		_warn "No git remotes exist"
		return 1
	fi

	# clear existing backup
	rm -rf "_APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME"
	mkdir -p _APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME

	# record the location of the git repository
	git -C $_PLUGIN_CONFIGURATION_PATH remote -v >_APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME/.git
}

_configure_plugin_restore_passwordstore() {
	if [ ! -e _APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME/.git ]; then
		return 1
	fi

	if [ ! -e $_PLUGIN_CONFIGURATION_PATH/.git ]; then
		return 1
	fi

	_continue_if "$_PLUGIN_CONFIGURATION_PATH/.git exists, delete?" "Y/n" || {
		_warn "Not deleting $_PLUGIN_CONFIGURATION_PATH/.git"
		return 0
	}

	rm -rf $_PLUGIN_CONFIGURATION_PATH
	git clone $(head -1 _APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME/.git | awk {'print$2'}) $_PLUGIN_CONFIGURATION_PATH
}
