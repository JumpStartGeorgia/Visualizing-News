function updateQueryStringParameter(uri, key, value) {
  var re = new RegExp("([?|&])" + key + "=.*?(&|$)", "i");
  separator = uri.indexOf('?') !== -1 ? "&" : "?";
  if (uri.match(re)) {
    return uri.replace(re, '$1' + key + "=" + value + '$2');
  }
  else {
    return uri + separator + key + "=" + value;
  }
}

function indicate_like_success(update_counter){
  var counter_action = 1;
  $('body').animate({scrollTop: 0}, 300, function(){
    // switch button status
    var like_text, href_status_old, href_status_new;
    if ($('.like_btn').first().attr('title') == $('.like_btn').first().attr('data-like')){
      // was like, change to unlike
      like_text = $('.like_btn').first().attr('data-unlike');
      href_status_old = '/up';
      href_status_new = '/down';
    } else{
      // was unlike, change to like
      counter_action = -1;
      like_text = $('.like_btn').first().attr('data-like');
      href_status_old = '/down';
      href_status_new = '/up';
    }

    $('.like_btn .text').fadeOut('slow', function(){
      $('.like_btn').attr('title', like_text);
      $('.like_btn').attr('href', $('.like_btn').attr('href').replace(href_status_old, href_status_new));
      $('.like_btn .text').each(function(){
        $(this).html(like_text);
      });
      $('.like_btn .text').fadeIn('slow');
    });
    if (update_counter){
      // update the like counter
      $('span#like_count_text').fadeOut('slow', function(){
        var old_count = parseInt($('span#like_count_number').html());
        var new_count = old_count + counter_action;
        if (new_count < 0){
          new_count = 0;
        }
        $('span#like_count_number').html(new_count);
        $(this).css('color', '#fff');
        $(this).css('background-color', '#469e72');
        $(this).fadeIn('slow', function(){
          $('span#like_count_text').animate({color: '#757575', backgroundColor: 'transparent'}, 1000);
        })
      });
    }
  });
}

$(document).ready(function(){
  (function ($)
  {

    // process like button click
    $('a.like_btn').click(function(){
      if (!$(this).data('signed') || $(this).data('signed') == 'false')
      {
        if (typeof $.cookie == 'function')
        {
        //$.cookie.json = true;
          //{type: gon.current_content.type, id: gon.current_content.id}
          $.cookie('queued_like', 1, {expires: 1, path: '/'});
        }
        $('#frozen-menu .user-menu .fancybox').click();
        return false;
      }

      var update_counter = true;
      if ($(this).attr('data-interactive') == 'true'){
        update_counter = false;
      }
      $.ajax({
        type: "GET",
        url: $(this).attr('href') + '.js',
        dataType:"json",
        timeout: 3000,
        error: function(response) {
          indicate_like_success(update_counter);
        },
        success: function(response) {
          if(response.status === "success") {
            indicate_like_success(update_counter);
          } else{
            indicate_like_success(update_counter);
          }
        }
      });
      return false;
    });

    // if there is a like action queued, do it
    if (typeof $.cookie == 'function' && +$.cookie('queued_like') == 1)
    {
      //$.cookie('queued_like', 1, {expires: -100, path: '/'});
      $.get('/unset_cookie');
      $('a.like_btn:eq(0)').click();
    }

  })(jQuery);
});
