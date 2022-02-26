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

## Installing Composer version 1

By default Composer 2.x is installed but if you require Composer version 1.x for your project then you can add the 
following to one of your [yaml](http://docs.chassis.io/en/latest/config/) files.

```yaml
composer:
  version: 1
```

## Installing Composer dependencies

You can have Chassis automatically run `composer install` in a number of directories in your project by adding a list of directories in one of your [yaml](http://docs.chassis.io/en/latest/config/) files. e.g.
```
composer:
    paths:
        # Use absolute paths on the VM. For a default Chassis installation this should be:
        - /vagrant/content/plugins/yourplugin
        - /vagrant/content/themes/atheme
        # If you're using paths (http://docs.chassis.io/en/latest/config/#paths) in Chassis this should be:
        - /chassis/content/plugins/yourplugin
        - /chassis/content/themes/atheme
```

You can also specify options to pass to `composer install` e.g.
```
composer:
    paths:
        - /vagrant/content/plugins/yourplugin
        - /vagrant/content/themes/atheme
    options: --prefer-source --verbose
```

You'll need to run `vagrant provision` for those to be installed if you'd added them after your first initial Chassis `vagrant up`.
