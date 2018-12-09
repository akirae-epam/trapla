$(function() {
  //１アクティビティにマウスを載せたら編集メニューを表示
  $('.plan_detail').mouseover(function(){
    $(this).css('background-color', '#E0FFFF');
    $(this).children('.plan_detail_edit').show();

  })
  $('.plan_detail').mouseout(function(){
    $(this).css('background-color', '');
    $(this).children('.plan_detail_edit').hide();
  })

})
