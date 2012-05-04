# Emory

The Emory gem listens to file modifications and runs an action against it (for example, upload to a remote location).

## Installation

Add this line to your application's `Gemfile`:

``` ruby
    gem 'emory'
```

And then execute:

``` bash
    $ bundle
```

Or install it yourself as:

``` bash
    $ gem install emory
```

## Usage

Emory is run from the command line. Please open your terminal and go to your project's work directory.

There you would need to create Emory config file `.emory` which in fact is nothing more than regular
Ruby code wrapped in gem's configuration DSL.

TODO: Show example configuration

The gem supplies an executable file which scans for the configuration file in current directory
(and up the path if not found), configures itself and launches the process. If you need to terminate
execution then proceed like your operating system allows you to (Ctrl-C, for example).

``` bash
    $ emory
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

* [Scott Askew](https://github.com/scottfromsf)
* [Vladislav Gangan](https://github.com/vgangan)
* [Ion Lenta](https://github.com/noi)
