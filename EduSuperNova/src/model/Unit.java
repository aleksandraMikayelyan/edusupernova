package model;

public class Unit {
    private int id;
    private String title;
    private int queue;
    private String summary;
    private Subject subject;

    public Unit(int id, String title, int queue, String summary, Subject subject) {
        this.id = id;
        this.title = title;
        this.queue = queue;
        this.summary = summary;
        this.subject = subject;
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public int getQueue() {
        return queue;
    }
    public void setQueue(int queue) {
        this.queue = queue;
    }
    public String getSummary() {
        return summary;
    }
    public void setSummary(String summary) {
        this.summary = summary;
    }
    public Subject getSubject() {
        return subject;
    }
    public void setSubject(Subject subject) {
        this.subject = subject;
    }
    @Override
    public String toString() {
        return "Unit{" + "id=" + id+ ", title=" + title + ", queue=" + queue+ ", summary=" + summary + ", subject=" + subject.toString() + '}';
    }
}
