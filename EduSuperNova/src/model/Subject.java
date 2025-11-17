package model;

public class Subject {
    private int id;
    private String subjectName;
    private String description;
    private String subjectType;

    public Subject(){}
    public Subject(int id, String subjectName, String description, String subjectType) {
        this.id = id;
        this.subjectName = subjectName;
        this.description = description;
        this.subjectType = subjectType;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getSubjectName() {
        return subjectName;
    }
    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public String getSubjectType() {
        return subjectType;
    }
    public void setSubjectType(String subjectType) {
        this.subjectType = subjectType;
    }

    @Override
    public String toString() {
        return "Subject{" +
                "id=" + id +
                ", subjectName='" + subjectName + '\'' +
                ", description='" + description + '\'' +
                ", subjectType='" + subjectType + '\'' +
                '}';
    }
}

