# Ruby Gem Skeleton

<!--
[![Gem Version](https://img.shields.io/gem/v/replace_gemname.svg)](https://rubygems.org/gems/replace_gemname)
-->
[![MIT License](https://img.shields.io/github/license/makenew/ruby-gem.svg)](./LICENSE.txt)
[![Dependency Status](https://img.shields.io/gemnasium/makenew/ruby-gem.svg)](https://gemnasium.com/makenew/ruby-gem)
[![Build Status](https://img.shields.io/travis/makenew/ruby-gem.svg)](https://travis-ci.org/makenew/ruby-gem)
[![Coverage Status](https://img.shields.io/codecov/c/github/makenew/ruby-gem.svg)](https://codecov.io/github/makenew/ruby-gem)
[![Code Climate](https://img.shields.io/codeclimate/github/makenew/ruby-gem.svg)](https://codeclimate.com/github/makenew/ruby-gem)

Use this project freely as a base for your testable Ruby gems.

## Description

### Features

* [Rake] and [Guard] tasks for included tools.
* Gem management with [Bundler] and [Bump].
* Documentation generation with [YARD].
* Linting with [RuboCop].
* Unit testing with [RSpec].
* [Travis CI] ready.
* [EditorConfig].
* Badges from [Shields.io]!

[Bump]: https://github.com/gregorym/bump
[Bundler]: http://bundler.io/
[EditorConfig]: http://editorconfig.org/
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

```bash
$ git mv replace_gemname.gemspec your_gemname.gemspec
$ git mv lib/replace_gemname.rb lib/your_gemname.rb
$ git mv lib/replace_gemname lib/your_gemname
$ git ls-files -z | xargs -0 sed -i 's/replace_gemname/your_gemname/g'
$ git ls-files -z | xargs -0 sed -i 's/ReplaceGemname/YourGemname/g'
```

   To see a list of what else still needs to be replaced, run

```bash
$ grep -Ri replace
$ find . -name "*replace*"
```

Note that `CHANGELOG.md` is just a template for this skeleton.
The actual changes for this project are documented in the commit history
and summarized under [Releases].

[Releases]: https://github.com/makenew/ruby-gem/releases
[The Unlicense]: http://unlicense.org/UNLICENSE

#### Add future update support

If you want to merge in future updates from this skeleton and have your own origin,
set up a separate branch to track this.

```bash
$ git remote rename origin upstream
$ git branch ruby-gem
$ git branch -u upstream/master ruby-gem
```

Then add an origin and push master

```bash
$ git remote add origin git@github.com:your_username/your_gemname.git
$ git push -u origin master
```

Now, the `ruby-gem` branch will pull changes from this project,
which you can then merge into your other branches.

If you later clone your repo you will need to create the update branch again.

```bash
$ git remote add upstream https://github.com/makenew/ruby-gem.git
$ git fetch upstream
$ git checkout -b ruby-gem upstream/master
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'replace_gemname'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install replace_gemname
```

## Documentation

The primary documentation for ReplaceGemname is this README and the YARD source documentation.

YARD documentation for all gem versions is hosted on the
[ReplaceGemname gem page](https://rubygems.org/gems/replace_gemname).
Also checkout
[Omniref's interactive documentation](https://www.omniref.com/ruby/gems/replace_gemname).

## Development and Testing

### Source Code

The [ReplaceGemname source](https://github.com/replace_username/replace_gemname)
source is hosted on GitHub.
To clone the project run

```bash
$ git clone https://github.com/replace_username/replace_gemname.git
```

### Rake

Run `rake -T` to see all Rake tasks.

```
rake all                   # Run all tasks
rake build                 # Build replace_gemname-0.0.0.gem into the pkg directory
rake bump:current[tag]     # Show current gem version
rake bump:major[tag]       # Bump major part of gem version
rake bump:minor[tag]       # Bump minor part of gem version
rake bump:patch[tag]       # Bump patch part of gem version
rake bump:pre[tag]         # Bump pre part of gem version
rake bump:set              # Sets the version number using the VERSION environment variable
rake install               # Build and install replace_gemname-0.0.0.gem into system gems
rake release               # Create tag v0.0.0 and build and push replace_gemname-0.0.0.gem to Rubygems
rake rubocop               # Run RuboCop
rake rubocop:auto_correct  # Auto-correct RuboCop offenses
rake spec                  # Run RSpec code examples
rake yard                  # Generate YARD Documentation
```

### Guard

Guard tasks have been separated into the following groups:

- `doc`
- `lint`
- `unit`

By default, Guard will generate documentation, lint, and run unit tests.

## Contributing

Please submit and comment on bug reports and feature requests.

To submit a patch:

1. Fork it (https://github.com/makenew/ruby-gem/fork).
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
