<template>
    <div class="animated fadeIn">
        <card header-text="Bar Chart" class="mb-3">
            <div class="card-body">
                <div class="flot-container">
                    <div id="flotBar" style="width:100%;height:275px;"></div>
                </div>
            </div>
        </card>
    </div>
</template>



<script>

export default{
      name: 'flot-bar-chart',
      //props: ["canvasId"],
      data(){
        return{
            canvasId: 'flotBar'
        }
      },
      //template: "<div :id='canvasId'></div>",
      mounted () {
      	

        // second chart
        var flotBarOptions = {
            series: {
                bars: {
                    show: true,
                    barWidth: 43200000
                }
            },
            xaxis: {
                mode: "time",
                timeformat: "%m/%d",
                minTickSize: [ 1, "day" ]
            },
            grid: {
                hoverable: true
            },
            legend: {
                show: false
            },
            grid: {
                color: "#fff",
                hoverable: true,
                borderWidth: 0,
                backgroundColor: 'transparent'
            },
            tooltip: {
                show: true,
                content: "x: %x, y: %y"
            }
        };
        var flotBarData = {
            label: "flotBar",
            color: "#007BFF",
            data: [
          [ 1354521600000, 1000 ],
          [ 1355040000000, 2000 ],
          [ 1355223600000, 3000 ],
          [ 1355306400000, 4000 ],
          [ 1355487300000, 5000 ],
          [ 1355571900000, 6000 ]
        ]
        };
        jQuery.plot( $( "#flotBar" ), [ flotBarData ], flotBarOptions );



    }
}
</script>