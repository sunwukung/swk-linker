noop = () ->

makeNode = (curr, next, last) ->
  (args...) ->
    curr.apply(curr, [args, next, last])

###
takes a list of functions and returns a function
each function is provided arguments by the wrapping function i.e.

 function(args, next, done)
 - args: array of arguments
 - next: next function in list
 - done: last function in list

 if at the tail end of the list, then next and done will noop

###
module.exports = (links...) ->
  length = links.length
  index  = length - 1 # mutable
  last   = makeNode links[index], noop, noop
  linked = [last]

  while(index--)
    linked.unshift(makeNode(
      links[index],
      linked[0],
      last
      )
    )


  return linked[0]
