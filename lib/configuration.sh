. _LIBRARY_PATH_/git/include.sh

_PROJECT_PATH=_APPLICATION_DATA_PATH_
_SYSTEM=$(head -1 /usr/local/etc/walterjwhite/system 2>/dev/null)

_PROJECT=data/$_SYSTEM/$USER/_APPLICATION_NAME_

_git_init
cd $_PROJECT_PATH

_is_unsupported_platform() {
	if [ -z "$_PLUGIN_CONFIGURATION_PATH" ]; then
		_debug "$_CONFIGURATION_PROVIDER_NAME - Unsupported platform: $_PLATFORM"
		return 0
	fi

	return 1
}

_configure_sync_configuration_workspace() {
	git status >/dev/null 2>&1 || {
		_warn "Git Configuration repository not setup for $USER"
		return 1
	}

	if [ $(git remote -v | wc -l) -eq 0 ]; then
		_warn "No remotes setup"
		return 1
	fi

	gd
	_continue_if "Continue synchronizing contents?" "Y/n" && {
		gcommit -am 'sync'
		gpush
	}
}
