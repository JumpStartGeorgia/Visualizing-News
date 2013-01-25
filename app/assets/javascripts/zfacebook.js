$(document).ready(function(){
	// facebook comments
	(function(d, s, id) {
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=" + gon.fb_app_id;
		fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));

	window.fbAsyncInit = function() {
		// when a comment is submitted, notify the user of the idea
		if (gon.show_fb_comments){
			FB.Event.subscribe('comment.create', function(response){
				// get id of record
				var url_ary = response.href.split("/");
				var id = url_ary[url_ary.length-1].split("?")[0];
        // sound out notifications
				$.get(gon.visual_comment_notification_url.replace(gon.placeholder, id));
        // increment comment count on page
        $('span.comment_count_number').each(function(index, element){
          var num = this;
          $(this).parent().fadeOut('slow', function(){
            var old_count = parseInt($(element).html());            
            $(element).html(old_count+1);
            $(this).css('color', '#fff');
            $(this).css('background-color', '#469e72');
            $(this).fadeIn('slow', function(){
              $(this).animate({color: '#757575', backgroundColor: 'transparent'}, 1000);
            });
          });
        });
			});
		}
  };

	// set the width of the facebook comments box
	if (gon.show_fb_comments){
		$('div.fb-comments').attr('data-width',$('div.page-header').width());
	}
});
