class ig.Chalkboard
  (@parentElement, @countries, @budgets, @display) ->
    @isMoney = @display?money
    @element = @parentElement.append \div
      ..attr \class \content
    @svg = @element.append \svg
      ..attr \width 1000
      ..attr \height 600
    @initFilter!
    if @isMoney
      @drawMoneyLine!
      @initMoneyText!
      @computeForPercentage 1
    else
      @drawZakPerUcitelLine!
      @initComputeRatioText!
      @computeForRatio 14

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
      ". . . . učitelů by bylo potřeba najmout"
    else
      ". . . . učitelů by bylo možné propustit"
    totalPrice = Math.abs teachersToHire * (avgPay + avgPayTax) * 12
    @totalCost.text ig.utils.formatNumber totalPrice

    @totalCostText.text if teachersToHire > 0
      "jsou celkové roční náklady"
    else
      "je celková roční úspora"
    budget = @getClosestBudget totalPrice
    @budgetText.text "To je přibližně rozpočet #{budget.urad}"
    @headingText.text if teachersToHire == 0
      "Současný počet žáků na jednoho učitele: 14"
    else
      "Vypočtený počet žáků na jednoho učitele: #{ratio}"

  computeForPercentage: (percentage) ->
    avgNational = 25218
    currentPay = 23705
    newPay = avgNational * percentage
    pricePerTeacher = Math.round newPay - currentPay
    numTeachers = 119426
    price = numTeachers * pricePerTeacher * 12

    @explanatoryTextG.classed \disabled price == 0
    if price == 0
      @headingText.html "Současný průměrný učitelský plat: 23 705 Kč (94 % národního průměru)"
    else
      @headingText.html "Nový učitelský plat: #{ig.utils.formatNumber newPay} Kč (#{Math.round percentage * 100} % národního průměru)"
    @amountToRaise.text ig.utils.formatNumber Math.abs pricePerTeacher
    @amountToRaiseText.text if pricePerTeacher > 0
      ". . . . by každý učitel dostal přidáno"
    else
      ". . . . by každý učitel ztratil"
    @totalCostText.text if pricePerTeacher > 0
      "jsou celkové roční náklady"
    else
      "je celková roční úspora"
    budget = @getClosestBudget Math.abs price
    @totalCost.html ig.utils.formatNumber Math.abs price
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


  initMoneyText: ->
    @explanatoryTextG = g = @svg.append \g
      .attr \class "explanatory-text disabled"
      .attr \transform "translate(60, 366)"
    @amountToRaise = g.append \text
      .text "9 187"
      .attr \text-anchor \end
      .attr \x 120
      .attr \y 0
    @amountToRaiseText = g.append \text
      .text ". . . . by každý učitel dostal přidáno"
      .attr \x 126
      .attr \y 0
    g.append \text
      .text "×"
      .attr \text-anchor \end
      .attr \x 15
      .attr \y 34
    g.append \text
      .text "1,37"
      .attr \text-anchor \end
      .attr \x 120
      .attr \y 34
    g.append \text
      .text ". . . . sociální a zdravotní pojištění"
      .attr \x 126
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
      .text ". . . . měsíců"
      .attr \x 126
      .attr \y 34 * 2
    g.append \text
      .text "×"
      .attr \text-anchor \end
      .attr \x 15
      .attr \y 34 * 3
    g.append \text
      .text "119 426"
      .attr \text-anchor \end
      .attr \x 120
      .attr \y 34 * 3
    g.append \text
      .text ". . . . učitelů"
      .attr \x 126
      .attr \y 34 * 3

    g.append \rect
      .attr \filter 'url(#chalk)'
      .attr \x -20
      .attr \y 34 * 3 + 10
      .attr \width 144
      .attr \height 2
    @totalCost = g.append \text
      .attr \class \sum
      .text "3 501 900 660"
      .attr \text-anchor \end
      .attr \x 120
      .attr \y 34 * 4 + 10
    g.append \text
      .attr \class \sum
      .text "Kč"
      .attr \x 132
      .attr \y 34 * 4 + 10
    g.append \text
      .text ".."
      .attr \x 162
      .attr \letter-spacing 8
      .attr \y 34 * 4 + 10
    @totalCostText = g.append \text
      .text "jsou celkové roční náklady"
      .attr \x 189
      .attr \y 34 * 4 + 10
    @budgetText = g.append \text
      .attr \x 180
      .attr \y 34 * 5 + 20
    g.selectAll \text .attr \filter 'url(#chalk-text)'

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
      .text ". . . . učitelů by bylo potřeba najmout"
      .attr \x 126
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
      .text ". . . . je jejich průměrná superhrubá mzda"
      .attr \x 126
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
      .text ". . . . měsíců"
      .attr \x 126
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

  drawMoneyLine: ->
    grouped_assoc = {}
    for country in @countries
      grouped_assoc[country['plat-procent']] ?= []
      grouped_assoc[country['plat-procent']].push country
    grouped = for ratio, countries of grouped_assoc
      ratio = countries.0.['plat-procent']
      {'plat-procent': ratio, countries}
    for i in [0.8 1.45 1.65 1.70 1.75 1.80 1.85 1.90 2.05 2.10 2.15]
      grouped.push {'plat-procent': i, isBogus: yes}

    extent = d3.extent grouped.map (.['plat-procent'])
    margin = 60
    width = 880
    xScale = d3.scale.linear!
      ..domain extent
      ..range [0, width]
    group = @svg.append \g
      ..attr \class \zak-per-ucitel
      ..attr \transform "translate(#margin,50)"
    @headingText = group.append \text
      ..attr \filter 'url(#chalk-text)'
      ..text "Současný průměrný učitelský plat: 23 705 Kč (94 % národního průměru)"
      ..attr \font-size 30
      ..attr \fill \white
      ..attr \x -7
      ..attr \y 0
    sgroup = group.append \g
      ..attr \transform "translate(0, 20)"
      ..append \rect
        ..attr \filter 'url(#chalk)'
        ..attr \x 0
        ..attr \y 40
        ..attr \width width
        ..attr \height 2
      ..attr \class "line plat-procent"
    ticks = sgroup.selectAll \g.tick .data grouped .enter!append \g
        ..attr \class "tick"
        ..classed \active-count -> it['plat-procent'] in [0.66 0.94 2.24]
        ..classed \active-country -> it['plat-procent'] in [0.66 0.94 2.24]
        ..attr \transform -> "translate(#{xScale it['plat-procent']}, 0)"
        ..append \text
          ..attr \class \count
          ..attr \y 30
          ..attr \font-size 17
          ..attr \letter-spacing 2
          ..attr \filter 'url(#chalk-text)'
          ..attr \text-anchor \middle
          ..text -> "#{Math.round it['plat-procent'] * 100} %"
        ..filter (-> not it.isBogus)
          ..append \rect
            ..attr \filter 'url(#chalk)'
            ..attr \x 0
            ..attr \y -> 34 + Math.round Math.random! * 2
            ..attr \width 2
            ..attr \height -> 11 + Math.round Math.random! * 2
          ..append \text
            ..attr \class \country
            ..attr \font-size 20
            ..attr \y 75
            ..attr \x -7
            ..text ->
              unless it.isBogus
                it.countries.map (.zeme) .join ", "
              else
                void
            ..attr \transform " rotate(20,0,50)"
            ..attr \filter 'url(#chalk-text)'
    voronoi = d3.geom.voronoi!
      ..x -> xScale it['plat-procent']
      ..y 0
      ..clipExtent [[-30,0],[width + 30, 200]]
    points = voronoi grouped .filter -> it
    group.append \g
      ..attr \class \voronoi
      ..selectAll \path .data points .enter!append \path
        ..attr \d polygon
        ..attr \fill \transparent
        ..on \mouseover ({point}) ~>
          ticks.classed \active-mouse -> it is point
          sgroup.classed \mouse-is-active yes
          @computeForPercentage point['plat-procent']
        ..on \mouseout ->
          sgroup.classed \mouse-is-active no

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
    extent = d3.extent @countries.map (.['zak-per-ucitel'])
    xScale = d3.scale.linear!
      ..domain extent
      ..range [width, 0]


    group = @svg.append \g
      ..attr \class \zak-per-ucitel
      ..attr \transform "translate(#margin,50)"
    @headingText = group.append \text
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
    rectWidth = (xScale 9) - (xScale 10)
    group.append \g
      ..attr \class \hoverables
      ..attr \transform "translate(#{rectWidth * (-0.5)}, 20)"
      ..selectAll \rect .data [extent.0 to extent.1] .enter!append \rect
        ..attr \x xScale
        ..attr \y 0
        ..attr \width rectWidth
        ..attr \height 400
        ..on \mouseover (ratio) ~>
          @computeForRatio ratio
          triangles.classed \disabled -> it isnt ratio
    triangles = group.append \g
      .attr \class \triangles
      .selectAll \polygon .data [extent.0 to extent.1] .enter!append \polygon
        ..classed \disabled -> it isnt 14
        ..attr \filter 'url(#chalk)'
        ..attr \fill \white
        ..attr \transform ->
          x = -10 + xScale it
          y = if grouped_assoc[it] then 18 else 41
          "translate(#x, #y)"
        ..attr \points "0,0 20,0 10,10"
    @svg.append \text
      ..text "Myší nastavíte poměr pro výpočet ceny učitelů"
      ..attr \filter 'url(#chalk-text)'
      ..attr \font-size 20
      ..attr \fill \white
      ..attr \x 970
      ..attr \y 50
      ..attr \text-anchor \end



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

polygon = ->
  "M#{it.join "L"}Z"
