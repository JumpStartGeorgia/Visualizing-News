// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require i18n
//= require i18n/translations
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.cookie
//= require twitter/bootstrap
//= require jquery_nested_form
//= require fancybox
//= require fancybox2
//= require olly.min
//= require vendor
//= require_directory .
//= require 'jquery.dynatable'


$(document).ready(function(){
	// set focus to first text box on page
	if (gon.highlight_first_form_field){
	  $(":input:visible:enabled:first").focus();
	}

	// workaround to get logout link in navbar to work
	$('body')
		.off('click.dropdown touchstart.dropdown.data-api', '.dropdown')
		.on('click.dropdown touchstart.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() });


  //if load more link exists, get the first page of items
  if ($('#load_more_link').length)
  {
    $.get(updateQueryStringParameter(gon.ajax_path, 'screen_w', $(window).width()), function (response)
    {
      $('#throbber').hide();
    });
  }



  if ($('#file_replacement').length)
  {
    $('#file_replacement').click(function ()
    {
      $('#' + $(this).data('inputid')).click();
    });
  }

  // register jquery multi select
  // - category list in ideas form
  $('select#idea_category_ids').multiselect({
    header: false,
    checkAllText: gon.multiselect_checkall,
    uncheckAllText: gon.multiselect_uncheckall,
    noneSelectedText: gon.multiselect_noneselected,
    selectedText: gon.multiselect_selected
  });
  // - visual notification categories
  $('select#visuals_categories').multiselect({
    header: false,
    checkAllText: gon.multiselect_checkall,
    uncheckAllText: gon.multiselect_uncheckall,
    noneSelectedText: gon.multiselect_noneselected,
    selectedText: gon.multiselect_selected
  });
  // - idea notification categories
  $('select#ideas_categories').multiselect({
    header: false,
    checkAllText: gon.multiselect_checkall,
    uncheckAllText: gon.multiselect_uncheckall,
    noneSelectedText: gon.multiselect_noneselected,
    selectedText: gon.multiselect_selected
  });


  // register search box in menu
  $('#follow-us #menu-search').keypress(function (e) {
    if (e.which == 13) {
      window.location.href = updateQueryStringParameter($(this).attr('data-path'), 'q', $(this).val());
    }
  });

  $('#frozen-menu a.menu-collapse').click(function ()
  {
    $('#frozen-menu a.menu-collapse img.' + ($('#frozen-menu div.menu-collapse').is(':visible') ? 'down' : 'up')).show().siblings('img').hide();
    $('#frozen-menu div.menu-collapse').slideToggle();
  //($(window).width() > 979) && $('#frozen-menu div.menu-collapse:visible').removeAttr('style');
  });

  function delayed_reload (delay)
  {
    var delay = delay || 3000;
    setTimeout('window.location.reload();', delay);
  }


  $('#user_new').on('submit', function ()
  {
    $.ajax({
      type: "POST",
      url: $(this).attr('action'),//.replace(/.json$/, '') + '.json',
      data: $(this).serialize(),
      //dataType: 'json',
      success: function (data)
      {
        var rhtml = $(data);
        var rform = rhtml.find('#sign_in_c, #sign_up_c, #forgot_password_c');
        if (rform.length && rform.find('#error_explanation').length)
        {
          $('#sign_in_c, #sign_up_c, #forgot_password_c').replaceWith(rform);
        }
        else if (rhtml.find('.alert.alert-info').length)
        {
          $('#sign_in_c, #sign_up_c, #forgot_password_c').replaceWith(rhtml.find('.alert.alert-info').children().remove().end());
          delayed_reload(3000);
        }
        else
        {
          window.location.reload();
        }
      },
      error: function (data)
      {
        $('#sign_in_c').parent().find('.alert').remove();
        $('#sign_in_c form').before('<div class="alert alert-error fade in"><a href="#" data-dismiss="alert" class="close">×</a> ' + data.responseText + '</div>');
        $('#sign_in_c input[type="password"]').val(null);
        $('#sign_in_c :input:visible:enabled:first').focus();
      }
    });
    return false;
  });

	$('.js-dynatable').each(function() {
		createDynatable($(this));
	});
});
