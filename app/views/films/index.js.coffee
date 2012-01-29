
coffee_draw = (pr) ->  

  # pr's "init" method:

  pr.setup = () ->
    pr.size(500, 500)
    pr.background(212)

  # where the fun stuff happens:
  pr.draw = () ->
    
    # noise() needs an "offset" argument
    # we'll tie it to the frame count
    x_off = pr.frameCount * 0.0005
    
    # we want y's offset to increase at the same rate
    # but be different (20 is arbitrary)
    y_off = x_off + 20
    
    # use noise(), the offset, and our sketch's dimensions
    # to get a "random" position for our "brush"
    
    x = pr.noise(x_off) * pr.width
    y = pr.noise(y_off) * pr.height
    
    # color our brush (red with 15% opacity)
    pr.stroke(255, 0, 0, 15)
    
    # draw at brush's current location (set above)
    pr.point(x, y)
 
class Film
  constructor: (@name, @tomato_score, @audience_score) -> 
    
class Bean
  constructor: (pr, opts) ->  

  # wait for the DOM to be ready, 
  # create a pr instance...
  $(document).ready ->
    canvas = document.getElementById "processing"

    pr = new Processing(canvas, coffee_draw)
    $.ajax '/films'
      type: 'GET',
      success: (data) ->
        for f in JSON.parse(data)
          film = new Film(f['name'], f['tomato_score'], f['audience_score'])
          alert(film.name)
      dataType: 'json'