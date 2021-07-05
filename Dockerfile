FROM node:16-alpine3.11

WORKDIR /app

COPY web/package.json package.json 

RUN npm install

COPY web/main.js main.js

CMD ["node", "main.js"]