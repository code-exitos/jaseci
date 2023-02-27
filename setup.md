# How to setup a jac program

pip install jaseci-serv
​
## run the initial migrations

jsserv makemigrations
jsserv migrate
jsserv createsuperuser


jsserv runserver

## on another terminal
​
jsctl -m
​
login http://localhost:8000
​
## load an action (if required)
actions load module jac_nlp.use_qa
​
## build main.jac. After builind the compiled version will be availiable (main.jir)
jac build main.jac
​
## register the sentinel to know what program will be executed when calling the API
### In this case it will be main.jir 
sentinel register -set_active true -mode ir main.jir
sentinel set -snt active:sentinel -mode ir main.jir
​
## if we want to execute a walker from the CLI:
### this will run the walker called 'talker' and set the property named 'key' with the respective value
walker run talker -ctx "{\"name\":\"John Doe\"}"