var $loading = $('#loading').hide();
jQuery.ajaxSetup({
    beforeSend:function(){
        jQuery("#loading").show();
    },
    complete:function(){
        jQuery("#loading").hide();
    }
});

$(function () {
    $.getJSON("/api/interactions/daily_use_heatmap", $('#ajax_data').data('ajax'), function (activity) {
        $.each(activity.datasets, function (i, dataset) {

            $('<div class="chart">')
                .appendTo('div#daily_use_heatmap')
                .highcharts({
                    chart: {
                        type: 'heatmap',
                        height: 800
                        //marginLeft: , // Keep all charts left aligned
                        //spacingTop: 20,
                        //spacingBottom: 20
                    },
                    title: {
                        text: dataset.name,
                    },
                    credits: {
                        enabled: false
                    },
                    xAxis: {
                        categories: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
                    },

                    yAxis: {
                        categories: [
                            "1am", "2am", "3am", "4am", "5am", "6am", "7am", "8am ", "9am", "10am", "11am", "Noon",
                            "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm ", "9pm", "10pm", "11pm", "Midnight"],
                        title: null
                    },
                    colorAxis: {
                        min: 0,
                        minColor: '#FFFFFF',
                        maxColor: dataset.color
                    },

                    legend: {
                        align: 'right',
                        layout: 'vertical',
                        margin: 10,
                        verticalAlign: 'top',
                        y: 65,
                        symbolHeight: 650
                    },

                    tooltip: {
                        formatter: function () {
                            return 'On <b>' + this.series.xAxis.categories[this.point.x] + '</b> there were on average <br><b>' +
                                parseFloat(this.point.value).toFixed(2) + '</b> patrons <br> at <b>' + this.series.yAxis.categories[this.point.y] +
                                '</b><br/> at the <b>'+dataset.name+'</b> library.';
                        },
                        valueDecimals: 2
                    },

                    series: [
					//{
                     //   data: dataset.max_data,
					//	name: 'Maximum ',
					//	unit: 'Patrons',
					//	dashStyle: 'longdashdotdot',
					//	color: dataset.color,
                     //   tooltip: {
                     //       valueSuffix: ' ' + dataset.unit
                     //   }
					//},
					{
                        data: dataset.mean_data,
						name: 'Mean',
                        borderWidth: 0,
                        dataLabels: {
                            enabled: false,
                            color: 'black',
                            style: {
                                textShadow: 'none'
                            }
                        }
                    }]
                });
        });
    });
});
