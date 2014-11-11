# swk-linker

Creates a function from a list of functions.

Each function in the list will be provided three arguments  
The first argument is the arguments array passed in to the wrapper function  
the second argument is the next available function  
the last argument is the last available function  

calling the next function will (unsurprisingly) call the next function in the list  
calling the done function will (also unsurprisingly) call the last function  

    var linker = require("swk-linker")
    linked = linker(
        function (args, next, done) {
            // args === ['foo'] - see below
            next();
        },
        function (args, next, done) {
            done();
        },
        function (args, next, done) {
            // doesn't get called
        },
        function (args, next, done) {
            next() // noop
            done() // noop
        });

    linked('foo');
