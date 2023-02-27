
import {*} with "./graph.jac";
import {*} with "./todos/walkers.jac";

// entrypoint wakler of the app
// the walker goes to the root node if it is not defined to go to another node first
walker init {
    root {
        // move to the app_root, if it can't move then create the app_graph node and connect it
        take --> node::app_root else{
            spawn here ++> graph::app_graph;
        }
    }
}