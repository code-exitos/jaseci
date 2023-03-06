walker delete_posts {

    root: take -->[0];// if at root, walk to app_root node
    app_root: take --> node::posts; // if at app_root, walk to posts node

    posts{
        post_nodes = --> node::post; // grabs all connected post nodes connected to 'posts' as a list
        for n in post_nodes: destroy n; // delete all post nodes
        destroy here;
    }
}

walker delete_tags {
    root: take -->[0];// if at root, walk to app_root node
    app_root: take --> node::tags; 

    tags{
        tag_nodes = --> node::tag; // grabs all connected tag nodes connected to 'tags' as a list
        for n in tag_nodes: destroy n; // delete all tag nodes
        destroy here;
    }
}

walker delete_app_root {
    root: take --> [0];
    app_root: destroy here;
}
