// Creates an object that represents a playable/freezable gif image.
function create_gif(gif_image) {
	var gif = {}

	function set_data_src_to_src(gif_image) {
		$(gif_image).data('srcOriginal', gif_image.src);
	}

	function set_src_to_data_src(gif_image) {
		gif_image.src = $(gif_image).data().srcOriginal;
	}

	function set_stop_title(gif_image) {
		gif_image.title = $(gif_image).data().stopTitle;
	}

	function set_play_title(image) {
		image.title = $(gif_image).data().playTitle;
	}

	gif.play = function(callback) {
		$(gif_image).removeClass('is-frozen');
		set_stop_title(gif_image);
		callback();

		set_src_to_data_src(gif_image);
	}

	gif.freeze = function(callback) {
		if (this.is_playable()) {
			$(gif_image).addClass('is-frozen');
			set_play_title(gif_image);
			callback();
		}

		var c = document.createElement('canvas');
		var w = c.width = gif_image.width;
		var h = c.height = gif_image.height;
		c.getContext('2d').drawImage(gif_image, 0, 0, w, h);
		try {
			gif_image.src = c.toDataURL("image/gif"); // if possible, retain all css aspects
		} catch(e) { // cross-domain -- mimic original with all its tag attributes
			for (var j = 0, a; a = gif_image.attributes[j]; j++)
				c.setAttribute(a.name, a.value);
			gif_image.parentNode.replaceChild(c, gif_image);
		}
	}

	gif.make_playable_by = function(element, on_play_callback, on_freeze_callback) {
		var that = this;

		$(element).click(function() {
			if ($(gif_image).hasClass('is-frozen')) {
				that.play(on_play_callback);
			} else {
				that.freeze(on_freeze_callback);
			}
		});
	}

	gif.is_playable = function() {
		return $(gif_image).hasClass('js-gif-is-playable');;
	}

	gif.add_to_dom_after = function($element) {
		$element.after(gif_image);
	}

	gif.make_playable = function(on_play_callback, on_freeze_callback) {
		this.make_playable_by(gif_image, on_play_callback, on_freeze_callback);
	}

	gif.on_load_do = function(callback) {
		$(gif_image).one('load', function() {
			callback();
		});
	}

	return gif;
}
