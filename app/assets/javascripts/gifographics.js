function set_data_src_to_src(tag) {
	$(tag).data('srcOriginal', tag.src);
}

function set_src_to_data_src(tag) {
	tag.src = $(tag).data().srcOriginal;
}

function is_gif_image(image) {
	return $(image).hasClass('js-freeze-gifographic');
}

function freeze_gif(i) {
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
	set_src_to_data_src(image);
}

function setup_gifographic(image) {
	freeze_gif_first_time(image);
}

function bind_freeze_to_loading_gifs($container) {
	$container
		.imagesLoaded()
		.progress( function() {
			var image = this[0];
			if (is_gif_image(image)) {
				setup_gifographic(image);
			}
		});
}

function freeze_loaded_gifs($container) {
	$container
		.find('img')
		.each(function(index, image) {
			if (image.complete && is_gif_image(image)) {
				setup_gifographic(image);
			}
		});
}

function setup_gifographics_on_vis_page() {
	var $visuals_container = $('.js-setup-visuals');

	bind_freeze_to_loading_gifs($visuals_container);
	freeze_loaded_gifs($visuals_container);
}
