FROM moalhaddar/docx-to-pdf-base:1.0.0

WORKDIR /project
ENV LIBREOFFICE_BIN=/usr/lib/libreoffice/program/soffice

# 1. Cache dependencies
COPY pom.xml .
RUN mvn verify clean -Dmaven.artifact.threads=8 --fail-never

# 2. Copy source and build jar
COPY src ./src
RUN mvn package

# 3. Copy custom fonts into system directory and update font cache
COPY fonts /usr/share/fonts/truetype/custom/
RUN fc-cache -f -v

# 4. Final setup & cleanup
RUN cp ./target/*.jar ./app.jar
RUN rm -rf ./src ./pom.xml ./target

EXPOSE 8080

CMD ["java", "-jar", "./app.jar"]
