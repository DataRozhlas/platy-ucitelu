fields = <[plat-procent zak-per-ucitel  matematika  cteni veda  prumer]>
ig.processData = ->
  countries = d3.tsv.parse ig.data.zeme, (row) ->
    for field in fields
      row[field] = parseFloat row[field]
    row["plat-procent"] /= 100
    row
  budgets = d3.tsv.parse ig.data.urady, (row) ->
    row['rozpocet'] = parseInt row['rozpocet']
    row
  {countries, budgets}
