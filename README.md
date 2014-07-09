# Config Curator

[![Gem Version](http://img.shields.io/gem/v/config_curator.svg?style=flat)](https://rubygems.org/gems/config_curator)
[![MIT License](http://img.shields.io/badge/license-MIT-red.svg?style=flat)](./LICENSE.txt)
[![Dependency Status](http://img.shields.io/gemnasium/razor-x/config_curator.svg?style=flat)](https://gemnasium.com/razor-x/config_curator)
[![Build Status](http://img.shields.io/travis/razor-x/config_curator.svg?style=flat)](https://travis-ci.org/razor-x/config_curator)
[![Coverage Status](http://img.shields.io/coveralls/razor-x/config_curator.svg?style=flat)](https://coveralls.io/r/razor-x/config_curator)
[![Code Climate](http://img.shields.io/codeclimate/github/razor-x/config_curator.svg?style=flat)](https://codeclimate.com/github/razor-x/config_curator)

by Evan Boyd Sosenko.

_Simple and intelligent configuration file management._

## Description

## Installation

Add this line to your application's Gemfile:

````ruby
gem 'config_curator'
````

And then execute:

````bash
$ bundle
````

Or install it yourself as:

````bash
$ gem install config_curator
````

## Documentation

The primary documentation for Config Curator is this README and the YARD source documentation.

YARD documentation for all gem versions is hosted on the
[Config Curator gem page](https://rubygems.org/gems/config_curator).
Documentation for the latest commits is hosted on
[the RubyDoc.info project page](http://rubydoc.info/github/razor-x/config_curator/frames).

## Usage

### Scripting

Config Curator is fully scriptable for easy inclusion into other Ruby programs.
The API is well documented for this purpose
(see [Documentation](#documentation) above).

## Development and Testing

### Source Code

The [Config Curator source](https://github.com/razor-x/config_curator)
is hosted on GitHub.
To clone the project run

````bash
$ git clone https://github.com/razor-x/config_curator.git
````

### Rake

Run `rake -T` to see all Rake tasks.

````
rake all                   # Run all tasks
rake build                 # Build config_curator-0.0.0.gem into the pkg directory
rake bump:current          # Show current gem version
rake bump:major            # Bump major part of gem version
rake bump:minor            # Bump minor part of gem version
rake bump:patch            # Bump patch part of gem version
rake bump:pre              # Bump pre part of gem version
rake bump:set              # Sets the version number using the VERSION environment variable
rake install               # Build and install config_curator-0.0.0.gem into system gems
rake release               # Create tag v0.0.0 and build and push config_curator-0.0.0.gem to Rubygems
rake rubocop               # Run RuboCop
rake rubocop:auto_correct  # Auto-correct RuboCop offenses
rake spec                  # Run RSpec code examples
rake yard                  # Generate YARD Documentation
````

### Guard

Guard tasks have been separated into the following groups:

- `doc`
- `lint`
- `unit`

By default, Guard will generate documentation, lint, and run unit tests.

## Contributing

Please submit and comment on bug reports and feature requests.

To submit a patch:

1. Fork it (https://github.com/razor-x/config_curator/fork).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Make changes. Write and run tests.
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create a new Pull Request.

## License

Config Curator is licensed under the MIT license.

## Warranty

This software is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantibility and fitness for a particular
purpose.
