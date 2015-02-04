class ig.Chalkboard
  (@parentElement, @countries) ->
    @element = @parentElement.append \div
      ..attr \class \content
    @svg = @element.append \svg
      ..attr \width 1000
      ..attr \height 600
    @initFilter!
    @drawZakPerUcitelLine!

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
    width = 700
    cz = @countries[5]
      ..countries = [@countries[5]]
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
        ..text "Počet žáků na jednoho učitele: 10,5"
        ..attr \font-size 30
        ..attr \fill \white
        ..attr \x 0
        ..attr \y 0
    group.append \g
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
          ..attr \transform " rotate(30,0,60)"
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
