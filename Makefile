all:
	docker build -t gcornet .
	docker run -p 80:80 -p 443:443 -d gcornet

on:
	docker build --build-arg arg=on -t gcornet .
	docker run -p 80:80 -p 443:443 -d gcornet
off:
	docker build --build-arg arg=off -t gcornet .
	docker run -p 80:80 -p 443:443 -d gcornet

cleanI:
	docker rmi gcornet