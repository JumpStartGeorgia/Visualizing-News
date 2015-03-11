$(function ()
{

  $('#new_message').on('submit', function ()
  {
    $.post($(this).attr('action'), $(this).serialize(), function (data)
    {
      $('#contact').html(data);
    });
    return false;
  });

});
