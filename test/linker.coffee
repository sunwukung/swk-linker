{expect} = require "chai"
sinon = require "sinon"
linker = require "../lib/linker"

describe "linker", ->
  it "is a function", ->
    expect(linker).to.be.a "function"

  it "takes one or more functions and returns a function", ->
    a = ->
    b = ->
    linked = linker a, b
    expect(linked).to.be.a "function"

  it "which, when invoked, will invoke the first function in the list", ->
    a = sinon.spy()
    b = ->
    linked = linker a, b
    linked()
    expect(a.called).to.equal true

  it "each function receives three arguments, array, the next function and the last function", ->
    a = (args, next, done) -> next(args)
    b = (args, next, done) -> next.apply(next, args[0])
    c = (args, next, done) -> next("finally")

    aSpy = sinon.spy(a)
    bSpy = sinon.spy(b)
    cSpy = sinon.spy(c)

    linked = linker aSpy, bSpy, cSpy
    linked("foo")

    expect(aSpy.called).to.equal true
    aCall = aSpy.getCall(0)
    expect(aCall.args[0]).to.be.a "array"
    expect(aCall.args[1]).to.be.a "function"
    expect(aCall.args[2]).to.be.a "function"

    expect(bSpy.called).to.equal true
    bCall = bSpy.getCall(0)
    expect(bCall.args[0]).to.be.a "array"
    expect(bCall.args[1]).to.be.a "function"
    expect(bCall.args[2]).to.be.a "function"

    expect(cSpy.called).to.equal true
    cCall = cSpy.getCall(0)
    expect(cCall.args[0]).to.be.a "array"
    expect(cCall.args[1]).to.be.a "function"
    expect(cCall.args[2]).to.be.a "function"


  it "if any function calls done, it will jump to the end of the list", ->
    a = (args, next, done) -> done(args)
    b = (args, next, done) -> console.log "will not get called"
    c = (args, next, done) -> next("finally")

    aSpy = sinon.spy(a)
    bSpy = sinon.spy(b)
    cSpy = sinon.spy(c)

    linked = linker aSpy, bSpy, cSpy
    linked("foo")

    expect(aSpy.called).to.equal true
    expect(cSpy.called).to.equal true
    expect(bSpy.called).to.equal false
