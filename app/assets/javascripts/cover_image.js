// Creates a hideable/showable image
function create_cover_image(sibling_element) {
	var $image = $(sibling_element).siblings('.js-is-cover-image');

  if ($image === []) {
    return nil;
  }

  var cover_image = {}

	cover_image.hide = function() {
		$image.addClass('is-hidden');
	}

	cover_image.show = function() {
		$image.removeClass('is-hidden');
	}

	Object.defineProperty(cover_image, 'img', {
		get: function() {
			return $image[0];
		}
	})

	return cover_image;
}
