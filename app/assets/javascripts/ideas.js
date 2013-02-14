$(document).ready(function(){
  // if user is not logged in, activate login when click into form
  $('#ideas_index_header a#ideas_form_signin').click(function(){
    if (!gon.user_signed_in){
      $('a#user_sign_in').fancybox().trigger('click');
      return false;
    } 
  });
  $('#shared-idea-form a#ideas_form_signin').click(function(){
    if (!gon.user_signed_in){
      $('a#user_sign_in').fancybox().trigger('click');
      return false;
    } 
  });
  $('form#form_new_idea textarea#idea_explaination').click(function(){
    if (!gon.user_signed_in){
      $('a#user_sign_in').fancybox().trigger('click');
    } 
  });
  $('form#form_new_idea').submit(function(){
    if (!gon.user_signed_in){
      $('a#user_sign_in').fancybox().trigger('click');
      return false;
    } 
  });
  $('form#form_new_idea select#idea_category_ids').bind("multiselectopen", function(event, ui){
    if (!gon.user_signed_in){
      $('form#form_new_idea select#idea_category_ids').multiselect('close');
      $('a#user_sign_in').fancybox().trigger('click');
    } 
  });

});


$(document).ready(function(){
	// if an organization progress needs to be translated,
	// get the text to be translated and put it in the link
	$('.translate_org_progress').each(function(index){
		id = $(this).attr('data-id');
		// get the text
		text = encodeURIComponent($('#org_progress_' + id).text());

		// update the url with this text
		$(this).attr('href', $(this).attr('href').replace(gon.placeholder, text));

	});


	if (gon.edit_idea_progress){
		// load the date time pickers
		$('#idea_progress_progress_date').datepicker({
				dateFormat: 'dd.mm.yy',
		});
		if (gon.progress_date !== undefined && gon.progress_date.length > 0)
		{
			$("#idea_progress_progress_date").datepicker("setDate", new Date(gon.progress_date));
		}

		// if record is completed, show url field by default
		if ($('select#idea_progress_idea_status_id').val() === gon.idea_status_id_published) {
			$('#idea_progress_url_input').show();
		}

		// if progress is marked as completed, show news url field
		$("select#idea_progress_idea_status_id").change(function(){
			if ($(this).val() === gon.idea_status_id_published){
				// show url textbox
				$('#idea_progress_url_input').show(300);
			} else {
				// clear and hide url textbox
				$('#idea_progress_url').attr('value', '');
				$('#idea_progress_url_input').hide(300);
			}
		});
	}


  // when ideas search form submitted, stop form and make it link request
  $('form#ideas_form_search').submit(function(){
    window.location.href = updateQueryStringParameter($('form#ideas_form_search').attr('action'), 'q', $('form#ideas_form_search input#q').val());
    return false;
  });






  $('#new_idea_inappropriate_report input[type="radio"]').change(function ()
  {
    $(this).parent().siblings('input').hide();
    $('#new_idea_inappropriate_report input[type="radio"]:checked').parent().next('input').show().focus();
  });


});
