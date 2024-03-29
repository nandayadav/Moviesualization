# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script

# class Film
#   constructor: (@pr, @name, @tomato_score, @audience_score, @story_name, @budget, @profitability, @worldwide_gross, @r, @g, @b) ->  
#     # @x = Math.round(@pr.random(500))
#     # @y = Math.round(@pr.random(500))
#     #@x = Math.round(pr.random(800)) + 50
#     # if @story_name == 'Love'
#     #   @x = 0
#     #   @y = 0
#     # else if @story_name == 'Discovery'
#     #   @x = 800
#     #   @y = 0
#     # else
#     @x = 0.0
#     @y = 600.0
#     @radius = 5
#     
#     @tomato_score = 50 if @tomato_score == undefined
#     @final_radius = @tomato_score/4
#     @final_radius = 5.0 if @final_radius < 5.0
#     @final_radius = 14
#     #@radius = @final_radius
#     #@radius = 5.0 if @radius < 5.0
#     if @final_radius > 10
#       #fixme: translating on z-axis screws up mousePressed film find
#       @z = -500
#       #@z = 0
#     else
#       #ensure smaller ones are closer to screen, above the bigger spheres
#       @z = -500
#     @x_final = Math.round(@budget * 4)
#     profit = Math.round(@worldwide_gross - @budget)
#     @y_final = 600 - profit
#     #@y_final = 800 - Math.round(@profitability * 0.2)
#     @z_final = -5 * Math.round(@tomato_score)
#     @equilibrium = false
#     @disabled = false
#     
#     #Particle stuff
#     @location = new @pr.PVector(@x, @y, @z)
#     @velocity = new @pr.PVector(1.0, 1.0, 1.0)
#     
#   update_velocity: () ->
#     x = @velocity.x
#     y = @velocity.y
#     z = @velocity.z
#     if @location.x < @x_final
#       x = 1.0
#     else if @location.x > @x_final
#       x = -1.0
#     else
#       x = 0.0
#     
#     if @location.y < @y_final
#       y = 1.0
#     else if @location.y > @y_final
#       y = -1.0
#     else
#       y = 0.0
#       
#     if @location.z < @z_final
#       z = 1.0
#     else if @location.z > @z_final
#       z = -1.0
#     else
#       z = 0.0
#     @velocity.x = x
#     @velocity.y = y
#     @velocity.z = z
#     
#     
#   update_positions: () ->
#     if @x < @x_final
#       @x += 1
#     else if @x > @x_final
#       @x -= 1
#     
#     if @y < @y_final
#       @y += 1
#     else if @y > @y_final
#       @y -= 1
#       
#   update_radius: () ->
#     if @pr.abs(@radius - @final_radius) < 1.0
#       @radius = @final_radius
#     else if @radius < @final_radius
#       @radius += 0.1
#     else
#       @radius -= 0.1
#     
#     
#   draw: () ->
#     return if @disabled
#     @location.add(@velocity)
#     #for vibration
#     #@pr.translate(@x + @pr.random(1.0), @y + @pr.random(1.0))
#     #@pr.translate(@x, @y)
#     if @equilibrium
#       @pr.translate(@location.x, @location.y, @location.z) 
#     else
#       #vibration 
#       @pr.translate(@location.x + @pr.random(2.0), @location.y + @pr.random(2.0)) 
#     #@pr.scale(0.25)
#     @pr.noStroke()
#     @pr.fill(@r, @g, @b)
#     
#     @pr.sphere(@radius)
#     #@pr.sphere(20)
#     if @velocity.x == 0 and @velocity.y == 0
#       #sets its equilibrium reached state
#       @equilibrium = true
#     
#     
#     
# film_draw = (pr) ->  
# 
#   #Ajax call
#   pr.get_data = (year) ->
#     films = []
#     #u = '/films?year=2007'
#     $.ajax
#       url : '/films?year=' + year
#       type: 'GET',
#       success: (data) ->
#         for f in data
#           #Populate @films array
#           #console.log(f['name'])
#           film = new Film(pr, f['name'], f['tomato_score'], f['audience_score'], f['story_name'], f['budget'], f['profitability'], f['worldwide_gross'], f['r'], f['g'], f['b'])
#           films.push(film)
#       dataType: 'json'
#     return films
#       
#   pr.reset = (year) ->
#     @films = []
#     pr.noLoop() #Stop if its still looping
#     pr.redraw()
#     console.log("Year: " + year)
#     @films = pr.get_data(year)
#     @draw_count = 0
#     pr.loop()
#     
#   pr.setup = () ->
#     console.log("Inside setup")
#     @draw_count = 0
#     @films = pr.get_data(2007)
#     pr.size(1000, 800, pr.OPENGL)
#     pr.frameRate(30)
#     pr.background(212)
#     #little less taxing on cup(default is 30)
#     pr.sphereDetail(30)
#     @angle = 0
#     @displacement = 1
#     #@film = new Film("nanda", 100, 200, "whatever", 34, 2000)
#     pr.noStroke()
#     
#   # pr.mouseClicked = () ->
#   #   pr.reset()
#   pr.mouseDragged = () ->
#     @angle -= 0.05
#     pr.redraw()
#     
#   pr.mouseReleased = () ->
#     $('#film-popover').popover('hide')
#     
#   pr.mousePressed = () ->
#     matched = null
#     min_distance = null
#     console.log("/////////////////////////////////")
#     for f in @films
#       dist = pr.dist(pr.mouseX, pr.mouseY, f.x_final + 50, f.y_final)
#       if dist < f.radius
#         if (min_distance and dist < min_distance) or (!min_distance)
#           min_distance = dist
#           matched = f
#         console.log("Name: " + f.name)
#         console.log("Disance: " + dist)
#         # content = "<h3>" + f.name + "</h3>" + "<br/>Rotten Tomatoes: " + f.tomato_score + "<br/>Story: " + f.story_name + "<br/>Audience Score: " + f.audience_score + "<br/>Budget($m): " + f.budget + "<br/>Profitability: " + f.profitability + "%"
#         # $('#film-popover').attr('data-title', f.name)
#         # $('#film-popover').attr('data-content', content)
#         # $('#film-popover').popover('show')
#         #break
#     if matched and min_distance
#       content = "<h3>" + matched.name + "</h3>" + "<br/>Rotten Tomatoes: " + matched.tomato_score + "<br/>Story: " + matched.story_name + "<br/>Audience Score: " + matched.audience_score + "<br/>Budget($m): " + matched.budget + "<br/>Profitability: " + matched.profitability + "%"
#       $('#film-popover').attr('data-title', matched.name)
#       $('#film-popover').attr('data-content', content)
#       $('#film-popover').popover('show')
#     
#     
#   # 
#   # #Aggregate films into their story_name/plots  
#   # pr.mouseClicked = () ->
#   #   pr.redraw()
#   #   console.log("(" + pr.mouseX + "," + pr.mouseY + ")")
#   #     for f in @films
#   #       if (pr.dist(pr.mouseX, pr.mouseY, f.x_final + 50, f.y_final) < f.tomato_score/4)
#   #         console.log("Name: " + f.name)
#   #         console.log("Worldwide: " + f.worldwide_gross)
#   #         console.log("Profitability: " + f.profitability)
#   #         console.log("X_final: " + f.x_final)
#   #         console.log("Y_final: " + f.y_final)
#   #         console.log("mouseY: " + pr.mouseY)
#   #         break
#       
#     
#     
#     
#   pr.draw = () ->
#     @draw_count += 1
#     #pr.pushMatrix()
#     pr.lights()
#     #pr.beginCamera()
#     #pr.camera(500, 200, 0, 50, pr.width/2, 5.0, 0.0, 1.0, 0.0)
#     pr.camera()
#     pr.translate(50, 0, 0)
#     #pr.directionalLight(200, 10, 0, 0, 1, 0)
#     #pr.directionalLight(200, 10, 0, 1, 0, 0)
#     pr.rotateY(@angle)
#     # pr.rotateX(@angle)
#     #pr.endCamera()
#     
#     #pr.pointLight(51, 102, 126, 35, 40, 36)
#     pr.background(212)
#     #pr.directionalLight(211, 13, 36, 800, 800, 2);
#     for film in @films 
#       pr.pushMatrix()     
#       film.draw() 
#       film.update_velocity()
#       #film.update_positions()
#       film.update_radius()
#       pr.popMatrix()
#     
#     #pr.fill(0, 102, 153)
#     pr.strokeWeight(2)
#     pr.stroke(0)
#     pr.textSize(22)
#     pr.textAlign(pr.CENTER, pr.CENTER)
#     #fixme: how to vertically align this?
#     pr.text("Profit ($m)", 30, 200)
#     pr.line(0, 600, -500, 900, 600, -500)
#     #pr.fill(0, 0, 0)
#     pr.text("Budget ($m)", 600, 600)
#     pr.line(0, 0, -500, 0, 800, -500) #profitability y-axis
#     pr.line(0, 600, 0, 0, 600, -500)
#     pr.pushMatrix()
#     pr.translate(0, 0, -500)
#     pr.fill(188, 236, 244)
#     pr.rect(0, 0, 900, 600)
#     pr.popMatrix()
#     #Instead of checking if film is in its equlibrium place after every render, this is more efficient as (pr.width + pr.height)/2 frames should be more than enough for film to reach its place
#     if @draw_count > 600
#       console.log("stopped")
#       pr.noLoop() 
# 
# 
#   
# 
# # wait for the DOM to be ready, 
# # create a pr instance...
# $(document).ready ->
#   canvas = document.getElementById "processing"
#   pr = new Processing(canvas, film_draw)
#   
#   $('.btn-primary').click ->
#     # alert($(this).text())
#     if pr
#       console.log("asdfasdfasdf")
#       pr.reset($(this).text())
#     
#   $('#film-popover').popover({ placement: 'right'})
#   $('button').click ->
#     story = $(this).text()
#     for film in pr.films
#       if film.story_name == story
#         film.disabled = false
#       else
#         film.disabled = true
#     pr.redraw()
