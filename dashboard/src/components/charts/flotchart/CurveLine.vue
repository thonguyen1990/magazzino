<template>
    <div class="animated fadeIn">
        <card header-text="Curve Line Chart" class="mb-4">
            <div class="card-body">
                <div class="flot-container">
                    <div id="flotCurve" style="width:100%;height:275px;"></div>
                </div>
            </div>
        </card>
    </div>
</template>



<script>

export default{
      name: 'flot-line-curve-chart',
      data(){
        return{
            canvasId: 'flotCurve'
        }
      },
      mounted () {
      	
       var d1 = [ [ 20, 20 ], [ 42, 60 ], [ 54, 20 ], [ 80, 80 ] ];

        //flot options
        var options = {
            legend: {
                show: false
            },
            series: {
                label: "Curved Lines Test",
                curvedLines: {
                    active: true,
                    nrSplinePoints: 20
                }
            },

            grid: {
                color: "#fff",
                hoverable: true,
                borderWidth: 0,
                backgroundColor: 'transparent'
            },
            tooltip: {
                show: true,
                content: "%s | x: %x; y: %y"
            },
            yaxes: [ {
                min: 10,
                max: 90
            }, {
                position: 'right'
            } ]
        };

        //plotting
        jQuery.plot( $( "#flotCurve" ), [
            {
                data: d1,
                lines: {
                    show: true,
                    fill: true,
                    fillColor: "rgba(0,123,255,.15)",
                    lineWidth: 3
                },
                //curve the line  (old pre 1.0.0 plotting function)
                curvedLines: {
                    apply: true,
                    show: true,
                    fill: true,
                    fillColor: "rgba(0,123,255,.15)",

                }
          }, {
                data: d1,
                points: {
                    show: true,
                    fill: true,
                    fillColor: "rgba(0,123,255,.15)",
                }
          }
          ], options );


    }
}
</script>