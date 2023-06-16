<template>
    <div class="animated fadeIn">
        <card header-text="Pie Chart" class="mb-4">
            <div class="card-body">
                <div class="flot-container">
                    <div id="flot-pie" class="flot-pie-container"></div>
                </div>
            </div>
        </card>
    </div>
</template>



<script>

export default{
      name: 'flot-pie-chart',
      data(){
        return{
            canvasId: 'flot-pie'
        }
      },
      mounted () {
 
        var data = [
            {
                label: "Primary",
                data: 1,
                color: "#8fc9fb"
            },
            {
                label: "Success",
                data: 3,
                color: "#007BFF"
            },
            {
                label: "Danger",
                data: 9,
                color: "#19A9D5"
            },
            {
                label: "Warning",
                data: 20,
                color: "#DC3545"
            }
        ];

        var plotObj = $.plot( $( "#flot-pie" ), data, {
            series: {
                pie: {
                    show: true,
                    radius: 1,
                    label: {
                        show: false,

                    }
                }
            },
            grid: {
                hoverable: true
            },
            tooltip: {
                show: true,
                content: "%p.0%, %s, n=%n", // show percentages, rounding to 2 decimal places
                shifts: {
                    x: 20,
                    y: 0
                },
                defaultTheme: false
            }
        } );
        


    }
}
</script>