FROM node:13-alpine AS build
  RUN apk --no-cache add git

  WORKDIR /app

  # COMIT_REF can also be master but im pinning so I know it wuii build in the future.
  ARG COMMIT_REF=v0.14.2
  RUN git clone --depth=1 --branch=$COMMIT_REF https://github.com/excalidraw/excalidraw.git . \
    && rm -rf .git

  RUN npm install
  # RUN npm run test:all
  RUN npm run build:app

FROM nginx:1.23.3-alpine AS runtime
  COPY --from=build /app/build/ /usr/share/nginx/html