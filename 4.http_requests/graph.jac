import {*} with "./todos/graph.jac";

node app_root;

graph app_graph {
    has anchor app_root;

    spawn {
        // takes the definition of app_root
        app_root = spawn node::app_root;
        todos = spawn app_root ++> node::todos;
    }
}