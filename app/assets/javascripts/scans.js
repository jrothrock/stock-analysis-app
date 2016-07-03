/*
  Personally, I believe that switching between function() and () => can be confusing - in reference to the jQuery callbacks. 
  Regardless, I used arrow functions in callbacks where scoping was irrelevant. 
*/

var App = {

  tabSlideSwitcher(){
    $('.nav-tabs li').on('shown.bs.tab', () => {
      $('#magic-line').remove();
      App.tabSlide();
    });
  },

  tabSlideVars($magicLine){
    $magicLine
        .width($(".active").width())
        .css({"left": $(".active a").position().left, "visibility":'visible'})
        .data("origLeft", $magicLine.position().left)
        .data("origWidth", $magicLine.width());
  },

  tabSlide(){
    if (document.getElementById("category_tabs")){
      $('#category_tabs').append("<li id='magic-line'></li>");
      const $magicLine = $("#magic-line");
      $('.active').css({'border-bottom': 'none'});
      App.tabSlideVars($magicLine);
      $(window).resize(() => {
        App.tabSlideVars($magicLine);
      });
      $("#category_tabs li").find("a").hover(function() {
        $el = $(this);
        leftPos = $el.position().left;
        newWidth = $el.parent().width();
        $magicLine.stop().animate({
          left: leftPos,
          width: newWidth
        });
      }, () => {
        $magicLine.stop().animate({
          left: $magicLine.data("origLeft"),
          width: $magicLine.data("origWidth")
        });
      });
    }
  },

  disableEnterForm(){
    $('#scan_stock').on('keyup keypress', (e) => {
      const keyCode = e.keyCode || e.which;
      if (keyCode === 13) { 
        e.preventDefault();
        return false;
      }
    });
  },

  flashInit(){
    if (document.getElementById("flash")){
      const content = $('#flash').html();
      const type = $('#flash').data("type");
      const time = $('#flash').data("time");
      notie.alert(type, content, time);
      $('#flash').fadeOut();
    }
  },

    afterChart(ScanId){
    $(`#hider-${ScanId}`).on("click", function(){
      $(`#container${ScanId}`).fadeOut(300, function() { $(this).remove(); });
      $(`.scan-${ScanId}`).css({'visibility':'visible'});
      const $parent = $(this).parent();
      $(this).remove();
      setTimeout(() => { 
        if (($('.scans').last().data('scan')) !== $parent.data('scan') && $width >= 1100){
          $parent.css({'border-bottom': '0px'});
        }
      }, 300);
    });
  },

  createGraphs(data, stockName, id){
          window.chart = new Highcharts.Chart({
            chart: {
              renderTo: `container${id}`
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
  
  graphInit(){
    $(".more-info").on("click", function(){
      $(this).css({'visibility':'hidden'});
      const ScanID = $(this).data("scan-id");
      $(this).parent().append(`<div class='selector' id='hider-${ScanID}'><p>Less Info</p></div>`);
      if($width >= 1100){
        $(this).parent().css({'border-bottom': '1px solid #aaa'});
        $(this).parent().after(`<div id='container${ScanID}' style='margin-bottom:10px'></div>`);
      }else{
        $(this).parent().after(`<div id='container${ScanID}' style='margin-bottom:10px;margin-top:20px'></div>`);
      }
      const ScanStock = $(this).data("scan-stock");

    $.ajax({
      type: "POST",
          url: "/more-info",
          data: {
            stock: ScanStock 
          },
          success(data, textStatus, jqXHR){
            App.createGraphs(data, ScanStock, ScanID);
          },
        error(xhr, textStatus, error){
          console.log(xhr.statusText);
          console.log(textStatus);
          console.log(error);
        }
      });
    });
  },

  weatherClick(){
    $('#weather-b').on("click", () => {
      confirm = notie.confirm('Are you sure you want to? This data is collected automatically. Continuing may mess up the data calculations.', 'Yes', 'Cancel', () => {
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

  fundamentalClick(){
    $("#fundamentals-button").on("click", () => {
      $.ajax({
        type: "GET",
            url: "/fundamentals",
      });
    });
  },

  backToTop() {
    $(window).scroll(function(){
      if ($(this).scrollTop() > 100 && $width >= 1100) {
        $('#back-to-top').fadeIn();
      } else {
        $('#back-to-top').fadeOut();
      }
    });
    $('#back-to-top').on('click', (e) => {
      e.preventDefault();
      $('html, body').animate({scrollTop : 0},1000);
      return false;
    });
  },

  cssRecurse(number){
  const numbers = [];
  function Recur(num){
    let newNum = num - 14;
    if(newNum  >  0){
      numbers.push(newNum);
      Recur(newNum);
    }
     return false;
  }
  Recur(number);
  return numbers;
 },

  addCss(){
    const pagination = parseInt($('.scans').first().data('scan'));
    const elements = App.cssRecurse(pagination);
    $.each(elements, (key,value) => {
      if($(`div[data-scan="${value}"]`)){
        $(`div[data-scan="${value}"]`).css({"border-bottom": "1px solid #999"});
      }
    });
    $('.scans').last().css({"border-bottom": "1px solid #999"});
  },

  mobileMenu(){
    $('.nav-selector').on('click tap', () => {

      if(!($('.main').hasClass('active-elm'))){
        $('.main').addClass('active-elm');
        $(".pushed").addClass('active-push');
      }else{
        setTimeout(() => { 
          $('.main').removeClass('active-elm');
          $(".pushed").removeClass('active-push');
        }, 500);
      }

      $('.main').toggleClass('move-to-right');
    });
    $(window).resize(() => {
      $('.main').removeClass('move-to-right');
    });
  },

  init(){
    window.alert = function(){};
    //renderLoaded, fundamentalsLoaded, and $width are global
    renderLoaded = 0; 
    fundamentalsLoaded = 0; 
    $width = window.outerWidth; 
    App.flashInit();
    App.disableEnterForm();
    App.tabSlideSwitcher();
    App.tabSlide();
    App.graphInit();
    App.weatherClick();
    App.fundamentalClick();
    App.backToTop();
    App.addCss();
    App.mobileMenu();
    $(window).resize(() => {
      $width = window.outerWidth; 
    });
  }
};  

$(document).on('turbolinks:load', App.init());
