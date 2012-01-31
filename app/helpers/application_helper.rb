module ApplicationHelper
  
  def common_button(color, gradient)
    %(
        background-color: ##{color};
        background-repeat: repeat-x;
        background-image: -khtml-gradient(linear, left top, left bottom, from(##{gradient}), to(##{color}));
        background-image: -moz-linear-gradient(top, ##{gradient}, ##{color});
        background-image: -ms-linear-gradient(top, ##{gradient}, ##{color});
        background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, ##{gradient}), color-stop(100%, ##{color}));
        background-image: -webkit-linear-gradient(top, ##{gradient}, ##{color});
        background-image: -o-linear-gradient(top, ##{gradient}, ##{color});
        background-image: linear-gradient(top, ##{gradient}, ##{color});
        filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='##{gradient}', endColorstr='##{color}', GradientType=0);
        text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
        border-color: ##{color} ##{color} #3d773d;
        border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
    )
  end
end
