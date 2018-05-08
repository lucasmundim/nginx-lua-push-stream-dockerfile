build:
	docker build -t lucasmundim/nginx-lua-push-stream .

run:
	docker run -p 8443:443 -p 8080:80 --rm -it lucasmundim/nginx-lua-push-stream

push:
	docker push lucasmundim/nginx-lua-push-stream
