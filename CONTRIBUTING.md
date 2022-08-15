This file contains information for contributing to this project.

# Tooling

## Foreman

This project uses [Foreman](https://github.com/Roblox/foreman) to manage tooling.

After installing [Foreman](https://github.com/Roblox/foreman), install tooling by running:

```bash
foreman install
```

## pre-commit

Additionally, this project uses [pre-commit](https://github.com/pre-commit/pre-commit) to check files before committing.

After installing [pre-commit](https://github.com/pre-commit/pre-commit), install hooks by running:

```bash
pre-commit install
```

# End of Line

For compatibility on all platforms, this repo uses solely Unix (`LF`) line endings.
Please configure your editor to follow this requirement.

# Testing

To test, build the examples with:

```bash
remodel run build
```

To upload a example, you can use:

```bash
remodel run upload-example [example] [mainPlaceId] [migrationPlaceId]
```

# Deploying

Deploying is automatic, so pushing a new version tag should publish and release automatically.
