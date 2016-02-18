function set_data_src_to_src(tag) {
	$(tag).data('srcOriginal', tag.src);
}

function set_src_to_data_src(tag) {
	tag.src = $(tag).data().srcOriginal;
}

function hide_cover_image(gif_image) {
	$(gif_image)
		.siblings('.js-hide-on-play-gif')
		.addClass('is-hidden');
}

function show_cover_image(gif_image) {
	$(gif_image)
		.siblings('.js-show-on-freeze-gif')
		.removeClass('is-hidden');
}

function is_gif_image(image) {
	return $(image).hasClass('js-is-gifographic');
}

function freeze_gif(i) {
	$(i).addClass('is-frozen');
	show_cover_image(i);

	var c = document.createElement('canvas');
	var w = c.width = i.width;
	var h = c.height = i.height;
	c.getContext('2d').drawImage(i, 0, 0, w, h);
	try {
		i.src = c.toDataURL("image/gif"); // if possible, retain all css aspects
	} catch(e) { // cross-domain -- mimic original with all its tag attributes
		for (var j = 0, a; a = i.attributes[j]; j++)
			c.setAttribute(a.name, a.value);
		i.parentNode.replaceChild(c, i);
	}
}

function freeze_gif_first_time(image) {
	set_data_src_to_src(image);
  freeze_gif(image);
}

function play_gif(image) {
	$(image).removeClass('is-frozen');
	hide_cover_image(image);
	set_src_to_data_src(image);
}

function bind_freeze_to_loading_gifs($container) {
	$container
		.imagesLoaded()
		.progress( function() {
			var image = this[0];
			if (is_gif_image(image)) {
				freeze_gif_first_time(image);
			}
		});
}

function freeze_loaded_gifs($container) {
	$container
		.find('img')
		.each(function(index, image) {
			if (image.complete && is_gif_image(image)) {
				freeze_gif_first_time(image);
			}
		});
}

function setup_gifographics_on_vis_page() {
	var $visuals_container = $('.js-setup-visuals');

	bind_freeze_to_loading_gifs($visuals_container);
	freeze_loaded_gifs($visuals_container);
}

function bind_freeze_play_on_click_to_gif(image) {
	$(image).click(function() {
		if ($(this).hasClass('is-frozen')) {
			play_gif(this);
		} else {
			freeze_gif(this);
		}
	});
}

function setup_gifographic_on_show_page($image) {
	console.log('Setting up gifographic on show page!');

	$image.one('load', function() {
		freeze_gif_first_time(this);
		bind_freeze_play_on_click_to_gif(this);
	}).each(function() {
	  if(this.complete) $(this).load();
	});
}
