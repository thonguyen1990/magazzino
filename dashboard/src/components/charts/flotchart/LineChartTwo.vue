<template>
    <div class="animated fadeIn">
        <card header-text="Line Chart" class="mb-4">
            <div class="card-body">
                <div class="flot-container">
                    <div id="chart1" style="width:100%;height:275px;"></div>
                </div>
            </div>
        </card>
    </div>
</template>



<script>


export default{
      name: 'flot-line-two-chart',
      //props: ["canvasId"],
      data(){
        return{
            canvasId: 'chart1'
        }
      },
      //template: "<div :id='canvasId'></div>",
      mounted () {
      	


        // first chart
        var chart1Options = {
            series: {
                lines: {
                    show: true
                },
                points: {
                    show: true
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
                content: "y: %y"
            }
        };
        var chart1Data = {
            label: "chart1",
            color: "#007BFF",
            data: [
          [ 1354521600000, 6322 ],
          [ 1355040000000, 6360 ],
          [ 1355223600000, 6368 ],
          [ 1355306400000, 6374 ],
          [ 1355487300000, 6388 ],
          [ 1355571900000, 6393 ]
        ]
        };
        jQuery.plot( $( "#chart1" ), [ chart1Data ], chart1Options );
        


    }
}
</script>