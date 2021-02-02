var firstTime = 3000;
var firstTime2 = 3000;
var firstTime3 = 3000;
var totalValue;
var dataObj, weekdayNumber,pieChart,weekChart;
var pieChartValue = [], weekChartValue = [],weekBeforeChartValue=[];
var machineState = ['Tanımsız', 'Acil Kaldırılıyor', 'Durduruldu', 'Başlatılıyor', 'Serbest', 'Askıda', 'Çalışıyor', 'Durduruluyor', 'Acil Durduruluyor', 'Acil Durduruldu', 'Bekletiliyor', 'Bekletildi', 'Bekletilme Kaldırılıyor', 'Askıya Alınıyor', 'Askıdan Kaldırılıyor', 'Resetleniyor', 'Tamamlanıyor', 'Tamamlandı'];
var unitState = ['Tanımsız', 'Otomatik', 'Kurulum', 'Manuel'];
var cus = $.connection.cusHub;
var cus1 = $.connection.cus1Hub;
var cus2 = $.connection.cus2Hub;

$(function () {
    // Declare a function on the job hub so the server can invoke it
    cus.client.displayCustomer = function () {
        getData();
    };
    cus1.client.displayCustomer = function () {
        getData2();
    };
    cus2.client.displayCustomer = function () {
        getData3();
    };
    // Start the connection
    $.connection.hub.start();
    getData();
    getData2();
    getData3();
    function getData() {
        $.ajax({
            type: 'GET',
            url: '/Buz1/PieChartGet',
            datatype: 'json',
            success: function (data) {
                getDelete();
                data.listPie.forEach(function (model) {
                    pieChartValue.push(model.MacATime, model.MacSTime, model.MacETime, model.MacState, model.UnitState);
                });
                if (firstTime2 != 0) {
                    drawDPieChart();
                    firstTime2 = 0;
                }
                else {
                    drawDPieChart();
                }
                getMachineState();
                getUnitState();
            }
        });
    }
    function getData2() {
        $.ajax({
            type: 'GET',
            url: '/Buz1/WeekChartGet',
            datatype: 'json',
            success: function (data) {
                getDelete2();
                data.listWeek.forEach(function (model) {
                    weekChartValue.push(model.Pzt, model.Sal, model.Cars, model.Pers, model.Cum, model.Cmt, model.Pzr);
                });
                if (weekBeforeChartValue.length >0) {
                    if (firstTime != 0) {
                        drawWeekChart();
                        firstTime = 0;
                    }
                    else {
                        drawWeekChart();
                    }
                }
                else {
                   getData2();
                }
                getProgress();
                getDays();
            }
        });
    }
    function getData3() {
        $.ajax({
            type: 'GET',
            url: '/Buz1/WeekBeforeChartGet',
            datatype: 'json',
            success: function (data) {
                data.listBeforeWeek.forEach(function (model) {
                    if (weekBeforeChartValue.length <= 6) {
                        weekBeforeChartValue.push(model.Pzt, model.Sal, model.Cars, model.Pers, model.Cum, model.Cmt, model.Pzr);
                    }
                    
                });
            }
           
        });
        return null;
    }
  
    function getDelete() {
        removeCookie();
        pieChartValue = [];
       
    }
    function getDelete2() {
        removeCookie();
        weekChartValue = [];
    }
    //function getDelete3() {
    //    removeCookie();
    //    weekBeforeChartValue = [];
    //}
    function drawDPieChart() {
        getChart();
        pieChart = new Highcharts.Chart(defaultOptions);
    }
    function drawWeekChart() {
        weekChart.series[0].remove(true);
        weekChart = new Highcharts.Chart(defaultOptions);
        getChart2();
    }
    function getChart() {
        Highcharts.setOptions({
            colors: ['#50B432','#ED561B','#DDDF00',  '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4']
        });
        pieChart = null,
            defaultOptions = {
                chart: {
                    renderTo: 'pieChart',
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie',
                    backgroundColor: 'transparent',

                },
                legend: {
                    useHTML: true,
                    labelFormatter: function () {
                        return '<div style="width:auto "><span style="font-family: corbel;color:' + this.color + ';font-size:15px">' + this.name + ': <b>' + this.y + '</b> </span></div> </n>';

                    }
                },
                title: {
                    text: 'Buzdolabı 1 Boru Sarma 1 Hücresi',
                    style: {
                        color: 'white',
                        fontWeight: 'bold'
                    }
                },
                tooltip: {
                    pointFormat: '{series.name}: <br>{point.percentage:.1f} %<br>Dakika: {point.y}'
                },
                accessibility: {
                    point: {
                        valueSuffix: '%'
                    }
                },
                plotOptions: {
                    pie: {

                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>:<br>{point.percentage:.1f} %<br>Dakika: {point.y}',
                            color: 'white',
                            fontWeight: 'bold'
                        },
                        showInLegend: true
                    },
                    series: {
                        animation: {
                            duration: firstTime2
                        }
                    }
                },
                drilldown: {
                    animation: {
                        duration: firstTime2
                    }
                },
                series: [{
                    name: 'Toplam',
                    colorByPoint: true,
                    data: [{
                        name: 'Çalışan Zaman',
                        y: pieChartValue[2],
                        sliced: true,
                        selected: true
                    }, {
                        name: 'Acil Duran Zaman',
                        y: pieChartValue[0],
                    }, {
                        name: 'Duran Zaman',
                        y: pieChartValue[1]

                    }]
                }]

        }
    }
   
    function getChart2() {
        weekChart = null,
            defaultOptions = {
            chart: {
                    renderTo: 'visitors-chart',
                    type: 'areaspline',
                    backgroundColor: 'transparent',

                },
                title: {
                    text: '',
                    style: {
                        color: 'white',
                        fontWeight: 'bold'
                    }
                },
                legend: {
                    layout: 'vertical',
                    align: 'left',
                    verticalAlign: 'top',
                    x: 100,
                    y: 15,
                    floating: true,
                    borderWidth: 1,
                    backgroundColor:
                        Highcharts.defaultOptions.legend.backgroundColor || '#FFFFFF'
                },
                xAxis: {
                    categories: [
                        'Pazartesi',
                        'Salı',
                        'Çarşamba',
                        'Perşembe',
                        'Cuma',
                        'Cumartesi',
                        'Pazar',

                    ],

                    plotBands: [{ // visualize the weekend
                        from: 4.5,
                        to: 6.5,
                        color: 'rgba(68, 170, 213, .2)'
                    }],
                    labels: {
                        style: {
                            color: 'white'
                        }
                    }
                },
                yAxis: {

                    title: {
                        text: 'Üretim Adedi',
                        style: {
                            color: 'white',
                            fontWeight: 'bold',

                        },

                    },
                    labels: {
                        style: {
                            color: 'white'
                        }
                    }
                },
                tooltip: {
                    shared: true,
                    valueSuffix: ' Adet',

                },
                credits: {
                    enabled: false
                },

                plotOptions: {
                    areaspline: {
                        fillOpacity: 0.5
                    }
                },
                series: [{
                    name: 'Bu Hafta',
                    data: weekChartValue,
                    animation: {
                        duration: firstTime,
                        // Uses Math.easeOutBounce
                        easing: 'easeOutBounce'
                    }

                }, {
                    name: 'Geçen Hafta',
                    data: [500,300,800,900,600,500,700],
                    animation: {
                        duration: firstTime,
                        // Uses Math.easeOutBounce
                        easing: 'easeOutBounce'
                    }
                }]
            }
    }
    function getProgress() {
        $('#weekProduction').empty();
        $('#pPercent').empty();
        $('#arrowchange').empty();
        $('#arrowchange').empty();
        document.getElementById("weekProduction").innerHTML = weekChartValue[0] + weekChartValue[1] + weekChartValue[2] + weekChartValue[3] + weekChartValue[4] + weekChartValue[5] + weekChartValue[6];
        totalValue = ((((weekChartValue[0] + weekChartValue[1] + weekChartValue[2] + weekChartValue[3] + weekChartValue[4] + weekChartValue[5] + weekChartValue[6]) - 50000) / 50000) * 100);
        document.getElementById("pPercent").innerHTML = parseInt(a);
        if (a < 0) {

            document.querySelector("#arrowchange").innerHTML = '<i class="fas fa-arrow-down" style="color:red "></i>';
            document.getElementById('persentcolor').style = "color:red";
            document.getElementById('pPercent').style = "color:red";

        }
        else if (a == 0) {
            document.querySelector("#arrowchange").innerHTML = '<i class="fas fa-arrow-right" style="color:yellow"></i>';
            document.getElementById('persentcolor').style = "color:yellow";
            document.getElementById('pPercent').style = "color:yellow";
        }
        else {
            document.querySelector("#arrowchange").innerHTML = '<i class="fas fa-arrow-up" style="color:#22bb33"></i>';
            document.getElementById('persentcolor').style = "color:#22bb33";
            document.getElementById('pPercent').style = "color:#22bb33";
        }
       
    }
    function getDays() {
        $('#pnumber').empty();
        dataObj = new Date();
        weekdayNumber = dataObj.getDay();
        if (weekdayNumber == 0) {
            document.getElementById("pnumber").innerHTML = weekChartValue[6]
        }
        else if (weekdayNumber == 1) {
            document.getElementById("pnumber").innerHTML = weekChartValue[0]
        }
        else if (weekdayNumber == 2) {
            document.getElementById("pnumber").innerHTML = weekChartValue[1]
        }
        else if (weekdayNumber == 3) {
            document.getElementById("pnumber").innerHTML = weekChartValue[2]
        }
        else if (weekdayNumber == 4) {
            document.getElementById("pnumber").innerHTML = weekChartValue[3]
        }
        else if (weekdayNumber == 5) {
            document.getElementById("pnumber").innerHTML = weekChartValue[4]
        }
        else if (weekdayNumber == 6) {
            document.getElementById("pnumber").innerHTML = weekChartValue[5]
        }
       
    }
    function getMachineState() {
        $('#prun').empty();
        document.getElementById("prun").innerHTML = machineState[pieChartValue[3]];
        if (machineState[pieChartValue[3]] == machineState[6] && unitState[pieChartValue[4]] == unitState[1]) {
            document.getElementById('pruncolor').style = "background-color:#22bb33";
        }
        else if (machineState[pieChartValue[3]] == machineState[1] || machineState[pieChartValue[3]] == machineState[8] || machineState[pieChartValue[3]] == machineState[9]) {

            document.getElementById('pruncolor').style = "background-color:red";

        } else if (machineState[pieChartValue[3]] == machineState[0]) {
            document.getElementById('pruncolor').style = "background-color:gray";
        }
        else {
            document.getElementById('pruncolor').style = "background-color:orange";

        }
       
    }

    function getUnitState() {
        $('#prun1').empty();
        document.getElementById("prun1").innerHTML = unitState[pieChartValue[4]];
        if (unitState[pieChartValue[4]] == unitState[1]) {
            document.getElementById('pruncolor1').style = "background-color:#22bb33";

        }
        else if (unitState[pieChartValue[4]] == unitState[2]) {

            document.getElementById('pruncolor1').style = "background-color:darkblue";

        } else if (unitState[pieChartValue[4]] == unitState[3]) {
            document.getElementById('pruncolor1').style = "background-color:orange";

        }
        else {
            document.getElementById('pruncolor1').style = "background-color:gray";
        }
        
    }
    function removeCookie() {
        var res = document.cookie;
        var multiple = res.split(";");
        for (var i = 0; i < multiple.length; i++) {
            var key = multiple[i].split("=");
            document.cookie = key[0] + "=;expires = Thu, 01 Jan 1970 00:00:00 UTC";
        }
        localStorage.clear();
        
    }
    
})
