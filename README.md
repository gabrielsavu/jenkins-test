Build with:

```bash
mvn clean compile assembly:single
docker build -t test-jenkins --platform linux/amd64 .
```