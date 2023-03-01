// gets a list of todos from a url
// when calling walker you need to pass the url:string and headers:Object (headers can be empty {})
walker import_todos {
    has url;
    has headers;

    
    root: take -->[0];// if at root, walk to app_root node
    app_root: take --> node::todos; // if at app_root, walk to todos node

    todos {
        todo_nodes = --> node::todo; // grabs all connected todo nodes connected to 'todos' as a list
        for n in todo_nodes: destroy n; // delete all todo nodes

            // making a get request to get a list of todos and then create the nodes and connect them to 'todos' node
            todos = request.get(url, {}, {}).response;// get list of todos from url
            // report todos;

            for n in todos {
                report n;
                nd = spawn node::todo(
                    userId=n["userId"],
                    id= n["id"],
                    title = n["title"],
                    completed = n["completed"]
                );

                // connect the new todo node to the todos node that we're currently on
                // with an edge that is described by the id of the todos node
                here +[todos_todo(id=nd.info['jid'])]+> nd;

                // report the created node
                report nd;
            }
      
    }

}

walker post_todo {
    has uid;
    has title;
    has completed = false;
    has id;
    has url = "https://jsonplaceholder.typicode.com/todos";
    has headers = {};

    data =  {"userId": uid, "title": title, "completed": completed, "id": id};
    report data;
    report request.post(url, {}, headers);
}

// example for post payload:
// {
//     "name": "post_todo",
//     "ctx": {
//         "uid": -1, "title": "todo test", "completed": false, "id": -1
//     }
// }

# node jid must be specified in nd param;
walker todo {
    todo {
        report here;
        disengage;
    }
}

walker list_todos {

    root: take --> [0];
    app_root: take --> node::todos;

    todos {
        todos_list = --> node::todo; // get a list of todos
        report todos_list;
        disengage;
    }
}


# deletes todo node from graph; node jid must be specified in nd param;
walker delete_todo{
    todo{
        report here;
        destroy here;
        disengage;
    }
}