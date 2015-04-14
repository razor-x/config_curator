# ChangeLog

## 0.2.3

- Fix bug where component would not install
  if destination does not exist.

## 0.2.2

- Copy system links in components when using rsync.

## 0.2.1

- Allow all keys in manifest to be strings or symbols.

## 0.2.0

- Merged [ruby-gem](https://github.com/razor-x/ruby-gem) for improved development.
- Style changes and refactoring to pass Rubocop.

## 0.1.0

- PackageLookup#tools separates tool identifier and tool command.
- PackageLookup#installed? checks for tool command before lookup.
- Support for FreeBSD's pkgng added to PackageLookup.

## 0.0.1

- Initial development release.
