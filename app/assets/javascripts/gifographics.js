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

function $gifographics() {
	return $('.js-is-gifographic');
}
