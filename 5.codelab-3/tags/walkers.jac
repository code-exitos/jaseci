walker import_tags {
    can file.load_json;
    file_path = './tags_training.json';

    root: take -->[0];// if at root, walk to app_root node
    app_root: take --> node::tags; // if at app_root, walk to tags node

    tags{
        current_tag_nodes = --> node::tag;
        // tag_names = -->.name;
        for n in current_tag_nodes: destroy n;

        data = file.load_json(file_path); 

        for n in data {
            // check if tag exists
            tag_name = n['tag'];
            tag_nodes = --> node::tag;
            actual_tag = None;
            for tag in tag_nodes{
                if(tag.name == tag_name){
                    actual_tag = tag;
                    break;
                }
            }

            if(actual_tag == None){
                actual_tag =  spawn node::tag(
                    name = n['tag']
                );
                here +[tags_tag(id=actual_tag.info['jid'])]+> actual_tag;

            }
        
            subtag = spawn actual_tag walker::find_subtag(tag_name =n['subtag']);

            if(!subtag){
                subtag = spawn node::tag(name = n['subtag']);
                actual_tag <+[tags_tag(id=subtag.info['jid'])]+> subtag;
            }

            statement_node = spawn node::statement(text=n['description']);
            subtag ++> statement_node;

            // return the created node
            report actual_tag;
        }
        
    }
}
walker find_subtag {
    has anchor subtag;
    has tag_name;

    tag {
        subtags = -->node::tag;
        for subt in subtags{
            if(subt.name == tag_name){
                subtag = subt;
                disengage;
            }
        }
    }
}

walker create_tag {
    has name;
    root: take --> [0];
    app_root: take --> node::tags;

    tags {
        if(!name){
            report:status = 400;
            report "Missing required params";
            disengage;
        }
        nd = spawn node::tag(name = name );

        here  +[tags_tag(id = nd.info['jid'])]+> nd;

        report nd; 
        disengage;
    }
}

# node jid must be specified in nd param;
walker update_post {
    has name;

    post {
        if(name): here.name = name;
        report here;
        disengage;
    }
}

# node jid must be specified in nd param;
walker get_tag {
    tag {
        report here;
        disengage;
    }
}

walker list_tags {

    root: take --> [0];
    app_root: take --> node::tags;

    tags {
        report --> node::tag;
        disengage;
    }
}

// add subtag to node, jid has to be specified
walker add_subtag {

}

walker delete_tags {
    root: take -->[0];
    app_root: take --> node::tags;

    tags{
        tag_nodes = -->node::tag;
        for n in tag_nodes: destroy n;
    }
}

walker traverse_tags {
    root: take-->[0];
    app_root: take-->node::tags;

    tags {
        take-->;
    }

    tag {
        report here;
        take-->;
    }
}