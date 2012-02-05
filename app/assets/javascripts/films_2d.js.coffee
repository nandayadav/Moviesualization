# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script
    
class Film
  constructor: (@pr, @name, @tomato_score, @audience_score, @story_name, @budget, @profitability, @worldwide_gross, @r, @g, @b) ->  
    # @x = Math.round(@pr.random(500))
    # @y = Math.round(@pr.random(500))
    #@x = Math.round(pr.random(800)) + 50
    @x = 400
    @y = 200
    @radius = 5
    
    @tomato_score = 50 if @tomato_score == undefined
    @final_radius = @tomato_score/4
    @final_radius = 5 if @final_radius < 5
    #@radius = @final_radius
    #@radius = 5.0 if @radius < 5.0
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
    if @equilibrium
      @pr.translate(@location.x, @location.y, @location.z) 
    else
      #vibration 
      @pr.translate(@location.x + @pr.random(2.0), @location.y + @pr.random(2.0)) 
    #@pr.scale(0.25)
    @pr.noStroke()
    @pr.fill(@r, @g, @b)
    
    @pr.sphere(@radius)
    #@pr.sphere(20)
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
          story = new Film(pr, f['name'], f['tomato_score'], 0, f['name'], f['budget'], f['profit'], 0, f['red'], f['green'], f['blue'])
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
    
  pr.drawStories = () ->
    @films = []
    pr.noLoop() #Stop if its still looping
    pr.redraw()
    @films = pr.getStoryData()
    for f in @films
      console.log("Name: " + f.name)
    @draw_count = 0
    pr.loop()
      
  pr.reset = (year) ->
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
    
    pr.strokeWeight(1)
    #Average lines
    avg_budget = @averages[@year]['budget'] * 4
    avg_profit = @averages[@year]['profit']
    pr.line(avg_budget, 700, avg_budget, 0)
    pr.line(0, 700 - avg_profit, pr.width, 700 - avg_profit)
    
    
  pr.setup = () ->
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
    #pr.pushMatrix()
    pr.lights()
    #pr.beginCamera()
    #pr.camera(pr.width/2, pr.height/2, pr.height/2, 10, pr.width/2, 0.0, 0.0, 1.0, 0.0)
    pr.camera()
    pr.translate(50, 0, 0)
    pr.rotateY(@angle)
    # pr.rotateX(@angle)
    #pr.endCamera()
    
    #pr.pointLight(51, 102, 126, 35, 40, 36)
    pr.background(212)
    #pr.directionalLight(211, 13, 36, 800, 800, 2);
    for film in @films 
      pr.pushMatrix()     
      film.draw() 
      film.updateVelocity()
      #film.updatePositions()
      film.updateRadius()
      pr.popMatrix()
    
    #pr.fill(0, 102, 153)
    
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
      pr.reset($(this).text())
    
  $('#film-popover').popover({ placement: 'right'})
  $('.nav-buttons').click ->
    story = $(this).text()
    for film in pr.films
      if film.story_name == story
        film.disabled = false
      else
        film.disabled = true
    pr.redraw()
    
  $('#story-btn').click ->
    alert('wt')
    pr.drawStories()

    
      



