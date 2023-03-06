// * imports everything from that file
import {*} with "./posts/graph.jac";
import {*} with "./tags/graph.jac";
import {*} with "./statements/graph.jac";
node app_root;

graph app_graph {
    has anchor app_root;

    spawn {
        // takes the definition of app_root
        app_root = spawn node::app_root;
        posts = spawn app_root ++> node::posts;
        tags = spawn app_root ++> node::tags;
        statements = spawn app_root ++> node::statements;
    }
}