FROM node:20 AS build

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

RUN yarn run build

FROM node:20-alpine

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

RUN ls -la ./dist
RUN ls -la ./node_modules

EXPOSE 3000

CMD ["yarn", "run", "start"]