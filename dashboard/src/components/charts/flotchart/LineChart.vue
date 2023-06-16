<template>
    <div class="animated fadeIn">
        <card header-text="Line Chart" class="mb-4">
            <div class="card-body">
                <div class="flot-container">
                    <div id="flot-line" class="flot-line"></div>
                </div>
            </div>
        </card>
    </div>
</template>



<script>

export default{
      name: 'flot-line-chart',
      //props: ["canvasId"],
      data(){
        return{
            canvasId: 'flot-line'
        }
      },
      //template: "<div :id='canvasId'></div>",
      mounted () {
      	

        var sin = [],
            cos = [];

        for ( var i = 0; i < 10; i += 0.1 ) {
            sin.push( [ i, Math.sin( i ) ] );
            cos.push( [ i, Math.cos( i ) ] );
        }

        var plot = $.plot( "#flot-line", [
            {
                data: sin,
                label: "sin(x)"
            },
            {
                data: cos,
                label: "cos(x)"
            }
            ], {
            series: {
                lines: {
                    show: true
                },
                points: {
                    show: true
                }
            },
            yaxis: {
                min: -1.2,
                max: 1.2
            },
            colors: [ "#007BFF", "#DC3545" ],
            grid: {
                color: "#fff",
                hoverable: true,
                borderWidth: 0,
                backgroundColor: 'transparent'
            },
            tooltip: true,
            tooltipOpts: {
                content: "'%s' of %x.1 is %y.4",
                shifts: {
                    x: -60,
                    y: 25
                }
            }
        } );
        


    }
}
</script>