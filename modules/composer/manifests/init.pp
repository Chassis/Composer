# Class to install and configure Composer
class composer (
	$path            = '/vagrant/extensions/composer',
	$composer_config = sz_load_config()
) {
	if versioncmp( $composer_config[php], '5.4') <= 0 {
		$php_package = 'php5'
	} else {
		$php_package = "php${composer_config[php]}"
	}

	if ( ! empty( $composer_config[disabled_extensions] ) and 'composer' in $composer_config[disabled_extensions] ) {
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

