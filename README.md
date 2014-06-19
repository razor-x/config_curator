# Ruby Gem Skeleton

<!--
[![Gem Version](http://img.shields.io/gem/v/replace_gemname.svg?style=flat)](https://rubygems.org/gems/replace_gemname)
-->
[![MIT License](http://img.shields.io/badge/license-MIT-red.svg?style=flat)](./LICENSE.txt)
[![Dependency Status](http://img.shields.io/gemnasium/razor-x/ruby-gem.svg?style=flat)](https://gemnasium.com/razor-x/ruby-gem)
[![Build Status](http://img.shields.io/travis/razor-x/ruby-gem.svg?style=flat)](https://travis-ci.org/razor-x/ruby-gem)
[![Coverage Status](http://img.shields.io/coveralls/razor-x/ruby-gem.svg?style=flat)](https://coveralls.io/r/razor-x/ruby-gem)
[![Code Climate](http://img.shields.io/codeclimate/github/razor-x/ruby-gem.svg?style=flat)](https://codeclimate.com/github/razor-x/ruby-gem)

Use this project freely as a base for your testable Ruby gems.

## Description

### Features

* [Rake] and [Guard] tasks for included tools.
* Gem management with [Bundler] and [Bump].
* Documentation generation with [YARD].
* Linting with [RuboCop].
* Unit testing with [RSpec].
* [Travis CI] ready.
* Badges from [Shields.io]!

[Bump]: https://github.com/gregorym/bump
[Bundler]: http://bundler.io/
[Guard]: http://guardgem.org/
[Rake]: https://github.com/jimweirich/rake
[RSpec]: http://rspec.info/
[RuboCop]: https://github.com/bbatsov/rubocop
[Shields.io]: http://shields.io/
[Travis CI]: https://travis-ci.org/
[YARD]: http://yardoc.org/index.html

### Usage

This software can be used freely, see [The Unlicense].
The MIT License text appearing in this software is for
demonstration purposes only and does not apply to this software.

1. Clone this repository or download a [release][Releases].

2. Customize this README.
   - Set the title and summary text.
   - Replace the Description section.
   - Update the Contributing section.
   - Remove or update the badges.

3. Everything else that should be filled in before using this skeleton
   has been marked with the terms `replace` or `Replace`.
   You can replace the placeholder gem name with your own using

````bash
$ git mv replace_gemname.gemspec your_gemname.gemspec
$ git mv lib/replace_gemname.rb lib/your_gemname.rb
$ git mv lib/replace_gemname lib/your_gemname
$ git ls-files -z | xargs -0 sed -i 's/replace_gemname/your_gemname/g'
$ git ls-files -z | xargs -0 sed -i 's/ReplaceGemname/YourGemname/g'
````

   To see a list of what else still needs to be replaced, run

````bash
$ grep -Ri replace
$ find . -name "*replace*"
````

Note that `CHANGELOG.md` is just a template for this skeleton.
The actual changes for this project are documented in the commit history
and summarized under [Releases].

[Releases]: https://github.com/razor-x/ruby-gem/releases
[The Unlicense]: http://unlicense.org/UNLICENSE

#### Add future update support

If you want to merge in future updates from this skeleton and have your own origin,
set up a separate branch to track this.

````bash
$ git remote rename origin upstream
$ git branch ruby-gem
$ git branch -u upstream/master ruby-gem
````

Then add an origin and push master

````bash
$ git remote add origin git@github.com:your_username/your_gemname.git
$ git push -u origin master
````

Now, the `ruby-gem` branch will pull changes from this project,
which you can then merge into your other branches.

If you later clone your repo you will need to create the update branch again.

````bash
$ git remote add upstream https://github.com/razor-x/ruby-gem.git
$ git fetch upstream
$ git checkout -b ruby-gem upstream/master
````

## Installation

Add this line to your application's Gemfile:

````ruby
gem 'replace_gemname'
````

And then execute:

````bash
$ bundle
````

Or install it yourself as:

````bash
$ gem install replace_gemname
````

## Documentation

The primary documentation for ReplaceGemname is this README and the YARD source documentation.

YARD documentation for all gem versions is hosted on the
[ReplaceGemname gem page](https://rubygems.org/gems/replace_gemname).
Documentation for the latest commits is hosted on
[the RubyDoc.info project page](http://rubydoc.info/github/replace_username/replace_gemname/frames).

## Development and Testing

### Source Code

The [ReplaceGemname source](https://github.com/replace_username/replace_gemname)
is hosted on GitHub.
To clone the project run

````bash
$ git clone https://github.com/replace_username/replace_gemname.git
````

### Rake

Run `rake -T` to see all Rake tasks.

````
rake all                   # Run all tasks
rake build                 # Build replace_gemname-0.0.0.gem into the pkg directory
rake bump:current          # Show current gem version
rake bump:major            # Bump major part of gem version
rake bump:minor            # Bump minor part of gem version
rake bump:patch            # Bump patch part of gem version
rake bump:pre              # Bump pre part of gem version
rake bump:set              # Sets the version number using the VERSION environment variable
rake install               # Build and install replace_gemname-0.0.0.gem into system gems
rake release               # Create tag v0.0.0 and build and push replace_gemname-0.0.0.gem to Rubygems
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

1. Fork it (https://github.com/razor-x/ruby-gem/fork).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Make changes. Write and run tests.
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create a new Pull Request.

## License

ReplaceGemname is licensed under the MIT license.

## Warranty

This software is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantibility and fitness for a particular
purpose.
