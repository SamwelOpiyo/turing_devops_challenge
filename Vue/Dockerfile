FROM node:12.2.0-alpine

COPY package.json /app/

WORKDIR /app

# Use Yarn instead of npm https://yarnpkg.com/en/docs/migrating-from-npm
RUN yarn install

COPY . /app

# RUN yarn run build

CMD yarn run serve --host 0.0.0.0

EXPOSE 8080
