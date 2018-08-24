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

	if ( ! empty( $config[disabled_extensions] ) and 'composer' in $config[disabled_extensions] ) {
		$package = absent
	} else {
		$package = latest
	}

	if ! defined( Package["${php_package}-dev"] ) {
		package { "${php_package}-dev":
			ensure  => $package,
			require => Package["${php_package}-fpm"]
		}
	}

	if ! defined( Package['php-pear'] ) {
		package { 'php-pear':
			ensure  => $package,
			require => Package["${php_package}-dev"]
		}
	}

	if ( $package == 'latest' ) {
		exec { 'install composer':
			path        => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
			environment => [ 'COMPOSER_HOME=/usr/bin/composer' ],
			command     =>
				'curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin --filename=composer',
			require     => [ Package['curl'], Package['php-pear'] ],
			unless      => 'test -f /usr/bin/composer',
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

