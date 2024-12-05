_configure_compare() {
	_load_extension $1
	_call _configure_${1}_compare || _error "Unable to compare: _configure_${1}_compare"
}
