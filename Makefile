container:
	ssh-keygen -t rsa -f keys/docker_id_rsa
	docker-compose build

run:
	docker-compose up
