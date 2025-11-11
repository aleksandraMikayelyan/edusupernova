package model;

public class Questions {
    private int id;
    private Subject subject;
    private String question;
    private enum type {
        multipleChoice, openEnded, logicalProblems
    }
    private String options;
    private String answer;
    private String prompt_ia;

    public Questions(int id, Subject subject, String question, String options, String answer, String promptIa) {
        this.id = id;
        this.subject = subject;
        this.question = question;
        this.options = options;
        this.answer = answer;
        this.prompt_ia = promptIa;
    }

    public int getId() {
        return id;
    }
    public Subject getSubject() {
        return subject;
    }
    public String getQuestion() {
        return question;
    }
    public String getOptions() {
        return options;
    }
    public String getAnswer() {
        return answer;
    }
    public String getPrompt_ia() {
        return prompt_ia;
    }
    public void setId(int id) {
        this.id = id;
    }
    public void setSubject(Subject subject) {
        this.subject = subject;
    }
    public void setQuestion(String question) {
        this.question = question;
    }
    public void setOptions(String options) {
        this.options = options;
    }
    public void setAnswer(String answer) {
        this.answer = answer;
    }
    public void setPrompt_ia(String prompt_ia) {
        this.prompt_ia = prompt_ia;
    }

    @Override
    public String toString() {
        return "Questions{" +
                "id=" + id +
                ", subject=" + subject +
                ", question='" + question + '\'' +
                ", options='" + options + '\'' +
                ", answer='" + answer + '\'' +
                ", prompt_ia='" + prompt_ia + '\'' +
                '}';
    }
}
