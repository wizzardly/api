# api.wizzard.ly

[![Build Status](https://semaphoreci.com/api/v1/wizzardly/api-wizzard-ly/branches/master/badge.svg)](https://semaphoreci.com/wizzardly/api-wizzard-ly)
[![Maintainability](https://api.codeclimate.com/v1/badges/1540a3df780eba3013f0/maintainability)](https://codeclimate.com/github/wizzardly/api.wizzard.ly/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1540a3df780eba3013f0/test_coverage)](https://codeclimate.com/github/wizzardly/api.wizzard.ly/test_coverage)

An open source card game server.

# Installation

1. Clone this repository, then:

```bash
cd /path/to/api.wizzard.ly
bundle install
rake db:create db:migrate
```

1. Install and configure [puma-dev](https://github.com/puma/puma-dev), then:

```bash
cd ~/.puma-dev
ln -s /path/to/api.wizzard.ly api.wizzardly
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
