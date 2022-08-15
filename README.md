# Shutdown

The easiest way to shutdown your game without worry.

Shutdown's goal is simple: shutdown your old servers and get players back into new ones ASAP.
No reconnect buttons, no waiting around, it just works™.

# How

Shutdown functions by having two types of places:
- Normal places
  - These contain the typical content for your game, like the map and game logic
- Migration place
  - A single place which contains as little content as possible

When a normal place's servers shut down, players are teleported to the migration place.
After a configurable amount of time passes, they are teleported back to a configurable normal place.

For configuration options, see the [Usage](#usage) section.

# Installation

There are a couple of ways to install Shutdown:

## Wally

To install with [wally](https://wally.run/), just add this line to your `wally.toml`.

*If you're using Rojo, 
make sure to point the `ServerPackages` folder to a place you can access it at*

## Releases

To install from releases, download `.rbxm` file directly from the [releases](https://github.com/ThatTimothy/shutdown/releases).
Insert it into studio using `Right Click` -> `Insert from File...`, and put it wherever.

# Usage

TODO:
- Documentation

# Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for information on contributing to this project

# License

Licensed with the MIT License.
See the full license at [LICENSE.md](LICENSE.md).
