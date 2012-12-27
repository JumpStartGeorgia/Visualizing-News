$(document).ready(function(){

	if (gon.edit_visualization){
		// load the date time pickers
		$('#visualization_published_date').datepicker({
				dateFormat: 'dd.mm.yy',
		});
		if (gon.published_date !== undefined && gon.published_date.length > 0)
		{
			$("#visualization_published_date").datepicker("setDate", new Date(gon.published_date));
		}

		// if record is published, show pub date field by default
		if ($('input:radio[name=visualization[published]]:checked').val() === 'true') {
			$('#visualization_published_date_input').show();
		} else {
			$('#visualization_published_date_input').hide();
		}

		// if record is marked as published, show pub date field
		$("input:radio[name=visualization[published]]").click(function(){
			if ($(this).val() === 'true'){
				// show url textbox
			  $('#visualization_published_date_input').show(300);
			} else {
				// clear and hide pub date textbox
				$('#visualization_published_date').attr('value', '');
			  $('#visualization_published_date_input').hide(300);
			}
		});

	}






  $('form[class*="form"].visualization.precrop').submit(function ()
  {
    var el = $(this);
    if (!el.hasClass('precrop'))
    {
      return true;
    }

    $.post(el.attr('action').replace('.json', '') + '.json', el.serialize())
    .success(function (response)
    {
      if (response.url !== false)
      {
        window.visdata = response.visdata;
        $('#fields-panel').hide();

        var img = new Image;
        img.src = response.url;

        $('#crop-panel').prepend(img);

        $(img).Jcrop({
          onChange: update_crop,
          onSelect: update_crop,
          setSelect: [0, 0, 500, 500],
          aspectRatio: 1
        });

        $('#crop-panel').show().children('div.preview').html($(img).clone());

        window.visdata.preview = $('.preview img');
        window.visdata.crop_x = $("#visualization_crop_x");
        window.visdata.crop_y = $("#visualization_crop_y");
        window.visdata.crop_w = $("#visualization_crop_w");
        window.visdata.crop_h = $("#visualization_crop_h");

        el.removeClass('precrop');
        $('[name="visualization\[cropping_started\]"]').val('true');
      }
      else
      {
      }
    })
    .error(function (response)
    {
      console.log('error', "\n", response);
    });
    
    return false;
  });










});




function update_crop (coords)
{
  var rx = 180/coords.w;
  var ry = 180/coords.h;
  visdata.preview.css({
    width: Math.round(rx * visdata.largeW) + 'px',
    height: Math.round(ry * visdata.largeH) + 'px',
    marginLeft: '-' + Math.round(rx * coords.x) + 'px',
    marginTop: '-' + Math.round(ry * coords.y) + 'px'
  });
  var ratio = visdata.originalW / visdata.largeW;
  window.visdata.crop_x.val(Math.round(coords.x * ratio));
  window.visdata.crop_y.val(Math.round(coords.y * ratio));
  window.visdata.crop_w.val(Math.round(coords.w * ratio));
  window.visdata.crop_h.val(Math.round(coords.h * ratio));
}















