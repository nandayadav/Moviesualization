# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script
    
class Film
  constructor: (@pr, @name, @tomato_score, @audience_score, @story_name, @budget, @profitability, @worldwide_gross, @r, @g, @b) ->  
    @x = 400
    @y = 400
    @radius = 5
    
    @tomato_score = 50 if @tomato_score == undefined
    @final_radius = @tomato_score/4
    @final_radius = 5 if @final_radius < 5
    @z = 0
    @x_final = Math.round(@budget * 4)
    @x_final = (@pr.width - 50) if @x_final > (@pr.width - 50)
    @profit = Math.round(@worldwide_gross - @budget)
    @y_final = 700 - @profit
    @y_final = 0 if @y_final < 0 #ensure its in bounds
    #@y_final = 800 - Math.round(@profitability * 0.2)
    @equilibrium = false
    @disabled = false
    
    #Particle stuff
    @location = new @pr.PVector(@x, @y, @z)
    @velocity = new @pr.PVector(1.0, 1.0, 0.0)
    
  updateVelocity: () ->
    x = @velocity.x
    y = @velocity.y
    if @location.x < @x_final
      x = 1.0
    else if @location.x > @x_final
      x = -1.0
    else
      x = 0.0
    
    if @location.y < @y_final
      y = 1.0
    else if @location.y > @y_final
      y = -1.0
    else
      y = 0.0
    @velocity.x = x
    @velocity.y = y
    
    
  updatePositions: () ->
    if @x < @x_final
      @x += 1
    else if @x > @x_final
      @x -= 1
    
    if @y < @y_final
      @y += 1
    else if @y > @y_final
      @y -= 1
      
  updateRadius: () ->
    if @pr.abs(@radius - @final_radius) < 1.0
      @radius = @final_radius
    else if @radius < @final_radius
      @radius += 0.1
    else
      @radius -= 0.1
    
    
  draw: () ->
    return if @disabled
    @location.add(@velocity)
    @pr.fill(@r, @g, @b)
    if @equilibrium
      @pr.translate(@location.x, @location.y, @location.z) 
    else
      #vibration 
      @pr.translate(@location.x + @pr.random(2.0), @location.y + @pr.random(2.0)) 
    @pr.noStroke()
    @pr.sphere(@radius)
    if @velocity.x == 0 and @velocity.y == 0
      #sets its equilibrium reached state
      @equilibrium = true
    
    
    
