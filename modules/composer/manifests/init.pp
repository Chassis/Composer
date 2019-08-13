# Class to install and configure Composer
class composer (
	$config,
) {

	$version = $config[php]

	if $version =~ /^(\d+)\.(\d+)$/ {
		$package_version = "${version}.*"
		$short_ver = $version
	}
	else {
		$package_version = "${version}*"
		$short_ver = regsubst($version, '^(\d+\.\d+)\.\d+$', '\1')
	}

	if versioncmp( $version, '5.4') <= 0 {
		$php_package = 'php5'
		$php_dir = 'php5'
	}
	else {
		$php_package = "php${short_ver}"
		$php_dir = "php/${short_ver}"
	}

	$php_cli = "php${short_ver}-cli"

	# Puppet 3.8 doesn't have the .each function and we need an alternative.
	define install {
		exec { "Installing Composer ${name}":
			environment => [ 'COMPOSER_HOME=/usr/bin/composer' ],
			path        => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
			cwd         => $name,
			command     => "composer install ${config[composer][options]}",
			require     => [ Exec['install composer'] ],
			logoutput   => true,
			onlyif      => 'test ! -d vendor'
		}
	}

	if ( ! empty( $config[disabled_extensions] ) and 'composer' in $config[disabled_extensions] ) {
		$package = absent
	} else {
		$package = latest
	}

	if ! defined( Package[$php_cli] ) {
		package { $php_cli:
			ensure  => $package,
		}
	}

	if ( $package == 'latest' ) {
		exec { 'install composer':
			path        => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
			environment => [ 'COMPOSER_HOME=/usr/bin/composer' ],
			command     =>
				'curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin --filename=composer',
			require     => [ Package['curl'], Package[$php_cli] ],
			unless      => 'test -f /usr/bin/composer',
		}
		if ( $config[composer] and $config[composer][paths]) {
			install { $config[composer][paths]: }
		}
	} else {
		file { 'remove composer cache':
			ensure => absent,
			path   => '/home/vagrant/.cache/composer',
			force  => true
		}
		file { 'remove composer':
			ensure => absent,
			path   => '/usr/bin/composer',
		}
	}
}
