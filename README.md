# 🌟 EduSuperNova

[![Landing Page Design](landing-design.png)](edusupernova.pdf)  

**Explode your mind with AI**  
Active Recall + Gemini AI = Your path to a 10/10.

EduSuperNova is my personal full-stack startup: an educational platform that makes studying addictive and effective. Read unit summaries, take personalized tests, get instant AI feedback—**all free**. Built with React (frontend), Java + JDBC (backend), MySQL (DB), and Gemini AI. Private for now; Android app incoming.

> **Read. Respond. Grow.**  
> Your knowledge, at the speed of light.

##  Quick Personal Setup (My Daily Workflow)

### 1. Backend (Java + DB)
- Crea/actualiza DB: `mysql -u root -p < sql/schema.sql` (incluye tablas Usuario, Asignatura, etc.).  
- Configura `src/main/resources/db.properties` (URL, user, pass).  
- Corre: `javac -cp .:mysql-connector.jar src/*.java && java -cp .:mysql-connector.jar Main`  
  - Endpoint clave: `POST /api/tests/generar` para tests aleatorios.

### 2. Frontend (React)
