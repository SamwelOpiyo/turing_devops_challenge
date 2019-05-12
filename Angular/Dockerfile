FROM node:11-alpine

COPY package.json yarn.lock /app/

WORKDIR /app

# Use Yarn instead of npm https://yarnpkg.com/en/docs/migrating-from-npm
RUN yarn install

COPY . /app

# RUN yarn build --prod

CMD yarn run start --host 0.0.0.0

EXPOSE 4200
