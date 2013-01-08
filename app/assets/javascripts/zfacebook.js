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
				// get idea id
				var url_ary = response.href.split("/");
				// check for query string values
				var idea_id = url_ary[url_ary.length-1].split("?")[0];
				$.get(gon.comment_notification_url.replace(gon.placeholder, idea_id));
			});
		}
  };

	// set the width of the facebook comments box
	if (gon.show_fb_comments){
		$('div.fb-comments').attr('data-width',$('div.page-header').width());
	}
});
