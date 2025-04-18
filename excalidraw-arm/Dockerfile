# 构建阶段
FROM arm64v8/node:18 AS build  
# 使用适用于 ARM 架构的 Node 镜像

WORKDIR /opt/node_app

COPY . .

# do not ignore optional dependencies:
# Error: Cannot find module @rollup/rollup-linux-x64-gnu
RUN yarn --network-timeout 600000

ARG NODE_ENV=production

RUN yarn build:app:docker

# 运行阶段
FROM arm64v8/nginx:1.27-alpine  
# 使用适用于 ARM 架构的 Nginx 镜像

COPY --from=build /opt/node_app/excalidraw-app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1

