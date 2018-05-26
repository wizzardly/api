# wizzardly-api

[![Build Status](https://semaphoreci.com/api/v1/wizzardly/wizzardly-api/branches/master/badge.svg)](https://semaphoreci.com/wizzardly/wizzardly-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/3817b057abd79f487c3d/maintainability)](https://codeclimate.com/github/wizzardly/wizzardly-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/3817b057abd79f487c3d/test_coverage)](https://codeclimate.com/github/wizzardly/wizzardly-api/test_coverage)

An open source card game server.

# Installation

1. Clone this repository, then:

```bash
cd /path/to/wizzardly-api
bundle install
rake db:create db:migrate
```

1. Install and configure [puma-dev](https://github.com/puma/puma-dev), then:

```bash
cd ~/.puma-dev
ln -s /path/to/wizzardly-api api.wizzardly
```

1. Visit `https://api.wizzardly.dev`
1. Success!

# Testing

```bash
rake
```

# Heroku Setup

```
heroku git:remote -a wizzardly-api-production -r production
heroku git:remote -a wizzardly-api-staging -r staging
```

# Setting up git hooks

Some convenience hooks have been placed in the `.githooks/` directory.

To use one, simply:

```shell
cd .git/hooks
ln -s ../../.githooks/pre-push .
```

- `pre-push`: Checks for pushes to the master branch and prompts you before allowing the push
