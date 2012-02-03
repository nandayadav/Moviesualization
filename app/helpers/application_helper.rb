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
  
  def common_btn(color, gradient)
    %(
        background-color: ##{color};
        background-repeat: repeat-x;
        background-image: -khtml-gradient(linear, left top, left bottom, from(##{color}), to(##{color}));
        background-image: -moz-linear-gradient(top, ##{color}, ##{color});
        background-image: -ms-linear-gradient(top, ##{color}, ##{color});
        background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, ##{color}), color-stop(100%, ##{color}));
        background-image: -webkit-linear-gradient(top, ##{color}, ##{color});
        background-image: -o-linear-gradient(top, ##{color}, ##{color});
        background-image: linear-gradient(top, ##{color}, ##{color});
        filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='##{color}', endColorstr='##{color}', GradientType=0);
        text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
        border-color: ##{color} ##{color} #3d773d;
        border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
    )
  end
  
  def google_analytics
    %(
      <script type="text/javascript">

        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-28892550-1']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();

      </script>
    )
  end
end
