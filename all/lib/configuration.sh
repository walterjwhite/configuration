import git:git/include.sh
conf git

_config_init() {
	_config_init_settings

	_configure $_CONF_INSTALL_CONFIG_PATH/git
	_git_init
	cd $_PROJECT_PATH
}

_config_init_settings() {
	_PROJECT_PATH=$_CONF_INSTALL_APPLICATION_DATA_PATH
	_SYSTEM=$(head -1 /usr/local/etc/walterjwhite/system 2>/dev/null)

	if [ -n "$_SYSTEM" ]; then
		_PROJECT=data/$_SYSTEM/$USER/$_APPLICATION_NAME
	else
		_PROJECT=data-$_APPLICATION_NAME
	fi
}

_is_unsupported_platform() {
	if [ -z "$_PLUGIN_CONFIGURATION_PATH" ]; then
		return 0
	fi

	return 1
}

_configure_action() {
	_is_unsupported_platform && {
		_warn "unsupported on $_PLATFORM"
		return 1
	}

	_configure_$_ACTION || return 1

	_info "$_ACTION"

	_call _configure_${_EXTENSION_FUNCTION_NAME}_${_ACTION}_pre
	_configure_${_ACTION}_prepare

	_call _configure_${_EXTENSION_FUNCTION_NAME}_${_ACTION} || _configure_${_ACTION}_default
	_call _configure_${_EXTENSION_FUNCTION_NAME}_${_ACTION}_post
	_call _configure_${_ACTION}_post
}
