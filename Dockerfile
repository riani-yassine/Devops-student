# Image officielle OpenJDK 17 (stable)
FROM eclipse-temurin:17-jdk

# Répertoire de travail
WORKDIR /app

# Copier le jar Maven buildé
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Exposer le port de ton application
EXPOSE 8089

# Commande pour démarrer ton application
ENTRYPOINT ["java","-jar","app.jar"]
