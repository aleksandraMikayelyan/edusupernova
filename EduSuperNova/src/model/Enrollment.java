package model;

import java.time.LocalDateTime;

public class Enrollment {
        private int userId;
        private int subjectId;
        private LocalDateTime enrolledAt;
        private double progress;           // 0.00 - 100.00 (opcional)
        private LocalDateTime lastActivity; // para estadísticas

        // Constructores
        public Enrollment() {}

        public Enrollment(int userId, int subjectId) {
            this.userId = userId;
            this.subjectId = subjectId;
            this.enrolledAt = LocalDateTime.now();
            this.progress = 0.0;
        }

        // Getters y Setters
        public int getUserId() { return userId; }
        public void setUserId(int userId) { this.userId = userId; }
        public int getSubjectId() { return subjectId; }
        public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
        public LocalDateTime getEnrolledAt() { return enrolledAt; }
        public void setEnrolledAt(LocalDateTime enrolledAt) { this.enrolledAt = enrolledAt; }
        public double getProgress() { return progress; }
        public void setProgress(double progress) { this.progress = progress; }
        public LocalDateTime getLastActivity() { return lastActivity; }
        public void setLastActivity(LocalDateTime lastActivity) { this.lastActivity = lastActivity; }

        @Override
        public String toString() {
            return "Enrollment{" +
                    "userId=" + userId +
                    ", subjectId=" + subjectId +
                    ", enrolledAt=" + enrolledAt +
                    ", progress=" + progress +
                    '}';
        }
    }

