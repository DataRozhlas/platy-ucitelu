class ig.Chalkboard
  (@parentElement, @countries, @budgets) ->
    @element = @parentElement.append \div
      ..attr \class \content
    @svg = @element.append \svg
      ..attr \width 1000
      ..attr \height 600
    @initFilter!
    @drawZakPerUcitelLine!
    @initComputeRatioText!
    @computeForRatio 15

  computeForRatio: (ratio) ->
    avgPay          = 23705
    currentTeachers = 119426
    students        = currentTeachers * 14
    newTeachers     = students / ratio
    teachersToHire  = Math.round newTeachers - currentTeachers
    taxes           = 0.34
    avgPayTax       = Math.round avgPay * taxes
    @explanatoryTextG.classed \disabled teachersToHire == 0
    @teachersToHire.text ig.utils.formatNumber Math.abs teachersToHire
    @teachersToHireText.text if teachersToHire > 0
      ". . . . . učitelů by bylo potřeba najmout"
    else
      ". . . . . učitelů by bylo možné propustit"
    totalPrice = Math.abs teachersToHire * (avgPay + avgPayTax) * 12
    @totalCost.text ig.utils.formatNumber totalPrice

    @totalCostText.text if teachersToHire > 0
      "jsou celkové roční náklady"
    else
      "je celková roční úspora"
    budget = @getClosestBudget totalPrice
    @budgetText.text "To je přibližně rozpočet #{budget.urad}"

  getClosestBudget: (amount) ->
    currentDiff = Infinity
    for {rozpocet}:budget, index in @budgets
      d = Math.abs rozpocet - amount
      if d > currentDiff
        return @budgets[index - 1]
      else
        currentDiff = d
    return budget

  initComputeRatioText: ->
    @explanatoryTextG = g = @svg.append \g
      .attr \class "explanatory-text disabled"
      .attr \transform "translate(60, 400)"
    @teachersToHire = g.append \text
      .text "9 187"
      .attr \text-anchor \end
      .attr \x 120
      .attr \y 0
    @teachersToHireText = g.append \text
      .text ". . . . . učitelů by bylo potřeba najmout"
      .attr \x 112
      .attr \y 0
    g.append \text
      .text "×"
      .attr \text-anchor \end
      .attr \x 15
      .attr \y 34
    g.append \text
      .text "31 765"
      .attr \text-anchor \end
      .attr \x 120
      .attr \y 34
    g.append \text
      .text ". . . . . je jejich průměrná superhrubá mzda"
      .attr \x 112
      .attr \y 34
    g.append \text
      .text "×"
      .attr \text-anchor \end
      .attr \x 15
      .attr \y 34 * 2
    g.append \text
      .text "12"
      .attr \text-anchor \end
      .attr \x 120
      .attr \y 34 * 2
    g.append \text
      .text ". . . . . měsíců"
      .attr \x 112
      .attr \y 34 * 2
    g.append \rect
      .attr \filter 'url(#chalk)'
      .attr \x -20
      .attr \y 34 * 2 + 10
      .attr \width 144
      .attr \height 2
    @totalCost = g.append \text
      .attr \class \sum
      .text "3 501 900 660"
      .attr \text-anchor \end
      .attr \x 120
      .attr \y 34 * 3 + 10
    g.append \text
      .attr \class \sum
      .text "Kč"
      .attr \x 132
      .attr \y 34 * 3 + 10
    g.append \text
      .text ".."
      .attr \x 162
      .attr \letter-spacing 8
      .attr \y 34 * 3 + 10
    @totalCostText = g.append \text
      .text "jsou celkové roční náklady"
      .attr \x 189
      .attr \y 34 * 3 + 10
    @budgetText = g.append \text
      .attr \x 180
      .attr \y 34 * 4 + 20
    g.selectAll \text .attr \filter 'url(#chalk-text)'

  drawZakPerUcitelLine: ->
    grouped_assoc = {}
    for country in @countries
      grouped_assoc[country['zak-per-ucitel']] ?= []
      grouped_assoc[country['zak-per-ucitel']].push country
    grouped = for ratio, countries of grouped_assoc
      ratio = countries.0.['zak-per-ucitel']
      {'zak-per-ucitel': ratio, countries}
    margin = 60
    width = 1000 - 2 * margin
    width = 650
    cz = @countries[0]
      ..countries = [@countries[0]]
    grouped.push cz
    xScale = d3.scale.linear!
      ..domain d3.extent @countries.map (.['zak-per-ucitel'])
      ..range [width, 0]

    group = @svg.append \g
      ..attr \class \zak-per-ucitel
      ..attr \transform "translate(#margin,50)"
    group
      ..append \text
        ..attr \filter 'url(#chalk-text)'
        ..text "Současný počet žáků na jednoho učitele: 14"
        ..attr \font-size 30
        ..attr \fill \white
        ..attr \x -7
        ..attr \y 0
    group.append \g
      ..attr \transform "translate(0, 20)"
      ..append \rect
        ..attr \filter 'url(#chalk)'
        ..attr \x 0
        ..attr \y 40
        ..attr \width width
        ..attr \height 2
      ..attr \class "line zak-per-ucitel"
      ..selectAll \g.tick .data grouped .enter!append \g
        ..attr \class "tick active"
        ..classed \cz -> it.zeme == "Česko"
        ..attr \transform -> "translate(#{xScale it['zak-per-ucitel']}, 0)"
        ..append \rect
          ..attr \filter 'url(#chalk)'
          ..attr \x 0
          ..attr \y -> 34 + Math.round Math.random! * 2
          ..attr \width 2
          ..attr \height -> 11 + Math.round Math.random! * 2
        ..append \text
          ..attr \class \country
          ..attr \font-size 20
          ..attr \y 70
          ..text -> it.countries.map (.zeme) .join ", "
          ..attr \transform " rotate(40,0,60)"
          ..attr \filter 'url(#chalk-text)'
        ..append \text
          ..attr \class \count
          ..attr \y 30
          ..attr \font-size 17
          ..attr \letter-spacing 2
          ..attr \filter 'url(#chalk-text)'
          ..attr \text-anchor \middle
          ..text -> it['zak-per-ucitel']


  initFilter: ->
    @svg.append \filter
      ..attr \id \chalk
      ..attr \height 2
      ..attr \width 1.6
      ..attr \color-interpolation-filters \sRGB
      ..attr \y -0.5
      ..attr \x -0.3
      ..append \feTurbulence
        ..attr \baseFrequency "0.4"
        ..attr \type "fractalNoise"
        ..attr \seed "0"
        ..attr \numOctaves "5"
        ..attr \result "result1"
      ..append \feOffset
        ..attr \dx "-6"
        ..attr \dy "-5"
        ..attr \result "result2"
      ..append \feDisplacementMap
        ..attr \xChannelSelector "R"
        ..attr \yChannelSelector "G"
        ..attr \scale "5"
        ..attr \in "SourceGraphic"
        ..attr \in2 "result1"
    @svg.append \filter
      ..attr \id \chalk-text
      ..attr \height 2
      ..attr \width 1.6
      ..attr \color-interpolation-filters \sRGB
      ..attr \y -0.5
      ..attr \x -0.3
      ..append \feTurbulence
        ..attr \baseFrequency "0.4"
        ..attr \type "fractalNoise"
        ..attr \seed "0"
        ..attr \numOctaves "5"
        ..attr \result "result1"
      ..append \feOffset
        ..attr \dx "-6"
        ..attr \dy "-5"
        ..attr \result "result2"
      ..append \feDisplacementMap
        ..attr \xChannelSelector "R"
        ..attr \yChannelSelector "G"
        ..attr \scale "2"
        ..attr \in "SourceGraphic"
        ..attr \in2 "result1"
