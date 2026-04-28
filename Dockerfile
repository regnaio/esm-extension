FROM node:22.22.2-bookworm-slim

ENV FORCE_COLOR=1

WORKDIR /app

COPY package.json tsconfig.json ./
COPY src ./src

RUN npm i

CMD ["npm", "run", "check"]
