node tags;
node tag {
    has name;
}

// connects branch node 'posts' to an individual post node
edge tags_tag{
    has id;
}

// connects post node to tag node
edge post_tag {
    has id;
}

