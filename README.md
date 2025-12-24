# 🌟 EduSuperNova

[![Landing Page Design](landing-design.png)](edusupernova.pdf)  

**Explode your mind with AI**  
Active Recall + Gemini AI = Your path to a 10/10.

EduSuperNova is my personal full-stack startup: an educational platform that makes studying addictive and effective. Read unit summaries, take personalized tests, get instant AI feedback—**all free**. Built with React (frontend), Java + JDBC (backend), MySQL (DB), and Gemini AI. Private for now; Android app incoming.

> **Read. Respond. Grow.**  
> Your knowledge, at the speed of light.

##  Quick Personal Setup (My Daily Workflow)

### 1. Backend (Java + DB)

# Getting Started

### Reference Documentation
For further reference, please consider the following sections:

* [Official Apache Maven documentation](https://maven.apache.org/guides/index.html)
* [Spring Boot Maven Plugin Reference Guide](https://docs.spring.io/spring-boot/4.0.1/maven-plugin)
* [Create an OCI image](https://docs.spring.io/spring-boot/4.0.1/maven-plugin/build-image.html)

### Maven Parent overrides

Due to Maven's design, elements are inherited from the parent POM to the project POM.
While most of the inheritance is fine, it also inherits unwanted elements like `<license>` and `<developers>` from the parent.
To prevent this, the project POM contains empty overrides for these elements.
If you manually switch to a different parent and actually want the inheritance, you need to remove those overrides.

- Crea/actualiza DB: `mysql -u root -p < sql/schema.sql` (incluye tablas Usuario, Asignatura, etc.).  
- Configura `src/main/resources/db.properties` (URL, user, pass).  
- Corre: `javac -cp .:mysql-connector.jar src/*.java && java -cp .:mysql-connector.jar com.edusupernova.project.Main`  
  - Endpoint clave: `POST /main.controller/tests/generar` para tests aleatorios.

### 2. Frontend (React)
