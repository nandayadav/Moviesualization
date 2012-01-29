# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
# # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script
#   
# class Film
#   constructor: (@name, @tomato_score, @audience_score, @story, @budget, @profitability) ->  
#     
# coffee_draw = (pr) ->  
#   # pr's "init" method:
#   
#   pr.setup = () ->
#     #setup and initialize films via ajax call
#     #pr.import processing.opengl.*
#     pr.size(800, 800, pr.OPENGL)
#     pr.background(212)
#     pr.strokeWeight(2);
#     pr.line(400, 400, 0, 0, 800, 0)
#     pr.noLoop()
#     @angle = 0
#     @displacement = 1
#     @film = new Film("nanda", 100, 200, "whatever", 34, 2000)
#     #pr.noStroke()
#     
# 
#   pr.mouseDragged = () ->
#     @angle -= 1
#     pr.redraw()
#   
#   #Aggregate films into their story/plots  
#   pr.aggregate = () ->
#     @displacement += 1 
#     
#     
#   pr.draw = () ->
#     #film.display(pr)
#     #pr.text(@film.name)
#     if @film.story == 'Love'
#       pr.directionalLight(211, 13, 36, 800, 800, 2);
#       pr.directionalLight(211, 13, 36, 800, 0, 2);
#       pr.directionalLight(211, 13, 36, 0, 0, 2);
#       pr.directionalLight(211, 13, 36, 0, 800, 2);
#     else if @film.story == 'Discovery'
#       pr.directionalLight(10, 213, 6, 800, 800, 2);
#       pr.directionalLight(10, 213, 6, 800, 0, 2);
#       pr.directionalLight(10, 213, 6, 0, 0, 2);
#       pr.directionalLight(10, 213, 6, 0, 800, 2);
#     else
#       pr.directionalLight(101, 13, 201, 800, 800, 2);
#       pr.directionalLight(101, 13, 201, 800, 0, 2);
#       pr.directionalLight(101, 13, 201, 0, 0, 2);
#       pr.directionalLight(101, 13, 201, 0, 800, 2);
#     
#     
#     # pr.ambientLight(102, 102, 102);
#     console.log(@film.name)
#     #pr.ellipse(pr.random(800), pr.random(800), @film.tomato_score, @film.tomato_score)
#     pr.pushMatrix();
#     pr.rotateX(pr.radians(@angle))
#     #pr.translate(pr.random(600) + 100, pr.random(600) + 100, pr.random(5))
#     pr.stroke(0)
#     pr.line(50, 50, 0, 800, 50, 0) #budget x-axis
#     pr.line(50, 50, 0, 50, 800, 0) #profitability y-axis
#     pr.translate(@film.budget + 100, Math.round(@film.profitability * 0.5) + 100)
#     pr.scale(0.40)
#     pr.specular(51, 51, 51)
#     console.log(@angle)
#     
#     pr.noStroke()
#     pr.sphere(@film.tomato_score)
#     pr.popMatrix()
# 
#   pr.redraw_frame = (film) ->
#     @film = film
#     pr.redraw()
# 
#   
# 
# # wait for the DOM to be ready, 
# # create a pr instance...
# $(document).ready ->
#       
#       
#   canvas = document.getElementById "processing"
# 
#   pr = new Processing(canvas, coffee_draw)
#   $.ajax '/films'
#     type: 'GET',
#     success: (data) ->
#       for f in data
#         film = new Film(f['name'], f['tomato_score'], f['audience_score'], f['story'], f['budget'], f['profitability'])
#         pr.redraw_frame(film)
#     dataType: 'json'
# 
