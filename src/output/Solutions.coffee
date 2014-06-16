class Solutions
  constructor: (@input, @output) ->
    @solver = new c.SimplexSolver()
    @solver.autoSolve = false
    c.debug = true
    
  # Read commands
  read: (commands)-> 
    @lastInput = commands
    console.log("Solver input:", commands)
    for command in commands
      if command instanceof Array
        @process(subcommand) for subcommand in command
      else 
        @process(command)
    @solver.solve()
    console.log("Solver output", @solver._changed)
    @write(@solver._changed)
    return

  write: (results) ->
    @output.read(results) if @output

  clean: (id) ->

  process: (command) ->
    if command instanceof c.Constraint
      @solver.addConstraint(command)
    else if @[command[0]]
      @[command[0]].apply(@, Array.prototype.slice.call(command))

  edit: (variable) ->
    @solver.addEditVar(variable)

  suggest: (variable, value, strength, weight) ->
    @solver.solve()
    @edit(variable, @strength(strength), @weight(weight))
    @solver.suggestValue(variable, value)
    @solver.resolve()

  stay: (path, v) ->
    for i in [1..arguments.length]
      @solver.addStay(v)
    return

module.exports = Solutions