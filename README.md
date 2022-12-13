# WordPress Composer Template

## Requirements

Local:

- Docker
- Composer

Staging / Production:

- wp-cli
- Composer

## Installation

### Pull the repository

**Note:** Change `my-bedrock-project` to your project name.

```zsh
git clone git@github.com:mimosafa/wp-composer-template.git my-bedrock-project
```

Go to the project directory with `cd my-bedrock-project`.

### Install dependencies

```zsh
composer update
```

### Prepare env file

```zsh
cp .env.example .env
```
Edit .env file.

## Basic Usage

### Docker container lifecycle

Create and start containers:

```zsh
make up
```

`WP_TITLE`, `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, and `WP_ADMIN_EMAIL`, etc. definition in `.env` file makes you install and initialize WordPress site in first execution.

Stop services:

```zsh
make stop
```

Stop and remove containers, networks:
```zsh
make down
```

Stop and remove containers, networks, images, volumes (and `wp-config.php` if exists):
```zsh
make destroy
```
