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

function create_gif(gif_image) {
	var image = gif_image;

	return {
		cover_image: function() {
			return gif_cover_image(image);
		},

    play: function() {
      $(image).removeClass('is-frozen');
      set_stop_title(image);
      hide_cover_image(image);

      set_src_to_data_src(image);
    },

		freeze: function() {
			if (this.is_playable()) {
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
					that.play();
				} else {
					that.freeze();
				}
			});
		},

		is_playable: function() {
			return $(image).hasClass('js-gif-is-playable');;
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
