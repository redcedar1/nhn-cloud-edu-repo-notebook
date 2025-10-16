FROM node:18-alpine
WORKDIR /app
RUN apk add --no-cache curl bash
COPY package*.json ./
RUN npm install
COPY server.js .
EXPOSE 8080
CMD ["node", "server.js"]
