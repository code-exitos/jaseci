node faq_root:cai_state {
    can use.qa_classify;
    can nlu {
        if (!visitor.wlk_ctx["prev_state"]) {
            answers = -->.answer;
            best_answer = use.qa_classify(
                text = visitor.question,
                classes = answers
            );
            visitor.wlk_ctx["intent"] = best_answer["match"];
        }
    }
    can process {
        if (visitor.wlk_ctx["prev_state"]): visitor.wlk_ctx["respond"] = true;
        else {
            for n in --> {
                if (n.context["answer"] == visitor.wlk_ctx["intent"]){
                    visitor.wlk_ctx["next_state"] = n;
                    break;
                }
            }
            visitor.wlk_ctx["prev_state"] = here;
        }
    }
    can nlg {
        visitor.response = "I can answer a variety of FAQs related to Tesla. What can I help you with?";
    }
}

node faq_state:cai_state {
    has question;
    has answer;
    can nlg {
        visitor.response = here.answer;
    }
}

graph faq {
    has anchor faq_root;

    spawn {
        // Spawning the nodes
        faq_root = spawn node::faq_root;
    }
}

// the walker is called init
walker init {

    root {
        spawn here ++> graph::faq;
        // passing the name of the json with the knowledge base to the ingest_faq walker
        spawn here walker::ingest_faq(kb_file="tesla_faq.json");
        spawn here walker::ask;
    }
}

walker ask {
    can use.qa_classify;
    has question;
    root {
        question = std.input("AMA > ");
        take --> node::faq_root;
    }
    faq_root {
        // -->.answer collects the answer variable of all of the nodes that are connected to here/faq_root with a --> connection.
        answers = -->.answer;

        // use.qa_classify is one of the action supported by the USE QA action set. 
        // It takes in a question and a list of candidate answers and return the most relevant one.
        best_answer = use.qa_classify(
            text = question,
            classes = answers
        );
        take --> node::faq_state(answer==best_answer["match"]);
    }
    faq_state {:
        std.out(here.answer);
    }
}

walker ingest_faq {
    // knowledge base file
    has kb_file;
    root: take --> node::faq_root;
    faq_root {
        kb = file.load_json(kb_file);
        for faq in kb {
            // instead of passing the question and answer here, we just pass the answer, since the AI takes the input of the user 
            // and selects the best answer based on the question
            answer = faq["answer"];
            spawn here ++> node::faq_state(answer=answer);
        }
    }
}