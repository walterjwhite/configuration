_PLUGIN_CONFIGURATION_PATH=~/.ssh
_PLUGIN_CONFIGURATION_PATH_IS_DIR=1
_PLUGIN_EXCLUDE="socket"

_configure_ssh_restore_pre() {
	if [ -n "$_FREEBSD_INSTALLER" ] && [ -e ~/.ssh/config ]; then
		_SSH_CONFIG_TEMPFILE=$(mktemp)
		mv ~/.ssh/config $_SSH_CONFIG_TEMPFILE
	fi
}

_configure_ssh_restore_post() {
	chmod 600 ~/.ssh/*

	# ensure socket directory exists
	mkdir -p ~/.ssh/socket
	chmod 700 ~/.ssh/socket

	if [ -n "$_SSH_CONFIG_TEMPFILE" ]; then
		if [ -e ~/.ssh/config ]; then
			mv ~/.ssh/config ~/.ssh/config.restore
		fi

		mv $_SSH_CONFIG_TEMPFILE ~/.ssh/config
	fi
}
