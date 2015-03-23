{countries, budgets} = ig.processData!
container = d3.select ig.containers.base
if window.location.hash == '#zaci'
  new ig.Chalkboard container, countries, budgets
else
  container.classed \money yes
  new ig.Chalkboard container, countries, budgets, money: 1
