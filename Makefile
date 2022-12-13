include .env

up:
	docker compose up -d
	docker compose exec wp bash ./install.sh

stop:
	docker compose stop

down:
	docker compose down

destroy:
	docker compose down --rmi all --volumes --remove-orphans
	rm ./public/wp-config.php
