walker create_statements_with_tags {
    can file.load_json;
    file_path = './tags_training.json';

  

    root: take -->[0];// if at root, walk to app_root node
    app_root: take --> node::statements; 

    statements{
        statement_nodes = --> node::statement; 
        for n in statement_nodes: destroy n; 


            statements_json = file.load_json(file_path); // get list of news posts

            for n in statements_json {
                // create post node with content from JSON
                statement_node = spawn node::statement(
                    text=n["description"]
                );

                 // connect statement node to 'statements'
                here +[statements_statement(id=statement_node.info['jid'])]+> statement_node;

                tag_name = n['tag'];
                subtag_name = n['subtag'];
              

                // TODO: First move to 'tags' node
                take -->node::app_root;
                take -->node::tags; 

                // get the list of tags
                tags = -->node::tag;
                
                actual_tag = None;
                // check if tag already exists
                // if it does, assign it to actual_tag
                for tag in tags{
                    if(tag.name == tag_name){
                        actual_tag = tag;
                    }
                }
                // if tag doesn't exist then create the new tag
                if(actual_tag == None){
                    actual_tag = spawn node::tag(name = tag_name);
                }

                // creating a link from 'tags' node to 'actual_tag'
                tags ++> actual_tag;
                // creating a link from 'statement_node' to 'actual_tag'
                statement_node ++> actual_tag;
                report statement_node;
            }
        
    }
}