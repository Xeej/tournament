bash:
	docker-compose run --rm web bash

web:
	docker-compose up -d
	docker attach tournament_web_1
