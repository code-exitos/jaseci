node statements;

node statement {
    has text;
}

// connects parent node 'statements' to children nodes 'statement'
edge statements_statement {
    has id;
}

// connects node 'statement' to node 'tag'
edge statement_tag {
    has id;
}