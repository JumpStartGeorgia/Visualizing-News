function reset_interactive_iframe_height(){
	// adjust iframe height to fill entire window minus the header bar
	$('iframe#interactive').css('height', $(window).height()-88);
}

var adjusted_size = gon.thumbnail_size;

function update_crop(coords) {
	var rx = adjusted_size/coords.w;
	var ry = adjusted_size/coords.h;
	$('#cropbox_preview').css({
		width: Math.round(rx * gon.largeW) + 'px',
		height: Math.round(ry * gon.largeH) + 'px',
		marginLeft: '-' + Math.round(rx * coords.x) + 'px',
		marginTop: '-' + Math.round(ry * coords.y) + 'px'
	});
  var ratio = gon.originalW / gon.largeW;
  $('input[id$="_crop_x"]').val(Math.round(coords.x * ratio));
  $('input[id$="_crop_y"]').val(Math.round(coords.y * ratio));
  $('input[id$="_crop_w"]').val(Math.round(coords.w * ratio));
  $('input[id$="_crop_h"]').val(Math.round(coords.h * ratio));
}

$(document).ready(function(){
	// visualization show interactive
	// - adjust iframe height when window changes
	if (gon.show_interactive){
		$(window).bind('load resize', reset_interactive_iframe_height);
	}

  // if coming from embed link, automatically show large image
  if (gon.trigger_fancybox_large_image){
    $("a.fancybox_visual").trigger('click');
  }

	// visualization form
	if (gon.edit_visualization){
		// load the date time pickers
		$('#visualization_published_date').datepicker({
				dateFormat: 'dd/mm/yy',
		});
		if (gon.published_date !== undefined && gon.published_date.length > 0)
		{
			$("#visualization_published_date").datepicker("setDate", new Date(gon.published_date));
		}

		// show correct fields for visualization type
		if (gon.visualization_type){
			if (gon.visualization_type == 1){
				$('.trans_visual_file').show();
				$('.trans_interactive_url').hide();
			} else if (gon.visualization_type == 2){
				$('.trans_interactive_url').show();
				$('.trans_visual_file').hide();
			}
		}

		// if language changes, show appropriate fields
		$('input[id^="visualization_languages"]').change(function() {
      var id = $(this).attr('id').split('_');
      var locale = id[id.length-1];
      if ($(this).is(':checked')) {
        $('#form-' + locale).show(300);
      } else {
        $('#form-' + locale).hide(300);
      }
		});

		// if type changes, show appropriate fields
		$('input[id^="visualization_visualization_type_id"]').change(function() {
      $('input[id$="_image_file_attributes_visualization_type_id"]').val($(this).val());
			if ($(this).val() == '1'){ // infographic
				$('.trans_visual_file').show(300);
				$('.trans_interactive_url').hide(300);
				$('input[id$="_interactive_url"]').val('');
			} else if ($(this).val() == '2'){ // interactive
				$('.trans_interactive_url').show(300);
				$('.trans_visual_file').hide(300);
				$('input[id$="_visual"]').val('');;
			} else {
				$('.trans_interactive_url').hide(300);
				$('.trans_visual_file').hide(300);
			}
		});

		// if record is published, show pub date field by default
		if ($('input:radio[name="visualization[published]"]:checked').val() === 'true') {
			$('#visualization_published_date_input').show();
			$('#visualization_is_promoted_input').show();
		} else {
			$('#visualization_published_date_input').hide();
			$('#visualization_is_promoted_input').hide();
		}

		// if record is marked as published, show pub date field
		$('input:radio[name="visualization[published]"]').click(function(){
			if ($(this).val() === 'true'){
				// show url textbox
			  $('#visualization_published_date_input').show(300);
  			$('#visualization_is_promoted_input').show(300);
			} else {
				// clear and hide pub date textbox
				$('#visualization_published_date').attr('value', '');
			  $('#visualization_published_date_input').hide(300);
				$('#visualization_is_promoted_true').removeAttr('checked');
				$('#visualization_is_promoted_false').attr('checked', 'checked');
  			$('#visualization_is_promoted_input').hide(300);
			}
		});

	  $('#cropbox').one('load', function() {
      // we need 230px from original file.
      // the large file that is shown on screen for cropping can be a different size
      // so adjust the values so the scale is the same
      if (gon.originalW && gon.largeW){
        if (gon.largeW != $(this).width()){
          // the layout may cause the large image to not display at its full size
          // - when this happens, the sizes used for calculations must be reset
          //   to the image size on screen
          gon.largeW = $(this).width();
          gon.largeH = $(this).height();

          adjusted_size = gon.thumbnail_size*gon.largeW/gon.originalW;

        } else {
          adjusted_size = gon.thumbnail_size*gon.largeW/gon.originalW;
        }

        // adjust preview box height/width
        $('.preview').css('width', adjusted_size).css('height', adjusted_size);
      }

		  // if crop values already exist, use them when creating jcrop preview box
		  var setInit = [0, 0, adjusted_size, adjusted_size];
		  if ($('input[id$="_crop_x"]').val() != '' && $('input[id$="_crop_y"]').val() != '' &&
				  $('input[id$="_crop_w"]').val() != '' && $('input[id$="_crop_w"]').val() != '0' &&
          $('input[id$="_crop_h"]').val() != '' && $('input[id$="_crop_h"]').val() != '0' ) {

			  setInit = [$('input[id$="_crop_x"]').val(), $('input[id$="_crop_y"]').val(),
								  (parseInt($('input[id$="_crop_w"]').val()) + parseInt($('input[id$="_crop_x"]').val())),
                  (parseInt($('input[id$="_crop_h"]').val()) + parseInt($('input[id$="_crop_y"]').val()))];
		  }
		  // assign the jcrop to the visual image
	    $(this).Jcrop({
	      onChange: update_crop,
	      onSelect: update_crop,
	      setSelect: setInit,
			  minSize: [adjusted_size,adjusted_size],
  //			maxSize: [adjusted_size, adjusted_size],
	      aspectRatio: 1
	    });
    }).each(function(){
      if (this.complete) { $(this).load(); }
    });

	}
  

  // when visual search form submitted, stop form and make it link request
  $('form#visuals_form_search').submit(function(){
    window.location.href = updateQueryStringParameter($('form#visuals_form_search').attr('action'), 'q', $('form#visuals_form_search input#q').val());
    return false;
  });

});



$(document).ready(function(){
  $('#category_slider_content li a').each(function(){
    $(this).css('background', "url('" + $(this).attr('data-path') + "')");
    $(this).css('background-position', 'top');
    $(this).css('background-repeat', 'no-repeat');
    $(this).hover(function(){
      $(this).css('background-position', '50% -31px');
    }, function(){
      $(this).css('background-position', 'top');
    });
  });
});
