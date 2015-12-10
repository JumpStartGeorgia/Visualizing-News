$(document).ready(function(){
  $('#category_slider_content li a').each(function(){
    $(this).css('background', "url('" + $(this).attr('data-path') + "')");
    $(this).css('background-position', 'top');
    $(this).css('background-repeat', 'no-repeat');
    $(this).hover(function(){
      $(this).css('background-position', '50% -31px');
    }, function(){
      $(this).css('background-position', 'top');
    });
  });

  // build category slider
  $('#category_slider_content').elastislide({start: ((typeof slider_start_index == 'undefined') ? 0 : slider_start_index)});
});

$(function() {
  $('#toggle_categories').click(function () {

    // rotate the arrow
    deg = '0';
    ie = '0';

    if ($('#category_slider').css('display') == 'none'){
      deg = '180';
      ie = '2';
    }

    $('#category_slider').slideToggle(400);

    $('#category_arrow').fadeOut(200, function(){
      $('#category_arrow').css('-webkit-transform', 'rotate(' + deg + 'deg)');
      $('#category_arrow').css('-moz-transform', 'rotate(' + deg + 'deg)');
      $('#category_arrow').css('-ms-transform', 'rotate(' + deg + 'deg)');
      $('#category_arrow').css('-o-transform', 'rotate(' + deg + 'deg)');
      $('#category_arrow').css('filter', 'progid:DXImageTransform.Microsoft.BasicImage(rotation=' + ie + ')');
      $('#category_arrow').fadeIn(200);
    })
  });
});
