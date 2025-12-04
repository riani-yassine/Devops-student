# Image officielle OpenJDK 17 (stable)
FROM openjdk:latest

# Répertoire de travail dans le conteneur
WORKDIR /app

# Copier le JAR généré par Maven
COPY target/foyer-0.0.2SNAPSHOT.jar app.jar

# Exposer le port de l'application
EXPOSE 8089

# Commande pour lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
