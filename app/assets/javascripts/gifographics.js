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

function gif_cover_image(gif_image) {
	return $(gif_image).siblings('.js-is-gif-cover');
}

function hide_cover_image(gif_image) {
	gif_cover_image(gif_image).addClass('is-hidden');
}

function show_cover_image(gif_image) {
	gif_cover_image(gif_image).removeClass('is-hidden');
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

function bind_freeze_play_gif_on_click_element(gif, clickable) {
	$(clickable).click(function() {
		if ($(gif).hasClass('is-frozen')) {
			play_gif(gif);
		} else {
			freeze_gif(gif);
		}
	});
}

function make_playable(gifographic) {
	bind_freeze_play_gif_on_click_element(gifographic, gifographic);
}

function setup_gifographic_pre_add_to_dom(gifographic) {
	freeze_gif(gifographic);

	if (gifographic_is_playable(gifographic)) {
		make_playable(gifographic);
	}
}

function setup_gifographic_post_add_to_dom(gifographic) {
	if (gifographic_is_playable(gifographic)) {
		if (gif_cover_image(gifographic).length > 0) {
			bind_freeze_play_gif_on_click_element(
				gifographic,
				gif_cover_image(gifographic)[0]
			);
		}
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

function load_gifographic_from_placeholder($placeholder) {
	var gifographic = create_gif_image_from_placeholder($placeholder);

	$(gifographic).one('load', function(){
		setup_gifographic_pre_add_to_dom(gifographic);
		replace_placeholder_with_gifographic($placeholder, gifographic);
		setup_gifographic_post_add_to_dom(gifographic);
	});
}

function setup_gifographics() {
	$gifographics().each(function() {
		load_gifographic_from_placeholder($(this));
	});
}