film_draw = (pr) ->  

  pr.getStoryData = () ->
    stories = []
    $.ajax
      url : '/stories'
      type: 'GET',
      success: (data) ->
        for f in data
          console.log("..." + f['name'])
          story = new Film(pr, f['name'], f['average_tomato_score'], 0, f['name'], f['average_budget'], 'N/A', f['average_worldwide_gross'], f['red'], f['green'], f['blue'])
          stories.push(story)
      dataType: 'json'
    return stories
    
  #Ajax call
  pr.getData = (year) ->
    films = []
    $.ajax
      url : '/films?year=' + year
      type: 'GET',
      success: (data) ->
        for f in data
          film = new Film(pr, f['name'], f['tomato_score'], f['audience_score'], f['story_name'], f['budget'], f['profitability'], f['worldwide_gross'], f['r'], f['g'], f['b'])
          films.push(film)
      dataType: 'json'
    return films
    
  pr.resetScores = () ->
    @min_score = 0
    @max_score = 0

  pr.applyScoresAndDraw = (min, max) ->
    pr.noLoop()
    @min_score = min
    @max_score = max
    for f in @films
      if f.tomato_score > @min_score and f.tomato_score < @max_score
        f.disabled = false #if f.disabled #dont reset if already was false
      else if f.tomato_score < @min_score or f.tomato_score > @max_score
        f.disabled = true #unless f.disabled #dont reset if already was true
    pr.loop()
    
  pr.drawStories = () ->
    @films = []
    @story_display = true
    pr.noLoop() #Stop if its still looping
    @draw_count = 0
    pr.redraw()
    console.log("Getting data..")
    @films = pr.getStoryData()
    for f in @films
      console.log("Name: " + f.name)
    pr.loop()
      
  pr.reset = (year) ->
    @story_display = false
    @films = []
    pr.noLoop() #Stop if its still looping
    pr.redraw()
    console.log("Year: " + year)
    @films = pr.getData(year)
    @year = year
    @draw_count = 0
    pr.loop()
    
  pr.getAverages = () ->
    avg = {
      2007: {
        budget: 63
        profit: 125
      },
      2008: {
        budget: 50
        profit: 74
      },
      2009: {
        budget: 54
        profit: 112
      },
      2010: {
        budget: 55
        profit: 97
      },
      2011: {
        budget: 53
        profit: 98
      }
    }
    
  pr.drawAxes = () ->
    pr.fill(0, 0, 0)
    pr.strokeWeight(2)
    pr.stroke(0)
    pr.textSize(22)
    pr.textAlign(pr.CENTER, pr.CENTER)
    #fixme: how to vertically align this?
    pr.pushMatrix()
    pr.translate(-30, 400, 0)
    pr.rotate(pr.radians(270))
    pr.text("Profit ($m)", 0, 0)
    pr.popMatrix()
    pr.line(0, 0, 0, 0, 800, 0) #profitability y-axis
    #Budget: x-axis
    pr.line(0, 700, 0, 900, 700, 0)
    pr.text("Budget ($m)", 500, 710)
    
    #Indicators
    pr.textSize(16)
    for x in [200, 400, 600, 800]
      pr.line(x, 680, x, 720)
      pr.text(x/4, x, 730)
    
    for y in [100, 300, 500]
      pr.line(-20, y, 20, y)
      pr.pushMatrix()  
      pr.translate(-40, y, 0)
      pr.rotate(pr.radians(270))
      pr.text((700-y), 0, 0)
      pr.popMatrix()
    
    unless @story_display
      pr.strokeWeight(1)
      #Average lines
      avg_budget = @averages[@year]['budget'] * 4
      avg_profit = @averages[@year]['profit']
      pr.line(avg_budget, 700, avg_budget, 0)
      pr.line(0, 700 - avg_profit, pr.width, 700 - avg_profit)
    
    
  pr.setup = () ->
    @story_display = false
    @min_score = 0
    @max_score = 100
    @story_scale = 1.5
    @draw_count = 0
    @averages = pr.getAverages()
    @year = 2007
    @films = pr.getData(@year)
    pr.size(900, 800, pr.OPENGL)
    pr.frameRate(30)
    pr.background(212)
    #little less taxing on cup(default is 30)
    pr.sphereDetail(30)
    @angle = 0
    @displacement = 1
    #@film = new Film("nanda", 100, 200, "whatever", 34, 2000)
    pr.noStroke()
    
  # pr.mouseDragged = () ->
  #   @angle -= 0.05
  #   pr.redraw()
    
  pr.mouseReleased = () ->
    $('#film-popover').attr('data-content', '')
    $('#film-popover').popover('hide')
    
  pr.mousePressed = () ->
    matched = null
    min_distance = null
    for f in @films
      dist = pr.dist(pr.mouseX, pr.mouseY, f.x_final + 50, f.y_final)
      if dist < f.radius
        console.log("found: " + f.name)
        if (min_distance and dist < min_distance) or (!min_distance)
          min_distance = dist
          matched = f
    if matched and min_distance
      if !matched.audience_score 
        matched.audience_score = 'N/A'
      content = "<h3>" + matched.name + "</h3>" + "<br/>Rotten Tomatoes: " + matched.tomato_score + "<br/>Story: " + matched.story_name + "<br/>Audience Score: " + matched.audience_score + "<br/>Profit($m): " + matched.profit + "<br/>Budget($m): " + matched.budget + "<br/>Profitability: " + matched.profitability + "%"
      $('#film-popover').attr('data-title', matched.name)
      $('#film-popover').attr('data-content', content)
      $('#film-popover').popover('show')

  pr.draw = () ->
    @draw_count += 1
    pr.lights()
    pr.camera()
    pr.translate(50, 0, 0)
    pr.background(212)
    #pr.directionalLight(211, 13, 36, 800, 800, 2);
    for film in @films 
      pr.pushMatrix()    
      film.draw() 
      film.updateVelocity()
      #film.updatePositions()
      film.updateRadius()
      pr.popMatrix()
    
    pr.drawAxes()
    #Instead of checking if film is in its equlibrium place after every render, this is more efficient as (pr.width + pr.height)/2 frames should be more than enough for film to reach its place
    if @draw_count > 600
      console.log("stopped")
      pr.noLoop() 


  

# wait for the DOM to be ready, 
# create a pr instance...
$(document).ready ->
  canvas = document.getElementById "processing"
  pr = new Processing(canvas, film_draw)
  
  $('.year-buttons').click ->
    # alert($(this).text())
    if pr
      $('.nav-buttons').removeClass('active')
      pr.resetScores()
      resetSlider()
      pr.reset($(this).text())
    
  $('#film-popover').popover({ placement: 'left'})
  $('#stories-popover').tooltip( { placement: 'bottom'})
  $('.nav-buttons').click ->
    $(this).button('toggle')
    #find all activated buttons
    active_stories = []
    #there must be 1 liner for this??
    for active in $('.nav-buttons.active')
      active_stories.push(active.innerHTML)
    for film in pr.films
      if film.story_name in active_stories
        film.disabled = false unless film.tomato_score < pr.min_score or film.tomato_score > pr.max_score
      else
        film.disabled = true
    pr.loop()
  
  $('#toggle').click ->
    $('.nav-buttons').toggleClass('active')
    #find all activated buttons
    active_stories = []
    #there must be 1 liner for this??
    for active in $('.nav-buttons.active')
      active_stories.push(active.innerHTML)
    for film in pr.films
      if film.story_name in active_stories
        film.disabled = false unless film.tomato_score < pr.min_score or film.tomato_score > pr.max_score
      else
        film.disabled = true 
    pr.redraw()
      
    
  resetSlider = () ->
    $('#slider').slider('values', 0, $('#slider').slider('option','min'))
    $('#slider').slider('values', 1, $('#slider').slider('option','max'))
    $("#score_min").text(0)
    $("#score_max").text(100)
  
  $('#story-btn').click ->
    $('.nav-buttons').removeClass('active')
    pr.resetScores()
    resetSlider()
    pr.drawStories()
  
  $("#slider").slider({
    step: 5,
    range: true,
    values: [0, 100],
    max: 100,
    min: 0,
    slide: (event, ui) ->
      $("#score_min").text(ui.values[0])
      $("#score_max").text(ui.values[1])
    change: (event, ui) ->
      if pr
        $('.nav-buttons').removeClass('active')
        pr.applyScoresAndDraw(ui.values[0], ui.values[1])
      else
        alert("Drawing not initialized yet")

  })

    
      



