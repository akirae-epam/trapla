// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require bootstrap
//= require moment
//= require bootstrap-datetimepicker
//= require turbolinks
//= require_tree .


// 関数を定義
jQuery.extend({
  sum: function(array) { //配列の合計値を算出
    return array.reduce(function(p, c) { return Number(p) + Number(c); } );
  },
  moneySum: function(moneyArray) {
    var total_money = jQuery.sum(moneyArray);
    $('#payments_output_total').text('合計：' + jQuery.jpyen(total_money));
  },
  jpyen: function(money) {  // 数字を円表記に変換
    moneys = String(Number(money)).split('');
    let moneyLen = moneys.length;
    moneys.forEach( function(val,index,array) {
      if ((index+1) % 3 === 0  && index+1 !== moneyLen) {
        moneys.splice(moneyLen-(index+1), 0, ',');
      }
    });
    moneys.unshift('\¥');
    moneys = moneys.join('');
    return moneys;
  },
  default: function() {
    // 表示したアクティビティフォーム関連
    // datepickerカレンダー表示
    var data = {'data-date-format': 'YYYY/MM/DD HH:mm' };
    $(function(){
      $('.datepicker').attr(data);
      $('.datepicker').datetimepicker();
    });

    // 持ち物を入力したらリアルタイムで表示
    $('#input_belongings').on('input', function() {
      var belongings = $(this).val().split(/\r\n|\r|\n/);
      var output = '';
      $.each(belongings, function(index, value) {
          output += '<li>'+value+'</li>';
      });
      $('#output_belongings').html(output);
    });

    //費用項目にカンマは入力できない
    $('#plan_detail_payment_item').on('input', function() {
      let value = $(this).val();
      $(this).val(value.replace(/\,/, ''));
    });

    //費用は数値しか入力できない
    $('#plan_detail_payment_money').on('input', function() {
      let value = $(this).val();
      $(this).val(value.replace(/[^0-9]+/g, ''));
    });

    // 費用を追加ボタンを押したら表示する費用を追加
    $('#payment_button').on('click', function() {
      // hidden(DBから取得した値)の値を取得
      dbItem = $('#plan_detail_payments_items').val();
      dbMoney = $('#plan_detail_payments_moneys').val();
      var draw_item = dbItem ? dbItem.split(',') : new Array();
      var draw_money = dbMoney ? dbMoney.split(',') : new Array();
      // テキストボックスの値を取得
      var input_item = $('#plan_detail_payment_item').val();
      var input_money = $('#plan_detail_payment_money').val();
      // 入力値を配列に追加
      draw_item.push(input_item);
      draw_money.push(input_money);
      // 入力値を描写
      $('#payments_output_item').append('<li>'+input_item+'</li>');
      $('#payments_output_money').append('<li>'+jQuery.jpyen(input_money)+'</li>');
      // hiddenの値(DBへ送信する値)を書き換え
      $('#plan_detail_payments_items').val(draw_item);
      $('#plan_detail_payments_moneys').val(draw_money);

      //合計値を描写
      jQuery.moneySum(draw_money);
    });
  }
});
