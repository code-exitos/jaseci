FROM jaseci/jaseci

WORKDIR /app

COPY . .

RUN jsctl 

RUN jac dot faq.jac

CMD ["jac", "run", "faq.jac"]