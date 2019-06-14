FROM node:12.2.0-alpine as builder

COPY package.json /app/

WORKDIR /app

# Use Yarn instead of npm https://yarnpkg.com/en/docs/migrating-from-npm
RUN yarn install

COPY . /app

RUN yarn run build

FROM node:12.2.0-alpine

COPY --from=builder /app/dist/ /app/

RUN yarn global add serve

CMD serve -s /app

EXPOSE 5000
