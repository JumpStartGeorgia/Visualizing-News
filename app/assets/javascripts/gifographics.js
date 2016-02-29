function set_data_src_to_src(tag) {
	$(tag).data('srcOriginal', tag.src);
}

function set_src_to_data_src(tag) {
	tag.src = $(tag).data().srcOriginal;
}

function set_stop_title(tag) {
	tag.title = $(tag).data().stopTitle;
}

function set_play_title(tag) {
	tag.title = $(tag).data().playTitle;
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

function $gifographics() {
	return $('.js-is-gifographic');
}

function gifographic_is_playable(gifographic_image) {
	return $(gifographic_image).hasClass('js-gif-is-playable');
}

function freeze_gif(i) {
	if (gifographic_is_playable(i)) {
		$(i).addClass('is-frozen');
		set_play_title(i);
		show_cover_image(i);
	}

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

function play_gif(image) {
	$(image).removeClass('is-frozen');
	set_stop_title(image);
	hide_cover_image(image);

	set_src_to_data_src(image);
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

function setup_gifographic(gifographic) {
	freeze_gif(gifographic);
	
	if (gifographic_is_playable(gifographic)) {
		bind_freeze_play_on_click_to_gif(gifographic);
	}
}

function replace_placeholder_with_gifographic($placeholder, gifographic_image) {
	$placeholder.after(gifographic_image);
	$placeholder.remove();
}

function create_gif_image_from_placeholder($placeholder) {
	var gif = $placeholder.clone()[0];
	gif.src = $placeholder.data('srcOriginal');
	
	return gif;
}

function setup_gifographics() {
	$gifographics().each(function() {
		var $placeholder = $(this);
		var gifographic_image = create_gif_image_from_placeholder($placeholder);
		
		$(gifographic_image).one('load', function(){
			setup_gifographic(gifographic_image);
			replace_placeholder_with_gifographic($placeholder, gifographic_image);
		});
	});
}
