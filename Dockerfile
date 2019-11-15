FROM node:12.3.0-alpine AS serverless
RUN npm install -g serverless
WORKDIR /opt/app
