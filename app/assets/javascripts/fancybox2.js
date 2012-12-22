$(document).ready(function(){

	// if a link with 'fancybox-nested' class is clicked, get the html and replace with current html
	function fancybox_nested_links() {
		$.get($(this).attr('href'), function(data){
			// pull out the html starting with div class="content"
			var x = $('div.content', data).html();
			// insert the new html
			$('#fancybox-content div.content').html(x);
			// register any new fancybox-nested links
			$('#fancybox-content a.fancybox-nested').click(fancybox_nested_links);
		});

		return false;
	}

	// register click function for 'fancybox-nested' class that should only be used on pages that are opened in fancybox
	$('#fancybox-content a.fancybox-nested').click(fancybox_nested_links);
	$("a.fancybox").fancybox();

});
