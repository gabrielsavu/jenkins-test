FROM azul/zulu-openjdk-alpine:11 as packager

RUN { \
        java --version ; \
        echo "jlink version:" && \
        jlink --version ; \
    }

ENV JAVA_MINIMAL=/opt/jre

RUN jlink \
    --verbose \
    --add-modules \
        java.base,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument \
    --compress 2 \
    --strip-debug \
    --no-header-files \
    --no-man-pages \
    --output "$JAVA_MINIMAL"

FROM alpine

ENV JAVA_MINIMAL=/opt/jre
ENV PATH="$PATH:$JAVA_MINIMAL/bin"

COPY --from=packager "$JAVA_MINIMAL" "$JAVA_MINIMAL"
COPY "target/test-jenkins.jar" "/app.jar"

CMD [ "-jar", "/app.jar" ]
ENTRYPOINT [ "java" ]