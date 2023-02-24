FROM daynauth/jaseci_full

WORKDIR /app

COPY . .


RUN jsctl 
RUN jac dot faq_natural_language.jac
RUN actions load module jac_nlp.use_qa

CMD ["jac", "run", "faq_natural_language.jac"]