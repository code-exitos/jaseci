
// todos node will be a branch node, where we can go to a particular area to do the processing
node todos;
node todo {
    // has keyword is used to define attributes
    has id;
    has userId;
    has title;
    has completed;

}

// connects branch node 'todos' to an individual todo
edge todos_todo{
    has id;
}