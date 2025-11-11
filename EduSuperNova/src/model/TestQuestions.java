package model;

public class TestQuestions {
    private Test test;
    private Questions questions;
    private String user_answer;
    private boolean correct;
    private int punctuation_ia;
    private String feedback_ai;

    public TestQuestions(Test test, Questions questions, String user_answer, int punctuation_ia, String feedback_ai) {
        this.test = test;
        this.questions = questions;
        this.user_answer = user_answer;
        this.correct = false;
        this.punctuation_ia = punctuation_ia;
        this.feedback_ai = feedback_ai;
    }

    public Test getTest() {
        return test;
    }
    public void setTest(Test test) {
        this.test = test;
    }
    public Questions getQuestions() {
        return questions;
    }
    public void setQuestions(Questions questions) {
        this.questions = questions;
    }
    public String getUser_answer() {
        return user_answer;
    }
    public void setUser_answer(String user_answer) {
        this.user_answer = user_answer;
    }
    public boolean isCorrect() {
        return correct;
    }
    public void setCorrect(boolean correct) {
        this.correct = correct;
    }
    public int getPunctuation_ia() {
        return punctuation_ia;
    }
    public void setPunctuation_ia(int punctuation_ia) {
        this.punctuation_ia = punctuation_ia;
    }
    public String getFeedback_ai() {
        return feedback_ai;
    }
    public void setFeedback_ai(String feedback_ai) {
        this.feedback_ai = feedback_ai;
    }

    @Override
    public String toString() {
        return "TestQuestions{" +
                "test=" + test +
                ", questions=" + questions +
                ", user_answer='" + user_answer + '\'' +
                ", correct=" + correct +
                ", punctuation_ia=" + punctuation_ia +
                ", feedback_ai='" + feedback_ai + '\'' +
                '}';
    }
}
