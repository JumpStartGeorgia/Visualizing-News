function create_gifographic_from_placeholder($placeholder) {
	var gif_image = $placeholder.clone()[0];
	gif_image.src = $placeholder.data('srcOriginal');

	var gif = create_gif(gif_image);

	var gifographic = {}

	function on_gif_play() {
		if (gifographic.cover_image) gifographic.cover_image.hide();
	}

	function on_gif_freeze() {
		if (gifographic.cover_image) gifographic.cover_image.show();
	}

	function replace_placeholder() {
		gif.add_to_dom_after($placeholder);
		$placeholder.remove();
	}

	function setup_pre_add_to_dom() {
		gif.freeze(on_gif_freeze);

		if (gif.is_playable()) {
			gif.make_playable(on_gif_play, on_gif_freeze);
		}
	}

	function setup_post_add_to_dom() {
		if (gif.is_playable() && gifographic.cover_image) {
			gif.make_playable_by(
				gifographic.cover_image.img, on_gif_play, on_gif_freeze
			);
		}
	}

	function setup() {
		setup_pre_add_to_dom();
		replace_placeholder();
		setup_post_add_to_dom();
	}

	Object.defineProperty(gifographic, 'cover_image', {
		get: function() {
			delete this.cover_image;
			return this.notifier = create_cover_image(gif_image);
		}
	})

	gifographic.setup_on_load = function() {
		gif.on_load_do(setup);
	}

	return gifographic;
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

function $gifographics() {
	return $('.js-is-gifographic');
}
