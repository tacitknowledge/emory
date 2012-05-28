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
require 'emory/handlers/stdout_handler'

handler do
  name :listener
  implementation Emory::Handlers::StdoutHandler
  events :all
end

teleport do
  path '~/_emory-test/'
  handler :listener
  ignore %r{ignored/}
  filter /\.txt$/
end
```

The gem supplies an executable file which scans for the configuration file in current directory
(and up the path if not found), configures itself and launches the process. If you need to terminate
execution then proceed like your operating system allows you to (Ctrl-C, for example).

```bash
$ emory
```

Emory outputs some information into the console where it was launched from. However if you would
like to consult more detailed information on what it's doing then feel free to consult `emory.log`
which is created in the same directory the `emory` command was launched from.

<a name="emory-dsl" />
Emory configuration DSL
-----------------------

The Emory configuration DSL is evaluated as plain Ruby, so you can use normal Ruby code in your
`.emory` file. Emory itself provides the following DSL methods that can be used for configuration:

<a name="emory-dsl-handler" />
### handler

A handler in Emory is an entity which knows how to react on file system modification events.
By default only two are provided:

- `Emory::Handlers::AbstractHandler` - defines common interface for other handlers to implement
- `Emory::Handlers::StdoutHandler` - spits out some information on what/how changed to the standard output

A handler can be configured with 3 mandatory and 1 optional parameter:

- mandatory
    - name - defines a name for the handler so that it could be used in other parts of the configuration
    - implementation - name of the specific class that conforms to `Emory::Handlers::AbstractHandler`'s interface
    - events - a comma separated list of events the handler should react to (**:added**, **:modified**, **:removed**)
while ignoring the ones not mentioned. There's also an **:all** shortcut to indicate all events without
explicitly writing them.
- optional
    - options - a hash of optional data that will be passed on during handler's construction. Please
note that the handler's class needs to know how to treat these otherwise it's a no-op. For example,
`Emory::Handlers::StdoutHandler` does not know how to deal with the options so it would just ignore them.

Some example of defining handlers

```ruby
require 'emory/handlers/stdout_handler'
require 'some_company/integration/system_x_handler'

handler do
  name :stdout_handler
  implementation Emory::Handlers::StdoutHandler
  events :added, :removed
end

handler do
  name :integration_handler
  implementation SomeCompany::Integration::SystemXHandler
  events :modified
  options host: 'host1.othercompany.com', port: 12345, username: 'bozo', password: 'p@ssw0rd'
end
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
