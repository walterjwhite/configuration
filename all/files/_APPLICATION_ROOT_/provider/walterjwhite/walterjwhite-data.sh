import git:git/synced.sh

_PLUGIN_CONFIGURATION_PATH=~/.data
_PLUGIN_CONFIGURATION_PATH_IS_DIR=1

_PLUGIN_CONFIGURATION_PATH_IS_SKIP_PREPARE=1

_configure_walterjwhite_data_clear() {
	local opwd=$PWD

	local data_project is_clean
	for data_project in $(find "$_PLUGIN_CONFIGURATION_PATH" -depth 2 -type d -name .git | sed -e 's/\/.git//' -e 's/\.\///' | sort -u); do
		cd $data_project
		_git_has_uncommitted_work || {
			_warn "$data_project is dirty"
			is_clean=1
		}

		local branch_name=$(gcb)
		[ -z "$branch_name" ] && branch_name=master

		_git_synced_with_remote $branch_name || {
			_warn "$data_project is not synced with remote"
			is_clean=1
		}

		cd "$_PLUGIN_CONFIGURATION_PATH"
	done

	[ -n "$is_clean" ] && [ $is_clean -eq 1 ] && {
		local log_function=_error
		[ -n "$_WARN_ON_ERROR" ] && log_function=_warn

		$log_function "see above warnings"
	}

	find ~/.data -type d ! -name configuration ! -name console -depth 1 -exec rm -rf {} +
}

_configure_walterjwhite_data_restore() {
	[ ! -e $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/applications ] && return 1

	local data_application
	while read data_application; do
		if [ -e ~/.data/$data_application ]; then
			_warn "Data Application: $data_application already exists"
			continue
		fi

		gclone data/$_SYSTEM/$USER/$data_application
	done <$_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/applications
}

_configure_walterjwhite_data_backup() {
	rm -f $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/applications

	local opwd=$PWD

	cd "$_PLUGIN_CONFIGURATION_PATH"
	local data_project
	for data_project in $(find "$_PLUGIN_CONFIGURATION_PATH" -maxdepth 2 -type d -name .git | sed -e 's/\/.git//' -e 's/\.\///' | sort -u); do
		printf '%s\n' "$data_project" | sed -e 's/^.*\.data\///' >>$_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/applications

		cd $data_project
		_git_has_uncommitted_work || _warn "$data_project is dirty"

		local branch_name=$(gcb)
		[ -z "$branch_name" ] && branch_name=master

		_git_synced_with_remote $branch_name || _warn "$data_project is not synced with remote"

		cd "$_PLUGIN_CONFIGURATION_PATH"
	done

	cd $opwd
}
