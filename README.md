# Composer extension for Chassis
The Composer extension automatically sets up your Chassis instance to be able to use composer on your Chassis box.

## Installation
1. Add this extension to your extensions directory `git clone https://github.com/Chassis/Composer.git extensions/composer`
2. Run `vagrant provision`.


## Alternative Installation
1. Add `- chassis/composer` to your `extensions` in one of you [yaml](http://docs.chassis.io/en/latest/config/) files. e.g.
	```
	extensions:
	- chassis/composer
	```
2. Run `vagrant provision`.

## Installing Composer dependencies

You can have Chassis automatically run `composer install` in a number of directories in your project by adding a list of directories in one of your [yaml](http://docs.chassis.io/en/latest/config/) files. e.g.
```
composer:
    paths:
        - content/plugins/test
        - content/themes/atheme
```

You'll need to run `vagrant provision` for those to be installed if you'd added them after your first initial Chassis `vagrant up`.
