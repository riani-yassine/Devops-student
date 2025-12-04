# Image officielle OpenJDK 17 (stable)
FROM openjdk:17-jdk-slim

# Répertoire de travail
WORKDIR /app

# Copier le jar Maven buildé
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Exposer le port de ton application
EXPOSE 8089

# Commande pour démarrer ton application
ENTRYPOINT ["java","-jar","app.jar"]
