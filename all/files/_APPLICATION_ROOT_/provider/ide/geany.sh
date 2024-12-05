_PLUGIN_CONFIGURATION_PATH=~/.config/geany
_PLUGIN_CONFIGURATION_PATH_IS_DIR=1
_PLUGIN_EXCLUDE="templates tags filedefs geany_socket*"

_configure_geany_backup_post() {
	local geany_conf=$(find "$_CONF_INSTALL_APPLICATION_DATA_PATH/$_EXTENSION_NAME" -type f -name geany.conf)
	if [ -z "$geany_conf" ]; then
		return 1
	fi

	$_CONF_INSTALL_GNU_SED -i '/msgwindow_position=.*/d' $geany_conf
	$_CONF_INSTALL_GNU_SED -i '/geometry=.*/d' $geany_conf
	$_CONF_INSTALL_GNU_SED -i '/recent_files=.*/d' $geany_conf
	$_CONF_INSTALL_GNU_SED -i '/recent_projects=.*/d' $geany_conf

	$_CONF_INSTALL_GNU_SED -i '/position_find_x=.*/d' $geany_conf
	$_CONF_INSTALL_GNU_SED -i '/position_find_y=.*/d' $geany_conf

	$_CONF_INSTALL_GNU_SED -i '/position_replace_x=.*/d' $geany_conf
	$_CONF_INSTALL_GNU_SED -i '/position_replace_y=.*/d' $geany_conf

	$_CONF_INSTALL_GNU_SED -i '/current_page=.*/d' $geany_conf
	$_CONF_INSTALL_GNU_SED -i '/FILE_NAME_.*=.*/d' $geany_conf

	$_CONF_INSTALL_GNU_SED -i '/^#.*/d' $geany_conf
}
