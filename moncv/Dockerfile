# Étape 1 : choisir l'image de base
FROM nginx:alpine

# Étape 2 : supprimer le contenu par défaut de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Étape 3 : copier votre CV dans le dossier de Nginx
COPY . /usr/share/nginx/html

# Étape 4 : exposer le port
EXPOSE 80

# Étape 5 : démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
