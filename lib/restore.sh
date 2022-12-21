_configure_plugin_restore() {
	_is_unsupported_platform && {
		_warn "$_CONFIGURATION_PROVIDER_NAME is unsupported on $_PLATFORM"
		return 1
	}

	if [ ! -e _APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME ]; then
		_debug "no configuration found for: $_CONFIGURATION_PROVIDER_NAME, skipping"
		return 1
	fi

	_info "restoring $_CONFIGURATION_PROVIDER_NAME on $_PLATFORM"

	_call _configure_${_CONFIGURATION_PROVIDER_NAME}_restore_pre

	_configure_restore_prepare

	_call _configure_${_CONFIGURATION_PROVIDER_NAME}_restore || _configure_restore_default
	_call _configure_${_CONFIGURATION_PROVIDER_NAME}_restore_post
}

_configure_restore_prepare() {
	# assume configuration repository is already cloned
	# assume check for configuration already complete -e intellij

	#if [ $(env | $_CONF_INSTALL_GNU_GREP -c "^${_CONFIGURATION_CLEAR_KEY}_RESTORE=") -gt 0 ]; then
	if [ -n "$_PLUGIN_CONFIGURATION_PATH_IS_DIR" ]; then
		rm -rf "$_PLUGIN_CONFIGURATION_PATH"
	else
		local plugin_parent_dir=$(dirname $_PLUGIN_CONFIGURATION_PATH)
		local plugin_filename=$(basename $_PLUGIN_CONFIGURATION_PATH)
		_PLUGIN_CONFIGURATION_PATH="$plugin_parent_dir"
		rm -f "$plugin_parent_dir/$plugin_filename"

		if [ -n "$_PLUGIN_INCLUDE" ]; then
			local plugin_file
			for plugin_file in $_PLUGIN_INCLUDE; do
				rm -f "$plugin_parent_dir/$plugin_file"
			done
		fi
	fi

	mkdir -p "$_PLUGIN_CONFIGURATION_PATH"
}

_configure_restore_default() {
	tar -cp $_TAR_ARGS -C _APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME . | tar -xp $_TAR_ARGS -C "$_PLUGIN_CONFIGURATION_PATH"
}

_configure_plugin_restore_sync() {
	:
}
