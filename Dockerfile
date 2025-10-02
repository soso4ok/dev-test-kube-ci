# syntax=docker/dockerfile:1

# === Build stage ===
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci
COPY tsconfig*.json ./
COPY src ./src
RUN npm run build

# === Production stage ===
FROM node:20-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app

RUN addgroup -S nodegrp && adduser -S nodeusr -G nodegrp

COPY --from=build /app/package*.json ./
RUN npm ci --omit=dev
COPY --from=build /app/dist ./dist

USER nodeusr
EXPOSE 3000
CMD ["node", "dist/main.js"]
