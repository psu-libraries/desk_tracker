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
//
//
//     /**
//      * In order to synchronize tooltips and crosshairs, override the
//      * built-in events with handlers defined on the parent element.
//      */
//     $('#time-series').bind('mousemove touchmove', function (e) {
//         var chart,
//             point,
//             i;
//
//         for (i = 0; i < Highcharts.charts.length; i++) {
//             chart = Highcharts.charts[i];
//             e = chart.pointer.normalize(e); // Find coordinates within the chart
//             point = chart.series[0].searchPoint(e, true); // Get the hovered point
//
//             if (point) {
//                 point.onMouseOver(); // Show the hover marker
//                 chart.tooltip.refresh(point); // Show the tooltip
//                 chart.xAxis[0].drawCrosshair(e, point); // Show the crosshair
//             }
//         }
//     });
//
//     Highcharts.Pointer.prototype.reset = function () {};
//
//     /**
//      * Synchronize zooming through the setExtremes event handler.
//      */
//     function syncExtremes(e) {
//         var thisChart = this.chart;
//
//         Highcharts.each(Highcharts.charts, function (chart) {
//             if (chart !== thisChart) {
//                 if (chart.xAxis[0].setExtremes) { // It is null while updating
//                     chart.xAxis[0].setExtremes(e.min, e.max);
//                 }
//             }
//         });
//     }

    $.getJSON("/api/interactions/patron_counts_by_year", $('#ajax_data').data('ajax'), function (activity) {
        $.each(activity.datasets, function (i, dataset) {

            // // Add X values
     //        dataset.data = Highcharts.map(dataset.data, function (val, i) {
     //            return [activity.xData[i], val];
     //        });

            $('<div class="chart">')
                .appendTo('div#count_by_year')
                .highcharts({
                    chart: {
                        marginLeft: 40, // Keep all charts left aligned
                        spacingTop: 20,
                        spacingBottom: 20,
                        // zoomType: 'x',
                        // pinchType: null // Disable zoom on touch devices
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
                        // crosshair: true,
 //                        events: {
 //                            setExtremes: syncExtremes
	 //                        }
						 crosshairs: true,
	 categories: activity.years
                    },
                    yAxis: {
                        title: {
                            text: null
                        }
                    },
                    tooltip: {
                        // positioner: function () {
//                             return {
//                                 x: this.chart.chartWidth - this.label.width, // right aligned
//                                 y: +1 // align to title
//                             };
//                         },

						// positioner: function (labelWidth, labelHeight, point) {
// 							var tooltipX, tooltipY;
// 						    if (point.plotX + this.chart.plotLeft < labelWidth && point.plotY + labelHeight > this.chart.plotHeight) {
// 						        tooltipX = this.chart.plotLeft;
// 						        tooltipY = this.chart.plotTop + this.chart.plotHeight - 2 * labelHeight - 10;
// 						    } else {
// 						        tooltipX = this.chart.plotLeft;
// 						        tooltipY = this.chart.plotTop + this.chart.plotHeight - labelHeight;
// 						    }
// 						    return {
// 						        x: tooltipX,
// 						        y: tooltipY
// 						    }
// 						},
						shared: true
                        // borderWidth: 0,
 //                        backgroundColor: 'none',
 //                        pointFormat: '{point.y}',
 //                        headerFormat: '',
 //                        shadow: false,
 //                        style: {
 //                            fontSize: '18px'
 //                        },
 //                        valueDecimals: dataset.valueDecimals
                    },
                    series: [{
                        data: dataset.mean_data,
                        // name: dataset.name,
						// pointInterval: 1,
// 						pointStart: activity.start,
						name: 'Mean',
						unit: 'Patrons',
						color: dataset.color,
                        fillOpacity: 0.3,
                        tooltip: {
                            valueSuffix: ' ' + dataset.unit
                        }
                    },
					{
                        data: dataset.max_data,
                        // name: dataset.name,
						// pointInterval: 1,
// 						pointStart: activity.start,
						name: 'Maximum ',
						unit: 'Patrons',
						color: dataset.color,
                        tooltip: {
                            valueSuffix: ' ' + dataset.unit
                        }
					}]
                });
        });
    });
});
