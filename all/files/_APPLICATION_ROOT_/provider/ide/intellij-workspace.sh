if [ -n "$_CONF_CONFIGURATION_INTELLIJ_WORKSPACE_BASE_DIRECTORY" ]; then
	_PLUGIN_CONFIGURATION_PATH="$_CONF_CONFIGURATION_INTELLIJ_WORKSPACE_BASE_DIRECTORY"
else
	_warn "_CONF_CONFIGURATION_INTELLIJ_WORKSPACE_BASE_DIRECTORY is unset"
fi

import git:install/sed.sh

_configure_intellij_workspace_restore() {
	local workspace_backup_path=$(_sed_safe "$_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME")
	local intellij_idea
	for intellij_idea in $(find $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME -type d -name '.idea'); do
		local intellij_idea_target=$(printf '%s\n' "$intellij_idea" | sed -e "s/$workspace_backup_path//")

		_detail "Restoring $intellij_idea_target"

		rm -rf $_CONF_CONFIGURATION_INTELLIJ_WORKSPACE_BASE_DIRECTORY/$intellij_idea_target
		cp -Rp $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/$intellij_idea_target $_CONF_CONFIGURATION_INTELLIJ_WORKSPACE_BASE_DIRECTORY/$intellij_idea_target
	done
}

_configure_intellij_workspace_backup() {
	rm -rf $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME
	mkdir -p $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME

	local workspace_base_path_sed_safe=$(_sed_safe "$_CONF_CONFIGURATION_INTELLIJ_WORKSPACE_BASE_DIRECTORY")
	local intellij_idea
	for intellij_idea in $(find $_CONF_CONFIGURATION_INTELLIJ_WORKSPACE_BASE_DIRECTORY -type d -name '.idea'); do
		local intellij_idea_target=$(printf '%s\n' "$intellij_idea" | sed -e "s/$workspace_base_path_sed_safe//")

		mkdir -p $(dirname $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/$intellij_idea_target)

		_detail "Backing up $intellij_idea_target"
		cp -Rp $intellij_idea $_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME/$intellij_idea_target
	done
}
