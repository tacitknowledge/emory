Emory
=====

The Emory gem listens to file modifications and runs an action against it (for example, upload to a remote location).

Contents
--------

* [Installation](#installation)
* [Usage](#usage)
* [Emory configuration DSL](#emory-dsl)
  * [handler](#emory-dsl-handler)
  * [teleport](#emory-dsl-teleport)
* [Contributing](#contributing)
* [Authors](#authors)

<a name="installation" />
Installation
------------

Add this line to your application's `Gemfile`:

```ruby
gem 'emory'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install emory
```

<a name="usage" />
Usage
-----

Emory is run from the command line. Please open your terminal and go to your project's work directory.

There you would need to create Emory config file `.emory` which in fact is nothing more than regular
Ruby code wrapped in gem's configuration DSL.

Example configuration:

```ruby
handler :simple, ::Emory::Handlers::StdoutHandler, actions: [:added, :removed]

teleport ['/path/to/watched/directory', '/path/to/another/watched/directory'], :simple
```

The gem supplies an executable file which scans for the configuration file in current directory
(and up the path if not found), configures itself and launches the process. If you need to terminate
execution then proceed like your operating system allows you to (Ctrl-C, for example).

```bash
$ emory
```

<a name="emory-dsl" />
Emory configuration DSL
-----------------------

The Emory configuration DSL is evaluated as plain Ruby, so you can use normal Ruby code in your
`.emory` file. Emory itself provides the following DSL methods that can be used for configuration:

<a name="emory-dsl-handler" />
### handler

Handler yada-yada-yada

```ruby
handler :noop,
        ::Emory::Handlers::StdoutHandler,
        actions: [:added, :removed]
```

```ruby
handler :hndlr,
        ::Emory::Handlers::SomeOtherHandler,
        actions: [:all],
        options: {host: 'localhost', port: '8080', path: '/some/remote/root/path'}
```

<a name="emory-dsl-teleport" />
### teleport

Teleport yada-yada-yada

```ruby
teleport ['/path/to/watched/directory', '/path/to/another/watched/directory'],
         :desired_handler,
         options: {ignore: %r{^ignored/path/}, filter: /\.rb$/}
```

<a name="contributing" />
Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

<a name="authors" />
Authors
-------

* [Scott Askew](https://github.com/scottfromsf)
* [Vladislav Gangan](https://github.com/vgangan)
* [Ion Lenta](https://github.com/noi)
