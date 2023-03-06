// definition of all the nodes and the edges

// simplest definition for a node

// posts node will be a branch node, where we can go to a particular area to do the processing
node posts;
node post {
    // has keyword is used to define attributes
    has title;
    has description;
    has source; 
    has link;
    has image;
    has published;
    has code;
    has summary;
}

// connects branch node 'posts' to an individual post node
edge posts_post{
    has id;
}