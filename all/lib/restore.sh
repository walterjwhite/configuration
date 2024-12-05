_configure_restore() {
	if [ ! -e $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME ]; then
		_debug "no configuration found"
		return 1
	fi
}

_configure_restore_prepare() {
	_call _configure_${_EXTENSION_FUNCTION_NAME}_clear || _configure_clear_default

	if [ -n "$_PLUGIN_CONFIGURATION_PATH_IS_DIR" ]; then
		if [ -z "$_PLUGIN_CONFIGURATION_PATH_IS_SKIP_PREPARE" ]; then
			mkdir -p "$_PLUGIN_CONFIGURATION_PATH"
		fi

		return
	fi

	local plugin_parent_dir=$(dirname "$_PLUGIN_CONFIGURATION_PATH")
	local plugin_filename=$(basename "$_PLUGIN_CONFIGURATION_PATH")
	mkdir -p $plugin_parent_dir

	_PLUGIN_CONFIGURATION_PATH="$plugin_parent_dir"
}

_configure_restore_default() {
	tar -cp $_TAR_ARGS -C $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME . | tar -xp $_TAR_ARGS -C "$_PLUGIN_CONFIGURATION_PATH"
}

_configure_restore_sync() {
	:
}
