{countries, budgets} = ig.processData!

if ig.containers['pupil-count']
  container = d3.select that
  new ig.Chalkboard container, countries, budgets

if ig.containers['money']
  container = d3.select that
  new ig.Chalkboard container, countries, budgets, money: 1
