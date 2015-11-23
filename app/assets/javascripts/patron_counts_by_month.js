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
    $.getJSON("/api/interactions/patron_counts_by_month", $('#ajax_data').data('ajax'), function (activity) {
        $.each(activity.datasets, function (i, dataset) {

            $('<div class="chart">')
                .appendTo('div#count_by_month')
                .highcharts({
                    chart: {
                        marginLeft: 40, // Keep all charts left aligned
                        spacingTop: 20,
                        spacingBottom: 20
                    },
                    title: {
                        text: dataset.name,
                        align: 'left',
                        margin: 0,
                        x: 30
                    },
                    credits: {
                        enabled: false
                    },
                    legend: {
                        enabled: true
                    },
                    xAxis: {
						crosshairs: true,
						categories: activity.x_axis
                    },
                    yAxis: {
                        title: {
                            text: null
                        },
						min: 0
                    },
                    tooltip: {
						shared: true
                    },
                    series: [
					{
                        data: dataset.max_data,
						name: 'Maximum ',
						unit: 'Patrons',
						dashStyle: 'longdashdotdot',
						color: dataset.color,
                        tooltip: {
                            valueSuffix: ' ' + dataset.unit
                        }
					},
					{
                        data: dataset.data,
						name: 'Mean',
						unit: 'Patrons',
						color: dataset.color,
                        fillOpacity: 0.3,
                        tooltip: {
                            valueSuffix: ' ' + dataset.unit,
							valueDecimals: 2
                        }
                    }]
                });
        });
    });
});
