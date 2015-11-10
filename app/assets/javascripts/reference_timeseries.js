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


    $.getJSON("/api/interactions/reference_timeseries", $('#ajax_data').data('ajax'), function (activity) {
        $.each(activity.datasets, function (i, dataset) {


            $('<div class="chart">')
                .appendTo('#time-series')
                .highcharts({
                    chart: {
                        marginLeft: 40, // Keep all charts left aligned
                        spacingTop: 20,
                        spacingBottom: 20
                    },
					credits: false,
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
						type: 'datetime',
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
							pointInterval: 24 * 3600 * 1000,
							pointStart: Date.UTC(dataset.start_date[0], dataset.start_date[1], dataset.start_date[2]),
	                        data: dataset.data,
	                        // name: dataset.name,
							name: 'Mean ',
	                        type: 'line',
							unit: 'Questions',
							color: dataset.color,
                            lineWidth: 1,
							marker: {
								enabled: false,
                                states: {
                                    hover: {
                                        enabled: true
                                    }
                                }
							},
	                        tooltip: {
	                            valueSuffix: ' ' + dataset.unit
	                        }
						}
                    ]
                });
        });
    });
});
