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

function create_gifographic_from_placeholder($placeholder) {
	var gif = $placeholder.clone()[0];
	gif.src = $placeholder.data('srcOriginal');

	function make_playable() {
		bind_freeze_play_gif_on_click_element(gif, gif);
	}

	function replace_placeholder() {
		$placeholder.after(gif);
		$placeholder.remove();
	}

	function setup_pre_add_to_dom() {
		freeze_gif(gif);

		if (gifographic_is_playable(gif)) {
			make_playable();
		}
	}

	function setup_post_add_to_dom() {
		if (gifographic_is_playable(gif)) {
			var gif_cover = gif_cover_image(gif)[0];

			if (gif_cover) {
				bind_freeze_play_gif_on_click_element(gif, gif_cover);
			}
		}
	}

	function setup() {
		setup_pre_add_to_dom();
		replace_placeholder();
		setup_post_add_to_dom();
	}

	return {
		setup_on_load: function() {
			$(gif).one('load', function() {
				setup();
			});
		}
	};
}

function load_gifographic_from_placeholder($placeholder) {
	var gifographic = create_gifographic_from_placeholder($placeholder);
	gifographic.setup_on_load();
}

function setup_gifographics() {
	$gifographics().each(function() {
		load_gifographic_from_placeholder($(this));
	});
}
