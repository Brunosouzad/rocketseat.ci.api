# Etapa de construção
FROM node:18 AS build

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /usr/src/app

# Copiar os arquivos package.json e yarn.lock
COPY package.json yarn.lock ./

# Instalar as dependências
RUN yarn install

# Copiar o restante dos arquivos da aplicação
COPY . .

# Construir a aplicação
RUN yarn run build

# Etapa de produção
FROM node:18-alpine

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /usr/src/app

# Copiar os artefatos construídos da etapa anterior
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

# Listar os arquivos para verificar a cópia
RUN ls -la ./dist
RUN ls -la ./node_modules

# Expor a porta para a aplicação
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["yarn", "run", "start"]