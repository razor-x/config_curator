# Config Curator

[![Gem Version](https://img.shields.io/gem/v/config_curator.svg)](https://rubygems.org/gems/config_curator)
[![MIT License](https://img.shields.io/github/license/razor-x/config_curator.svg)](./LICENSE.txt)
[![Dependency Status](https://img.shields.io/gemnasium/razor-x/config_curator.svg)](https://gemnasium.com/razor-x/config_curator)
[![Build Status](https://img.shields.io/travis/razor-x/config_curator.svg)](https://travis-ci.org/razor-x/config_curator)
[![Coverage Status](https://img.shields.io/codecov/c/github/razor-x/config_curator.svg)](https://codecov.io/github/razor-x/config_curator)
[![Code Climate](https://img.shields.io/codeclimate/github/razor-x/config_curator.svg)](https://codeclimate.com/github/razor-x/config_curator)

by Evan Boyd Sosenko.

_Simple and intelligent configuration file management._

## Description

Config Curator is a flexible configuration and dotfile manager.
Simply define what to manage in `manifest.yml`,
then run `curate` to install and update your **configuration units**.

Currently, Config Curator supports installing
directories, files, and symbolic links.
It also handles setting other properties such as
permissions and ownership.
Additionally, configuration units can be installed per-host
or only if certain packages are installed.

Config Curator is written to be extensible:
each type of configuration unit,
e.g., file, directory, symbolic link, etc.,
is actually a subclass of the more generic `Unit` type.
Other types can be added simply by adding more subclasses.

## Quick start

1. Install the `config_curator` gem
   (make sure installed gem binaries are in your PATH).

2. Create a `manifest.yml` file, e.g.,

  ```yaml
  config_files:
    - src: .config/git/config
  ```

3. Add `.config/git/config` to your project and run

  ```bash
  $ curate -v
  ```

## Usage

### The `manifest.yml` file

The `manifest.yml` file is a YAML file that defines
the configuration units to install.

Each key is either a global setting, `default`,
or a unit type: `components`, `config_files`, or `symlinks`.

#### Settings

Optional global Config Curator settings.
Defaults listed below.

```yaml
# All units installed relative to the root.
root: "~/"

# Package tool to use.
# Will automatically detect if not explicitly set.
# Available tools: pacman, dpkg, pkgng.
package_tool:
```

#### `defaults`

Optional key that sets the default attribute values for each unit.

Any per-unit attribute will override the value here.

Any attribute not set here will use
the Config Curator defined defaults below.

```yaml
defaults:
  # File and directory permissions.
  # Empty values will not change permissions.
  fmode:
  dmode:

  # File and directory owner and group.
  # Empty values will not change ownership.
  owner:
  group:

  # Hosts to install this unit on.
  # Empty array will install on all hosts.
  hosts: []

  # Only install this unit if packages are present.
  # Empty array will not check for any packages.
  packages: []
```

#### Units

Each unit must have a `src` which defines the source file or directory.

You may give a `dst` to override the install location.
Otherwise the destination will mimic the source path relative to the `root` path.
This is required for symlinks.

You can define an array of `hosts` to control what hostnames the unit will install on.
Similarly you can give a list of packages that must be present to install the unit.
You can also use any other attribute in the `defaults` key listed in the previous section.

Best to see some examples.
Note in the examples below how some units are installed from the `bower_components` directory:
external configuration is thus managed as a Bower dependency and installed using `curate`.
You can always visit [my dotfiles for a real-world example](https://github.com/razor-x/dotfiles).

##### Components are entire directories

Components are installed before other units.

The source will be mirrored to the destination.
**Any existing files in the destination will be lost.**

```yaml
components:
  - src: .config/terminator

  - src: bower_components/tmuxinator-profiles
    dst: .tmuxinator
    fmode: 640
    dmode: 0750
    packages: [ tmux ]
```

##### Config files are copied individually

Files are installed after components.

Subdirectories are created as needed.

In this example, the files `.tmux.conf` and `.tmux.baz.conf` both exist:
the first will be installed on hosts `foo` and `bar`,
while the second will be installed on host `baz`.

```yaml
config_files:
  - src: .gitconfig
  - src: .bundle/config

  - src: bower_components/ssh-config/config
    dst: .ssh/config
    fmode: 600
    dmode: 0700

  - src: .tmux.conf
    hosts: [ foo, bar, baz ]
```

##### Symlinks

Symlinks create a symbolic link to the `src` at the `dst`.

They are installed last.

```yaml
symlinks:
  - src: ~/Wallpaper/tux.png
    dst: .config/awesome/wall.png
    packages: [ awesome ]
```

### The `curate` command

Once you have prepared your manifest, simply run

```bash
$ curate
```

Or if you prefer more verbose feedback

```bash
$ curate -v
```

You can always get help with

```
$ curate help

Commands:
  curate help [COMMAND]  # Describe available commands or one specific command
  curate install         # Installs all units in collection.

Options:
  v, [--verbose], [--no-verbose]
  q, [--quiet], [--no-quiet]
      [--debug], [--no-debug]
```

#### Uninstalling units

Currently all units have an uninstall method.
Smart uninstall via `curate uninstall` is planned for an
[upcoming release](https://github.com/razor-x/config_curator/issues/7).

### Scripting

Config Curator is fully scriptable for easy inclusion into other Ruby programs.
The API is well documented for this purpose
(see [Documentation](#documentation) above).

### Plugins

Plugin support is
[planned for an upcoming release](https://github.com/razor-x/config_curator/issues/8).
If you like Config Curator and want to write a plugin,
please let me know!

## Installation

You can install the gem either with Bundler or directly.
Bundler is preferred, however the direct method may be convenient
when initially bootstrapping a system with an initial configuration.

The recommend setup is to check your configuration
along with `manifest.yml` into version control.

Add this line to your application's Gemfile:

```ruby
gem 'config_curator'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install config_curator
```

## Documentation

The primary documentation for Config Curator is this README and the YARD source documentation.

YARD documentation for all gem versions is hosted on the
[Config Curator gem page](https://rubygems.org/gems/config_curator).
Also checkout
[Omniref's interactive documentation](https://www.omniref.com/ruby/gems/config_curator).

## Development and Testing

### Source Code

The [Config Curator source](https://github.com/razor-x/config_curator)
is hosted on GitHub.
To clone the project run

```bash
$ git clone https://github.com/razor-x/config_curator.git
```

### Rake

Run `rake -T` to see all Rake tasks.

```
rake all                   # Run all tasks
rake build                 # Build config_curator-0.2.4.gem into the pkg directory
rake bump:current[tag]     # Show current gem version
rake bump:major[tag]       # Bump major part of gem version
rake bump:minor[tag]       # Bump minor part of gem version
rake bump:patch[tag]       # Bump patch part of gem version
rake bump:pre[tag]         # Bump pre part of gem version
rake bump:set              # Sets the version number using the VERSION environment variable
rake install               # Build and install config_curator-0.2.4.gem into system gems
rake release               # Create tag v0.2.4 and build and push config_curator-0.2.4.gem to Rubygems
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
