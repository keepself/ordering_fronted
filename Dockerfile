FROM node:20

WORKDIR /app

COPY public public
COPY src src
COPY .env .
COPY babel.config.js .
COPY jsconfig.json .
COPY package-lock.json .
COPY package.json .
COPY vue.config.js .

RUN npm install

ENTRYPOINT [ "npm", "run", "serve" ]