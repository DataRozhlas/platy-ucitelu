fields = <[plat-procent zak-per-ucitel  matematika  cteni veda  prumer]>
ig.processData = ->
  d3.tsv.parse ig.data.zeme, (row) ->
    for field in fields
      row[field] = parseFloat row[field]
    row["plat-procent"] /= 100
    row
