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

function create_gif(gif_image) {
	var image = gif_image;

	return {
		cover_image: function() {
			return gif_cover_image(image);
		},

		freeze: function() {
			if (gifographic_is_playable(image)) {
				$(image).addClass('is-frozen');
				set_play_title(image);
				show_cover_image(image);
			}

			var c = document.createElement('canvas');
			var w = c.width = image.width;
			var h = c.height = image.height;
			c.getContext('2d').drawImage(image, 0, 0, w, h);
			try {
				image.src = c.toDataURL("image/gif"); // if possible, retain all css aspects
			} catch(e) { // cross-domain -- mimic original with all its tag attributes
				for (var j = 0, a; a = image.attributes[j]; j++)
					c.setAttribute(a.name, a.value);
				image.parentNode.replaceChild(c, image);
			}
		},

		make_playable_by: function(element) {
			var that = this;

			$(element).click(function() {
				if ($(image).hasClass('is-frozen')) {
					play_gif(image);
				} else {
					that.freeze();
				}
			});
		},

		is_playable: function() {
			return gifographic_is_playable(image);
		},

		add_to_dom_after: function($element) {
			$element.after(image);
		},

		make_playable: function() {
			this.make_playable_by(image);
		},

		on_load_do: function(callback) {
			$(image).one('load', function() {
				callback();
			});
		}
	}
}

function create_gifographic_from_placeholder($placeholder) {
	var gif_image = $placeholder.clone()[0];
	gif_image.src = $placeholder.data('srcOriginal');

	var gif = create_gif(gif_image);

	function replace_placeholder() {
		gif.add_to_dom_after($placeholder);
		$placeholder.remove();
	}

	function setup_pre_add_to_dom() {
		gif.freeze();

		if (gif.is_playable()) {
			gif.make_playable();
		}
	}

	function setup_post_add_to_dom() {
		if (gifographic_is_playable(gif)) {
			var gif_cover = gif.cover_image(gif)[0];

			if (gif_cover) {
				gif.make_playable_by(gif_cover);
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
			gif.on_load_do(setup);
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
