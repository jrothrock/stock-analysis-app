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
      $(this).parent().css({'border-bottom': '0px'});
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
      $(this).parent().css({'border-bottom': '1px solid #aaa'});
      $(this).parent().append("<div class='selector' id='hider-" + ScanID + "'><p>Less Info</p></div>");
      $(this).parent().after("<div id='container" + ScanID + "' style='margin-bottom:10px'></div>");
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

  weatherClick: function(){
    $('#weather-b').on("click", function(){
      confirm = notie.confirm('Are you sure you want to? This data is collected automatically. Continuing may mess up the data calculations.', 'Yes', 'Cancel', function() {
        notie.alert(4, 'Generating report. Due to API restrictions, this will take a couple of minutes...', 10);
        $.ajax({
          type: "POST",
              url: "/forecasts",
              body:{
                "utf8" : "✓", 
                 "commit" : "New Report"
              }
          });
          });
    });
  },

  fundamentalClick: function(){
    $("#fundamentals-button").on("click", function(){
      $.ajax({
        type: "GET",
            url: "/fundamentals",
      });
    });
  },

  backToTop: function() {
    $(window).scroll(function(){
      if ($(this).scrollTop() > 100) {
        $('#back-to-top').fadeIn();
      } else {
        $('#back-to-top').fadeOut();
      }
    });
    $('#back-to-top').on('click', function(e){
      e.preventDefault();
      $('html, body').animate({scrollTop : 0},1000);
      return false;
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
    App.weatherClick();
    App.fundamentalClick();
    App.backToTop();
  }
};  

$(document).on('turbolinks:load', App.init());
