<template>
	<div class="animated fadeIn row">	      
        
        <div class="col-md-6">
        	<RealChart/>
        </div>

        <div class="col-md-6">
        	<LineChart/>
        </div>

        <div class="col-md-6">
        	<PieChart/>
        </div>

        <div class="col-md-6">
        	<LineChartTwo/>
        </div>

        <div class="col-md-6">
        	<BarChart/>
        </div>

        <div class="col-md-6">
        	<CurveLine/>
        </div>  


	</div>
</template>

<script>

	import Vue from 'vue';
	import jquery from 'jquery'

	import '../../assets/js/lib/flot-chart/excanvas.min.js';
	import '../../assets/js/lib/flot-chart/jquery.flot.js';
	import '../../assets/js/lib/flot-chart/jquery.flot.pie.js';
	import '../../assets/js/lib/flot-chart/jquery.flot.time.js';
	import '../../assets/js/lib/flot-chart/jquery.flot.stack.js';
	import '../../assets/js/lib/flot-chart/jquery.flot.resize.js';
	import '../../assets/js/lib/flot-chart/jquery.flot.crosshair.js';
	import '../../assets/js/lib/flot-chart/curvedLines.js';
	import '../../assets/js/lib//flot-chart/flot-tooltip/jquery.flot.tooltip.min.js';
	import '../../assets/js/lib/flot-chart/jquery.flot.spline.js';
	import '../../assets/js/lib/flot-chart/jquery.flot.stack.js';




	import RealChart from './flotchart/RealChart.vue'
	import LineChart from './flotchart/LineChart.vue'
	import LineChartTwo from './flotchart/LineChartTwo.vue'
	import PieChart from './flotchart/PieChart.vue'
	import BarChart from './flotchart/BarChart.vue'
	import CurveLine from './flotchart/CurveLine.vue'
	
	
	export default{
		components:{
			RealChart,
			LineChart,
			LineChartTwo,
			PieChart,
			BarChart,
			CurveLine
		}
	}
</script>