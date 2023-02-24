import {*} with "./graph.jac";
import {*} with "./posts/walker.jac";

walker init{
    root{
        take --> node::app__root else { spawn here ++> graph::app_graph; }
    }
}