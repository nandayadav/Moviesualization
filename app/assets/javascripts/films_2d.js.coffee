# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script
  
class Film
  constructor: (@pr, @name, @tomato_score, @audience_score, @story, @budget, @profitability, @worldwide_gross) ->  
    # @x = Math.round(@pr.random(500))
    # @y = Math.round(@pr.random(500))
    #@x = pr.random(800) + 50
    @x = 0
    @y = 0
    @z = pr.random(-100)
    @x_final = (@budget * 4)
    profit = Math.round(@worldwide_gross - @budget)
    @y_final = 400 - profit
    #@y_final = 800 - Math.round(@profitability * 0.2)
    @equilibrium = false
    
  update_positions: () ->
    if @x < @x_final
      @x += 1
    else if @x > @x_final
      @x -= 1
    
    if @y < @y_final
      @y += 1
    else if @y > @y_final
      @y -= 1
    
    
  disperse: () ->
    loop
      draw()
      break if @x == (@budget + 100) and @y == (@profitability * 0.1) + 100
    
  draw: () ->
    @pr.translate(@x, @y)
    #@pr.scale(0.25)
    @pr.noStroke()
    #@pr.fill(123, 5, 6)
    @pr.sphere(@tomato_score/4)
    if (@x == @x_final) and (@y == @y_final)
      #sets its equilibrium reached state
      @equilibrium = true
    
    
    
coffee_draw = (pr) ->  

  #Ajax call
  pr.get_data = () ->
    films = []
    $.ajax '/films'
      type: 'GET',
      success: (data) ->
        for f in data
          #Populate @films array
          #console.log(f['name'])
          film = new Film(pr, f['name'], f['tomato_score'], f['audience_score'], f['story'], f['budget'], f['profitability'], f['worldwide_gross'])
          films.push(film)
      dataType: 'json'
    return films
      
  pr.setup = () ->
    console.log("Inside setup")
    @draw_count = 0
    @films = pr.get_data()
    # @films.push(new Film(pr, 'Titanic', 55, 15, 'Love', 0, 1387.57))
    #     @films.push(new Film(pr, 'Mr Suess', 45, 87, 'Discovery', 14, 3387.57))
    #     @films.push(new Film(pr, 'Gladiator', 35, 87, 'Discovery', 34, 387.57))
    #     @films.push(new Film(pr, 'vampire diaries', 95, 87, 'Discovery', 21, 6387.57))
    #     @films.push(new Film(pr, 'Motionless', 87, 34, 'Love', 13, 2387.57))
    #setup and initialize films via ajax call
    pr.size(900, 800, pr.OPENGL)
    pr.frameRate(60)
    pr.background(212)
    # pr.strokeWeight(2);
    # pr.line(0, 400, 0, 800, 400, 0)
    # pr.line(0, 0, 0, 0, 800, 0) #profitability y-axis
    #pr.noLoop()

    @angle = 0
    @displacement = 1
    #@film = new Film("nanda", 100, 200, "whatever", 34, 2000)
    pr.noStroke()
    

  pr.mouseDragged = () ->
    @angle -= 0.05
    pr.redraw()
  # 
  # #Aggregate films into their story/plots  
  pr.mouseClicked = () ->
    console.log("(" + pr.mouseX + "," + pr.mouseY + ")")
    for f in @films
      if (pr.dist(pr.mouseX, pr.mouseY, f.x_final + 50, f.y_final) < f.tomato_score/4)
        console.log("Name: " + f.name)
        console.log("Worldwide: " + f.worldwide_gross)
        console.log("Profitability: " + f.profitability)
        console.log("X_final: " + f.x_final)
        console.log("Y_final: " + f.y_final)
        console.log("mouseY: " + pr.mouseY)
        $('#film_details').modal('show')
        break
      
    
    
    
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
      film.update_positions()
      pr.popMatrix()
    
    #pr.fill(0, 102, 153)
    pr.strokeWeight(2)
    pr.stroke(0)
    pr.textSize(22)
    pr.textAlign(pr.CENTER, pr.CENTER)
    #fixme: how to vertically align this?
    pr.text("Profit ($m)", 30, 200)
    pr.line(0, height/2, 0, width, height/2, 0)
    #pr.fill(0, 0, 0)
    pr.text("Budget ($m)", width/2, height/2)
    pr.line(0, 0, 0, 0, height, 0) #profitability y-axis
    #Instead of checking if film is in its equlibrium place after every render, this is more efficient as (pr.width + pr.height)/2 frames should be more than enough for film to reach its place
    if @draw_count > (pr.width + pr.height)/2
      console.log("stopped")
      pr.noLoop() 


  

# wait for the DOM to be ready, 
# create a pr instance...
$(document).ready ->
  canvas = document.getElementById "processing"
  pr = new Processing(canvas, coffee_draw)

    
      



