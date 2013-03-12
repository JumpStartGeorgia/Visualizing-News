$(function ()
{

  $('#new_message').live('submit', function ()
  {
    $.post($(this).attr('action'), $(this).serialize(), function (data)
    {
      $('#contact').html(data);
    });
    return false;
  });

});
