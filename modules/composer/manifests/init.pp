class composer (
	$path            = "/vagrant/extensions/composer",
	$composer_config = sz_load_config()
) {
	if versioncmp( "${composer_config[php]}", '5.4') <= 0 {
		$php_package = 'php5'
	} else {
		$php_package = "php${composer_config[php]}"
	}

	if ! defined( Package["${php_package}-dev"] ) {
		package { "${php_package}-dev":
			ensure  => latest,
			require => Package["${php_package}-fpm"]
		}
	}

	if ! defined( Package['php-pear'] ) {
		package { 'php-pear':
			ensure  => latest,
			require => Package["${php_package}-dev"]
		}
	}

	exec { 'install composer':
		path        => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
		environment => [ 'COMPOSER_HOME=/usr/bin/composer' ],
		command     => 'curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin --filename=composer',
		require     => [ Package['curl'], Package['php-pear'] ],
		unless      => 'test -f /usr/bin/composer',
	}
}

