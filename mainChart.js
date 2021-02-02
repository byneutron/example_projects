var firstTime = 3000;
var fabProgress = [];
var a, b, c, d;
var cus = $.connection.cusHub;
$(function () {

    // Declare a function on the job hub so the server can invoke it
    cus.client.displayCustomer = function () {
        getData();
    };

    // Start the connection
    $.connection.hub.start();
    getData();

    function getData() {
        $.ajax({
            type: 'GET',
            url: '/Home/Get',
            datatype: 'json',
            success: function (data) {
                getDelete();
                data.listCus.forEach(function (model) {
                    fabProgress.push(model.MacSTime);
                });
                if (firstTime != 0) {
                    getChart();
                    getChart2();
                    firstTime = 0;
                }
                else {
                    getChart();
                    getChart2();
                }
                getProgress();
            }
        });
    }
    function getDelete() {

        fabProgress = [];
       
    }
    function getChart() {
        var colors = ['#dc3545', '#28a745', '#ffc107', '#17a2b8', '#007bff', '#f012be', '#6c757d','#6f42c1'];
        Highcharts.chart('monthChart', {
            chart: {
                type: 'spline',
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
                symbolWidth: 40,
                useHTML: true,
                labelFormatter: function () {
                    return '<div style="width:auto "><span style="font-family: corbel;color:' + this.color + ';font-size:15px">' + this.name + '</b> </span></div> </n>';
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

            xAxis: {
                title: {
                    text: ''
                },
                categories: ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'],
                labels: {
                    style: {
                        color: 'white'
                    }
                }
            },

            tooltip: {
                pointFormat: '{series.name}<br>Adet: {point.y}'
            },

            plotOptions: {
                series: {
                    point: {
                        events: {
                            click: function () {
                                window.location.href = this.series.options.website;
                            }
                        }
                    },
                    cursor: 'pointer',
                   
                }

            },
            series: [
                {
                    name: 'Buzdolabı 1',
                    data: [34.8, 43.0, 51.2, 41.4, 64.9, 72.4, 34.8, 43.0, 51.2, 41.4, 64.9, 72.4],
                    website: 'https://www.nvaccess.org',
                    color: colors[0],
                    animation: {
                        duration: firstTime,
                        // Uses Math.easeOutBounce
                        easing: 'easeOutBounce'
                    },
                }, {
                    name: 'Buzdolabı 2',
                    data: [69.6, 63.7, 63.9, 43.7, 66.0, 61.7],
                    website: 'https://www.freedomscientific.com/Products/Blindness/JAWS',
                    dashStyle: 'ShortDashDot',
                    color: colors[1]
                }, {
                    name: 'Fırın Fabrikası',
                    data: [20.2, 30.7, 36.8, 30.9, 39.6, 47.1],
                    website: 'http://www.apple.com/accessibility/osx/voiceover',
                    dashStyle: 'ShortDot',
                    color: colors[2]
                }, {
                    name: 'Bulaşık Fabrikası',
                    data: [null, null, null, null, 21.4, 30.3],
                    website: 'https://support.microsoft.com/en-us/help/22798/windows-10-complete-guide-to-narrator',
                    dashStyle: 'Dash',
                    color: colors[3]
                }, {
                    name: 'Çamaşır Fabrikası',
                    data: [6.1, 6.8, 5.3, 27.5, 6.0, 5.5],
                    website: 'http://www.zoomtext.com/products/zoomtext-magnifierreader',
                    dashStyle: 'ShortDot',
                    color: colors[4]
                }, {
                    name: 'Kurutma Fabrikası',
                    data: [42.6, 51.5, 54.2, 45.8, 20.2, 15.4],
                    website: 'http://www.disabled-world.com/assistivedevices/computer/screen-readers.php',
                    dashStyle: 'ShortDash',
                    color: colors[5]
                }, {
                    name: 'Klima Fabrikası',
                    data: [6.1, 6.8, 5.3, 27.5, 6.0, 5.5],
                    website: 'http://www.zoomtext.com/products/zoomtext-magnifierreader',
                    dashStyle: 'ShortDot',
                    color: colors[6]
                },{
                    name: 'Termosifon Fabrikası',
                    data: [6.1, 6.8, 5.3, 27.5, 6.0, 5.5],
                    website: 'http://www.zoomtext.com/products/zoomtext-magnifierreader',
                    dashStyle: 'ShortDot',
                    color: colors[7]
                }

            ],

            responsive: {
                rules: [{
                    condition: {
                        maxWidth: 550
                    },
                    chartOptions: {
                        legend: {
                            itemWidth: 150
                           
                        },
                        xAxis: {
                            categories: ['Buzdolabı 1', 'Buzdolabı 2', 'Çamaşır', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık']
                        },
                        yAxis: {
                            title: {
                                enabled: false
                            },
                           
                        }
                    }
                }]
            }
        });

    }
    function getChart2 () {
        Highcharts.setOptions({
            colors: ['#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4']
        });
        Highcharts.chart('pieChart', {
            chart: {
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
                text: '',
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
                        duration: firstTime
                    }
                }
            },
            drilldown: {
                animation: {
                    duration: firstTime
                }
            },
            series: [{
                name: 'Toplam',
                colorByPoint: true,
                data: [{
                    name: 'Çalışan Zaman',
                    y: 100,
                    sliced: true,
                    selected: true
                }, {
                    name: 'Acil Duran Zaman',
                        y: 500,
                }, {
                    name: 'Duran Zaman',
                        y: 200

                }]
            }]
        });

    }
    function getProgress() {

        a = (fabProgress[0] / 20000) * 100;
        b = (fabProgress[1] / 20000) * 100;
        c = (200 / 20000) * 100;
        d = (200 / 20000) * 100;
        document.getElementById('bzd1s').style.width = a + '%';
        document.getElementById('bzd2s').style.width = b + '%';
        document.getElementById('pcfs').style.width = c + '%';
        document.getElementById('bmfs').style.width = d + '%';
        document.getElementById("bzd1").innerHTML = 200;
        document.getElementById("bzd2").innerHTML = 200;
        document.getElementById("pcf").innerHTML = 200;
        document.getElementById("bmf").innerHTML = 200;
    }
})

