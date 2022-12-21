_configure_plugin_backup() {
	_is_unsupported_platform && return

	local tar_cd='-C'
	if [ ! -d "$_PLUGIN_CONFIGURATION_PATH" ]; then
		if [ ! -e "$_PLUGIN_CONFIGURATION_PATH" ]; then
			_warn "$_PLUGIN_CONFIGURATION_PATH does not exist, skipping"
			return 1
		fi

		tar_cd="-C $(dirname $_PLUGIN_CONFIGURATION_PATH)"
		_PLUGIN_CONFIGURATION_PATH=$(basename $_PLUGIN_CONFIGURATION_PATH)
	else
		if [ -z "$_PLUGIN_INCLUDE" ]; then
			_PLUGIN_INCLUDE='.'
		fi
	fi

	# clear existing backup
	rm -rf "_APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME"
	mkdir -p _APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME

	local tar_exclude=""
	if [ -n "$_PLUGIN_EXCLUDE" ]; then
		tar_exclude=$(printf '%s' "$_PLUGIN_EXCLUDE" | sed -e 's/ / --exclude /g' | sed -e 's/^/--exclude /')
	fi

	type _configure_${_CONFIGURATION_PROVIDER_NAME}_backup >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		_configure_${_CONFIGURATION_PROVIDER_NAME}_backup
	else
		_info "Backing up $_CONFIGURATION_PROVIDER_NAME"

		tar -cp $_TAR_ARGS $tar_cd "$_PLUGIN_CONFIGURATION_PATH" $tar_exclude $_PLUGIN_INCLUDE 2>/dev/null | tar -xp $_TAR_ARGS -C "_APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME"
	fi

	git add "_APPLICATION_DATA_PATH_/$_CONFIGURATION_PROVIDER_NAME"
}

_configure_plugin_backup_sync() {
	_configure_sync_configuration_workspace
}
