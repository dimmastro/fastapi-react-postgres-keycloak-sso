# Build stage
FROM node:16 as build
WORKDIR /app
COPY ./app/ /app
RUN npm ci
RUN npm run build

# Nginx stage
FROM nginx
COPY ./nginx.conf /etc/nginx/conf.d/angular.conf
COPY --from=build /app/build /usr/share/nginx/html
RUN chmod -R o+r /usr/share/nginx/html/