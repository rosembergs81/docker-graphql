FROM node:19-alpine3.15 AS dev-deps
WORKDIR /app
COPY graphql-actions/package.json graphql-actions/yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:19-alpine3.15 AS builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY graphql-actions/ .
RUN yarn build

FROM node:19-alpine3.15 AS prod-deps
WORKDIR /app
COPY graphql-actions/package.json graphql-actions/yarn.lock ./
RUN yarn install --production --frozen-lockfile

FROM node:19-alpine3.15 AS prod
WORKDIR /app
EXPOSE 3000
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD ["node", "dist/main.js"]

