_configure_backup() {
	_TAR_CD='-C'
	if [ ! -d "$_PLUGIN_CONFIGURATION_PATH" ]; then
		if [ ! -e "$_PLUGIN_CONFIGURATION_PATH" ]; then
			_warn ""$_PLUGIN_CONFIGURATION_PATH" does not exist"
			return 1
		fi

		_TAR_CD="-C $(dirname "$_PLUGIN_CONFIGURATION_PATH")"
		_PLUGIN_CONFIGURATION_PATH=$(basename "$_PLUGIN_CONFIGURATION_PATH")
	else
		if [ -z "$_PLUGIN_INCLUDE" ]; then
			_PLUGIN_INCLUDE='.'
		fi
	fi
}

_configure_backup_post() {
	git add "$_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME"
}

_configure_backup_prepare() {
	rm -rf "$_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME"
	mkdir -p "$_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME"
}

_configure_backup_default() {
	local tar_exclude=""
	if [ -n "$_PLUGIN_EXCLUDE" ]; then
		tar_exclude=$(printf '%s' "$_PLUGIN_EXCLUDE" | sed -e 's/ / --exclude /g' -e 's/^/--exclude /')
	fi

	tar -cp $_TAR_ARGS $_TAR_CD "$_PLUGIN_CONFIGURATION_PATH" $tar_exclude $_PLUGIN_INCLUDE 2>/dev/null | tar -xp $_TAR_ARGS -C "$_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME"
	unset _TAR_CD
}

_configure_backup_sync() {
	git status >/dev/null 2>&1 || {
		_warn "Git Configuration repository not setup for $USER"
		return 1
	}

	if [ $(git remote -v | wc -l) -eq 0 ]; then
		_warn "No remotes setup"
		return 1
	fi

	gd && _continue_if "Continue synchronizing contents?" "Y/n" && {
		gcommit -am 'sync'
		gpush
	}
}
