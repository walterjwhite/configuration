# backup user's current maven configuration
case $_PLATFORM in
Apple)
	_MAVEN_INSTALLATION_DIRECTORY=/opt/homebrew/Cellar/maven
	_MAVEN_VERSION=$(ls -1 $_MAVEN_INSTALLATION_DIRECTORY | tail -1)

	_PLUGIN_CONFIGURATION_PATH="$_MAVEN_INSTALLATION_DIRECTORY/$_MAVEN_VERSION/libexec/conf"
	_PLUGIN_CONFIGURATION_PATH_IS_DIR=1
	;;
Linux | FreeBSD | Windows)
	_PLUGIN_CONFIGURATION_PATH=~/.m2
	_PLUGIN_CONFIGURATION_PATH_IS_DIR=1

	;;
esac

_PLUGIN_INCLUDE="settings.xml settings-security.xml"
