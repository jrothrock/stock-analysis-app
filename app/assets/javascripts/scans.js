var App = {

  tabSlideIniter: function(){
    $('.nav-tabs li').on('shown.bs.tab', function() {
      $('#magic-line').remove();
      App.tabSlide();
    });
  },

  tabSlide: function() {
    if (!(!(document.getElementById("category_tabs")))){
      $('#category_tabs').append("<li id='magic-line'></li>");
      var $magicLine = $("#magic-line");
      $magicLine
        .width($(".active").width())
        .css({"left": $(".active a").position().left, "visibility":'visible'})
        .data("origLeft", $magicLine.position().left)
        .data("origWidth", $magicLine.width());
      $("#category_tabs li").find("a").hover(function() {
        $el = $(this);
        leftPos = $el.position().left;
        newWidth = $el.parent().width();
        $magicLine.stop().animate({
          left: leftPos,
          width: newWidth
        });
      }, function() {
        $magicLine.stop().animate({
          left: $magicLine.data("origLeft"),
          width: $magicLine.data("origWidth")
        });
      });
    }
  },

  disableEnterForm: function(){
    $('#scan_stock').on('keyup keypress', function(e) {
      var keyCode = e.keyCode || e.which;
      if (keyCode === 13) { 
        e.preventDefault();
        return false;
      }
    });
  },

  flashInit: function(){
    if (!(!(document.getElementById("flash")))){
      var content = $('#flash').html();
      var type = $('#flash').data("type");
      var time = $('#flash').data("time");
      notie.alert(type, content, time);
      $('#flash').fadeOut();
    }
  },

  afterChart: function(ScanId){
    $("#hider-" + ScanId).on("click", function(){
      $("#container" + ScanId).fadeOut(300, function() { $(this).remove(); });
      $(".scan-" + ScanId).css({'visibility':'visible'});
      $(this).remove();
    });
  },

  createGraphs: function(data, stockName, id){
          window.chart = new Highcharts.Chart({
            chart: {
              renderTo: 'container' + id
            },
            title: {
              text: stockName,
              x: -20
            },
            subtitle: {
              text: 'Data Provided By: Yahoo Finance.',
              x: -20
            },
            xAxis: {
              categories: data['data']['dates']
            },
            yAxis: {
              title: {
                text: 'Stock Price in Dollars ($)'
              },
              plotLines: [
                {
                  value: 0,
                  width: 1,
                  color: '#808080'
                }
              ]
            },
            legend: {
              layout: 'vertical',
              align: 'right',
              verticalAlign: 'middle',
              borderWidth: 0
            },
            series: [
              {
                name: 'Close Price',
                data: data['data']['close_prices']
              }, {
                name: 'Open Price',
                data: data['data']['open_prices']
              }
            ]
          });
          App.afterChart(id);
  },
  
  graphInit: function(){
    $(".more-info").on("click", function(){
      $(this).css({'visibility':'hidden'});
      var ScanID = $(this).data("scan-id");
      $(this).parent().append("<div class='selector' id='hider-" + ScanID + "'><p>Less Info</p></div>");
      $(this).parent().append("<div id='container" + ScanID + "' style='margin-bottom:10px'></div>");
      var ScanStock = $(this).data("scan-stock");

    $.ajax({
      type: "POST",
          url: "/more-info",
          data: {
            stock: ScanStock 
          },
          success: function(data, textStatus, jqXHR){
            App.createGraphs(data, ScanStock, ScanID);
          },
        error: function(xhr, textStatus, error){
          console.log(xhr.statusText);
          console.log(textStatus);
          console.log(error);
        }
      });
    });
  },

  fundamentalClick: function(){
    $("#fundamentals-button").on("click", function(){
      var tabName = $('#fundamentals').attr('id');
      $.ajax({
        type: "GET",
            url: "/fundamentals",
      });
    });
  },


  init: function(){
    window.alert = function() {};
    renderLoaded = 0; //make this ish global
    fundamentalsLoaded = 0; //make this ish global
    App.flashInit();
    App.disableEnterForm();
    App.tabSlideIniter();
    App.tabSlide();
    App.graphInit();
    App.fundamentalClick();
  }
};  

$(document).on('turbolinks:load', App.init());
