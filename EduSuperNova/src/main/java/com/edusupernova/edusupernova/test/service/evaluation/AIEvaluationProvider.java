package com.edusupernova.edusupernova.test.service.evaluation;

public interface AIEvaluationProvider {
    String complete(String prompt);

    default String complete(String systemPrompt, String userPrompt) {
        return complete(systemPrompt + "\n\n" + userPrompt);
    }
}
