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
  setDatepicker: function() {
    // datepickerカレンダー表示
    var data = {'data-date-format': 'YYYY/MM/DD HH:mm' };
    $('.datepicker').attr(data);
    $('.datepicker').datetimepicker();
  },
  sum: function(array) { //配列の合計値を算出
    if ( array.length === 0 ) { return 0; }
    return array.reduce(function(p, c) { return Number(p) + Number(c); } );
  },
  moneySum: function(moneyArray) {
    var total_money = jQuery.sum(moneyArray);
    $('#payments_output_total').text('合計：' + jQuery.jpyen(total_money));
  },
  jpyen: function(money) {  // 数字を円表記に変換
    var moneys = String(Number(money)).split('');
    var moneyLen = moneys.length;
    moneys.forEach( function(val,index,array) {
      if ((index+1) % 3 === 0  && index+1 !== moneyLen) {
        moneys.splice(moneyLen-(index+1), 0, ',');
      }
    });
    moneys.unshift('\¥');
    var moneys = moneys.join('');
    return moneys;
  },
  loadItems: function() {
    // hidden(DBから取得した値)の費用項目を取得
    var dbItem = $('#plan_detail_payments_items').val();
    return dbItem ? dbItem.split(',') : [];
  },
  loadMoneys: function() {
    // hidden(DBから取得した値)の費用を取得
    var dbMoney = $('#plan_detail_payments_moneys').val();
    return dbMoney ? dbMoney.split(',') : [];
  },
  drawItem: function(index, item) {
    $('#payments_output_item').append('<li id="plan_detail_payments_item_' + index + '">'+item+'</li>');
  },
  drawMoney: function(index, money) {
    $('#payments_output_money').append('<li id="plan_detail_payments_money_' + index + '">'+jQuery.jpyen(money)+'　<i class="delete-money far fa-trash-alt"></i></li>');
  }
});

// 表示したアクティビティフォーム関連
$(function(){
  // 持ち物を入力したらリアルタイムで表示
  $(document).on('input', '#input_belongings', function() {
    var belongings = $(this).val().split(/\r\n|\r|\n/);
    var output = '';
    $.each(belongings, function(index, value) {
        output += '<li>'+value+'</li>';
    });
    $('#output_belongings').html(output);
  });

  //費用項目にカンマは入力できない
  $(document).on('input', '#plan_detail_payment_item', function() {
    var value = $(this).val();
    $(this).val(value.replace(/\,+/g, ''));
  });

  //費用は数値しか入力できない
  $(document).on('input', '#plan_detail_payment_money', function() {
    var value = $(this).val();
    $(this).val(value.replace(/[^0-9]+/g, ''));
  });

  // 費用を追加ボタンを押したら表示する費用を追加
  $(document).on('click', '.payment-button', function() {
    // テキストボックスの値を取得
    var inputItem = $('#plan_detail_payment_item').val();
    var inputMoney = $('#plan_detail_payment_money').val();

    // 空白はエラー出力
    if (inputItem === '' || inputMoney === '') {
      var errMessage = '費用項目と金額は必須入力です。';
      $('.err-message').addClass('alert alert-danger');
      $('.err-message').text(errMessage);
      return;
    } else {
      $('.err-message').removeClass('alert alert-danger');
      $('.err-message').text('');
    }

    // hidden(DBから取得した値)の値を取得
    var dbItem = jQuery.loadItems();
    var dbMoney = jQuery.loadMoneys();

    // 入力値を配列に追加
    dbItem.push(inputItem);
    dbMoney.push(inputMoney);
    var index = dbMoney.length;

    // 入力値をリストに追加描写
    jQuery.drawItem(index, inputItem);
    jQuery.drawMoney(index, inputMoney);

    // hiddenの値(DBへ送信する値)を書き換え
    $('#plan_detail_payments_items').val(dbItem);
    $('#plan_detail_payments_moneys').val(dbMoney);

    jQuery.moneySum(dbMoney); //合計値を描写
  });

  // 費用を削除ボタンを押したら費用を削除する
  $(document).on('click', '.delete-money', function() {
    var delIndex = $(this).parent().index();

    // hiddenの値(DBへ送信する値)を読み込み
    var dbItem = jQuery.loadItems();
    var dbMoney = jQuery.loadMoneys();

    // 配列と描写したHTMLから対象データを削除
    dbItem.splice(delIndex, 1);
    dbMoney.splice(delIndex, 1);
    $('#payments_output_item > li:eq(' + delIndex + ')').remove();
    $('#payments_output_money > li:eq(' + delIndex + ')').remove();

    // hiddenの値(DBへ送信する値)を書き換え
    $('#plan_detail_payments_items').val(dbItem);
    $('#plan_detail_payments_moneys').val(dbMoney);
    jQuery.moneySum(dbMoney); //合計値を描写
  });
});

lastFormId = '' // 最初はどのフォームも表示しない
