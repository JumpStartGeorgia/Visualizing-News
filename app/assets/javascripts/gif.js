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

function create_gif(gif_image) {
	var image = gif_image;

	function gif_cover_image() {
		return $(image).siblings('.js-is-gif-cover');
	}

	function hide_cover_image() {
		gif_cover_image().addClass('is-hidden');
	}

	function show_cover_image() {
		gif_cover_image().removeClass('is-hidden');
	}

	var gif = {}

	gif.cover_image = function() {
		return gif_cover_image();
	}

	gif.play = function() {
		$(image).removeClass('is-frozen');
		set_stop_title(image);
		hide_cover_image();

		set_src_to_data_src(image);
	}

	gif.freeze = function() {
		if (this.is_playable()) {
			$(image).addClass('is-frozen');
			set_play_title(image);
			show_cover_image();
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
	}

	gif.make_playable_by = function(element) {
		var that = this;

		$(element).click(function() {
			if ($(image).hasClass('is-frozen')) {
				that.play();
			} else {
				that.freeze();
			}
		});
	}

	gif.is_playable = function() {
		return $(image).hasClass('js-gif-is-playable');;
	}

	gif.add_to_dom_after = function($element) {
		$element.after(image);
	}

	gif.make_playable = function() {
		this.make_playable_by(image);
	}

	gif.on_load_do = function(callback) {
		$(image).one('load', function() {
			callback();
		});
	}

	return gif;
}
