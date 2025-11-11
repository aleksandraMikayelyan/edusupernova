package model;

import java.time.LocalDate;

public class Test {
    private int id;
    private User user;
    private Subject subject;
    private LocalDate date;
    private int punctuation;

    public Test(int id, User user, Subject subject, LocalDate date, int punctuation) {
        this.id = id;
        this.user = user;
        this.subject = subject;
        this.date = date;
        this.punctuation = punctuation;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public User getUser() {
        return user;
    }
    public void setUser(User user) {
        this.user = user;
    }
    public Subject getSubject() {
        return subject;
    }
    public void setSubject(Subject subject) {
        this.subject = subject;
    }
    public LocalDate getDate() {
        return date;
    }
    public void setDate(LocalDate date) {
        this.date = date;
    }
    public int getPunctuation() {
        return punctuation;
    }
    public void setPunctuation(int punctuation) {
        this.punctuation = punctuation;
    }

    @Override
    public String toString() {
        return "Test{" +
                "id=" + id +
                ", user=" + user +
                ", subject=" + subject +
                ", date=" + date +
                ", punctuation=" + punctuation +
                '}';
    }
}
