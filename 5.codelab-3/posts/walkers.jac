walker import_news_data {
    has file_path;

    can file.load_json;

    root: take -->[0];// if at root, walk to app_root node
    app_root: take --> node:: posts; // if at app_root, walk to posts node

    posts{
        post_nodes = --> node::post; // grabs all connected post nodes connected to 'posts' as a list
        for n in post_nodes: destroy n; // delete all post nodes

        try{
            news_posts = file.load_json(file_path); // get list of news posts

            for n in news_posts {
                // create post node with content from JSON
                nd = spawn node::post(
                    title=n["title"],
                    description= n["description"],
                    source = n["source"],
                    link = n["link"],
                    image = n["image"],
                    published = n["published"],
                    code = n["code"]
                );

                // connect the new post node to the posts node that we're currently on
                // with an edge that is described by the id of the posts node
                here +[posts_post(id=nd.info['jid'])]+> nd;

                // return the created node
                report nd;
            }
        }else{
            report:status = 400;
            report "Invalid file path";
            disengage;
        }
    }
}

walker create_post {
    has title; 
    has description;
    has source;
    has link;
    has image;
    has published;
    has code;

    root: take --> [0];
    app_root: take --> node::posts;


    posts {
        if(!title || !description || !source || !published || !code){
            report:status = 400;
            report "Missing required parameters";
            disengage;
        }

        // create node
        nd = spawn node::post(
            title = title,
            description = description,
            source = source,
            published = published,
            code = code
        );

        if(link): nd.link = link;
        if(image): nd.image = image;

        here +[posts_post(id = nd.info['jid'])]+> nd; // creates the edge connect to posts node

        report nd;
        disengage;
    }
}

# node jid must be specified in nd param;
walker update_post {
    has title;
    has description;
    has source;
    has link;
    has image;
    has published;
    has code;

    post {
        if(title): here.title = title;
        if(description): here.description = description;
        if(source): here.source = source;
        if(link): here.link = link;
        if(image): here.image = image;
        if(published): here.published = published;
        if(code): here.code = code;

        report here;
        disengage;
    }
}

# node jid must be specified in nd param;
walker get_post {
    post {
        report here;
        disengage;
    }
}

walker list_posts {
    has paginated = false;
    has limit = 10;
    has offset = 0;

    root: take --> [0];
    app_root: take --> node::posts;

    posts {
        report --> node::post;
        disengage;
    }
}

# deletes post node; node jid must be specified in nd param;
walker delete_post {
    post {
        report here;
        destroy here;
        disengage;
    }
}


walker summarize_posts {
    can t5_sum.classify_text;

    root: take --> [0];
    app_root: take --> node::posts;

  
    posts {
        post_nodes = --> node::post;

        for n in post_nodes {
            if(!n.summary): n.summary = t5_sum.classify_text(text = n.description, min_length = 20, max_length = 60);
            std.log(n.summary);
            report n;
        }
    }
    // last version
    // posts {
    //     post_list = --> node::post;
        
    //     for post in post_list {
    //         take post;
    //     }
    // }

    // post {
    //     if(!here.summary){
    //         here.summary = t5_sum.classify_text(
    //         text = here.description,
    //         min_length = 20,
    //         max_length = 60
    //         );
    //     }
    // }
    

   
}

walker extract_topics {
    can t5_sum.classify_text;

    root: take --> [0];
    app_root: take --> node::posts;

  
    posts {
        post_list = --> node::post;
        
        for post in post_list {
            take post;
        }
    }

    post {
        if(!here.summary){
            here.summary = t5_sum.classify_text(
            text = here.description,
            min_length = 20,
            max_length = 60
            );
        }
    }
    

}

walker sanitize_description {
    can regex.sanitize_html_tags;
    root: take --> [0];
    app_root: take --> node::posts;

    post_list = -->node::post;

    for n in post_list {
        if(n.description){
            report "before sanitized";
            report n;

            sanitized=regex.sanitize_html_tags(n.description);
            n.description = sanitized;
            report "after sanitized";
            report n;
        }
       

    }
}

walker add_tags_to_posts {
    can sbert_sim.get_text_sim;
    app_root = None;
    post_nodes = None;
    tag_nodes = None;
    root{
        node_list = --> node::app_root;
        app_root = node_list[0];
        take app_root;
    } 

    app_root {
        post_nodes = spawn here walker::get_posts;
        tag_nodes = spawn here walker::get_tags;

        for post_node in post_nodes {
            summary = post_node.summary;
            
            for tag_node in tag_nodes {
                statements = spawn tag_node walker::get_statements;
                for stmt in statements {
                    sim = sbert_sim.get_text_sim(summary,stmt.text,1).dict::values[0][0].dict::values[1];
                    // if sim_score is greater than 0.4, then connect that post node to the tag
                    if(sim > 0.4){
                        post_node ++> tag_node;
                    }

                }
            }
        }

    }
  
}

walker get_posts {
    has anchor post_nodes;

    app_root: take --> node::posts;

    posts {
        post_nodes = -->node::post;
        disengage;
    }
}

walker get_tags {
    has anchor tag_nodes;

    app_root: take --> node::tags;

    tags {
        tag_nodes = -->node::tag;
        disengage;
    }
}

walker get_statements {
    // this denotes its return var
    has anchor statements;
    tag {
        statements = --> node::statement;
        disengage;
    }
}

walker get_sim_score{
    can sbert_sim.get_text_sim;
    text = "dancing";
    sim = sbert_sim.get_text_sim("dancing","paefaefae",1).dict::values[0][0].dict::values[1];
    report sim;
    // report sim[0].sim_score;
    // report sbert_sim.get_text_sim("dancing","dancing",1)['d']['sim_score'];
}
