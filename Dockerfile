FROM oven/bun:1 AS build
WORKDIR /app
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile
COPY . .
ARG DATABASE_URL=postgresql://x:x@localhost/x
ENV DATABASE_URL=$DATABASE_URL
RUN bun run build

FROM oven/bun:1
WORKDIR /app
COPY --from=build --chown=bun:bun /app/build ./build
COPY --from=build --chown=bun:bun /app/node_modules ./node_modules
COPY --from=build --chown=bun:bun /app/drizzle ./drizzle
COPY --from=build --chown=bun:bun /app/drizzle.config.ts ./
COPY --chown=bun:bun package.json ./
USER bun
EXPOSE 3000
CMD ["sh", "-c", "bun run db:migrate && bun ./build/index.js"]
