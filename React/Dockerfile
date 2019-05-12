FROM node:12.2.0-alpine

COPY package.json yarn.lock /app/

WORKDIR /app

# Use Yarn instead of npm https://yarnpkg.com/en/docs/migrating-from-npm
RUN yarn global add serve && yarn install

COPY . /app

RUN yarn run build --production

CMD serve -s build

# Tell Docker about the port we'll run on.
EXPOSE 5000
