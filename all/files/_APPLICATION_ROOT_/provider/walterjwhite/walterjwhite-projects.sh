_PLUGIN_CONFIGURATION_PATH=~/projects
_PLUGIN_CONFIGURATION_PATH_IS_DIR=1

_PLUGIN_CONFIGURATION_PATH_IS_SKIP_PREPARE=1

_configure_walterjwhite_projects_clear() {
	local opwd=$PWD
	cd "$_PLUGIN_CONFIGURATION_PATH"

	local project
	for project in $(find . -type d -name .git | sed -e 's/\/.git//'); do
		cd $project
		_git-is-clean || _error "$project is dirty"

		git push --all || _error "Unable to push all refs"
		git push --tags || _error "Unable to push all tags"

		cd "$_PLUGIN_CONFIGURATION_PATH"
	done

	cd $opwd
}

_configure_walterjwhite_projects_restore() {
	if [ ! -e $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/projects ]; then
		return 1
	fi

	local opwd=$PWD
	local project
	while read project; do
		if [ -e ~/.data/$project ]; then
			_warn "Data Application: $project already exists"
			continue
		fi

		gclone $project
		cd $opwd
	done <$_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/projects
}

_configure_walterjwhite_projects_backup() {
	rm -f $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/projects

	local opwd=$PWD

	cd "$_PLUGIN_CONFIGURATION_PATH"
	local data_project
	for project in $(find "$_PLUGIN_CONFIGURATION_PATH" -name .git -type d ! -path '*/app.registry/*' |
		sed -e 's/\/.git//' -e 's/^.*\/projects\///' | sort -u); do
		printf '%s\n' "$project" | sed -e 's/git\///' -e 's/github.com/git@github.com/' >>$_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/projects

		cd $project
		_git_has_uncommitted_work || _warn "$project is dirty"

		local branch_name=$(gcb)
		[ -z "$branch_name" ] && branch_name=master

		_git_synced_with_remote $branch_name || _warn "$project is not synced with remote"

		cd "$_PLUGIN_CONFIGURATION_PATH"
	done

	cd $opwd
}
