$(function ()
{

  $('#toggle_categories').click(function ()
  {
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
