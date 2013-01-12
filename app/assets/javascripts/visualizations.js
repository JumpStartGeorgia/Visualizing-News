function reset_interactive_iframe_height(){
	// adjust iframe height to fill entire window minus the header bar
	$('iframe#interactive').css('height', $(window).height()-46);
}

// we need 230px from original file.
// the large file that is shown on screen for cropping can be a different size
// so adjust the values so the scale is the same
var adjusted_size = gon.thumbnail_size;
if (gon.originalW && gon.largeW){

  if (gon.largeW != $('#cropbox').width()){
    // the layout may cause the large image to not display at its full size
    // - when this happens, the sizes used for calculations must be reset
    //   to the image size on screen
    gon.largeW = $('#cropbox').width();
    gon.largeH = $('#cropbox').height();

    adjusted_size = gon.thumbnail_size*gon.largeW/gon.originalW;

  } else {
    adjusted_size = gon.thumbnail_size*gon.largeW/gon.originalW;
  }

  // adjust preview box height/width
  $('.preview').css('width', adjusted_size).css('height', adjusted_size);
}

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
  $("#visualization_crop_x").val(Math.round(coords.x * ratio));
  $("#visualization_crop_y").val(Math.round(coords.y * ratio));
  $("#visualization_crop_w").val(Math.round(coords.w * ratio));
  $("#visualization_crop_h").val(Math.round(coords.h * ratio));
}

$(document).ready(function(){
	// visualization show interactive
	// - adjust iframe height when window changes
	if (gon.show_interactive){
		$(window).bind('load resize', reset_interactive_iframe_height);
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
			if ($(this).val() == '1'){ // infographic
				$('.trans_visual_file').show(300);
				$('.trans_interactive_url').hide(300);
				$('input[id$="_interactive_url"]').attr('value', '');
			} else if ($(this).val() == '2'){ // interactive
				$('.trans_interactive_url').show(300);
				$('.trans_visual_file').hide(300);
				$('input[id$="_visual"]').attr('value', '');
			} else {
				$('.trans_interactive_url').hide(300);
				$('.trans_visual_file').hide(300);
			}
		});

		// if record is published, show pub date field by default
		if ($('input:radio[name="visualization[published]"]:checked').val() === 'true') {
			$('#visualization_published_date_input').show();
		} else {
			$('#visualization_published_date_input').hide();
		}

		// if record is marked as published, show pub date field
		$('input:radio[name="visualization[published]"]').click(function(){
			if ($(this).val() === 'true'){
				// show url textbox
			  $('#visualization_published_date_input').show(300);
			} else {
				// clear and hide pub date textbox
				$('#visualization_published_date').attr('value', '');
			  $('#visualization_published_date_input').hide(300);
			}
		});

		// assign the jcrop to the visual image

	  $('img#cropbox').Jcrop({
	    onChange: update_crop,
	    onSelect: update_crop,
	    setSelect: [0, 0, adjusted_size, adjusted_size],
			minSize: [adjusted_size,adjusted_size],
//			maxSize: [adjusted_size, adjusted_size],
	    aspectRatio: 1
	  });

	}


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
