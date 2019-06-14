FROM node:11-alpine as builder

COPY package.json yarn.lock /app/

WORKDIR /app

# Use Yarn instead of npm https://yarnpkg.com/en/docs/migrating-from-npm
RUN yarn install

COPY . /app

# When yarn is used, it raises API fatal error handler returned after process out of memory on the background thread
RUN npm run build --prod

FROM node:12.2.0-alpine

COPY --from=builder /app/dist/ /app/

RUN yarn global add serve

CMD serve -s /app

EXPOSE 5000
