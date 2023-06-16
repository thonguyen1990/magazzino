<template>
    <div class="animated fadeIn">
        <card header-text="Real Chart" class="mb-4">
            <div class="card-body">
                <div class="flot-container">
                    <div id="cpu-load" class="cpu-load"></div>
                </div>
            </div>
        </card>
    </div>
</template>



<script>

export default{
      name: 'cpu-load-chart',
      //props: ["canvasId"],
      data(){
        return{
            canvasId: 'cpu-load'
        }
      },
      //template: "<div :id='canvasId'></div>",
      mounted () {
      	
        var data = [],
            totalPoints = 300;

        function getRandomData() {

            if ( data.length > 0 )
                data = data.slice( 1 );

            // Do a random walk

            while ( data.length < totalPoints ) {

                var prev = data.length > 0 ? data[ data.length - 1 ] : 50,
                    y = prev + Math.random() * 10 - 5;

                if ( y < 0 ) {
                    y = 0;
                } else if ( y > 100 ) {
                    y = 100;
                }

                data.push( y );
            }

            // Zip the generated y values with the x values

            var res = [];
            for ( var i = 0; i < data.length; ++i ) {
                res.push( [ i, data[ i ] ] )
            }

            return res;
        };

        var updateInterval = 30;
        jQuery( "#updateInterval" ).val( updateInterval ).change( function () {
            var v = $( this ).val();
            if ( v && !isNaN( +v ) ) {
                updateInterval = +v;
                if ( updateInterval < 1 ) {
                    updateInterval = 1;
                } else if ( updateInterval > 3000 ) {
                    updateInterval = 3000;
                }
                $( this ).val( "" + updateInterval );
            }
        } )


        var plot = jQuery.plot( "#cpu-load", [ getRandomData() ], {
            series: {
                shadowSize: 0 // Drawing is faster without shadows
            },
            yaxis: {
                min: 0,
                max: 100
            },
            xaxis: {
                show: false
            },
            colors: [ "#007BFF" ],
            grid: {
                color: "transparent",
                hoverable: true,
                borderWidth: 0,
                backgroundColor: 'transparent'
            },
            tooltip: true,
            tooltipOpts: {
                content: "Y: %y",
                defaultTheme: false
            }
        } )

        function update() {
            plot.setData( [ getRandomData() ] );
            plot.draw();
            setTimeout( update, updateInterval );
        }

        update();        


    }
}
</script>