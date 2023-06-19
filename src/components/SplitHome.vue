<template>
  <!-- SplitNavBar -->
  <div style="overflow: hidden">
    <SplitNavBar></SplitNavBar>
    <div class="row d-flex">
      <div class="split split-left">
        <SplitLeft></SplitLeft>
      </div>
      <div class="split split-right">
        <SplitRight></SplitRight>
      </div>
    </div>
  </div>
</template>
<script>
import axios from "axios";
import SplitNavBar from "../components/split/SplitNavBar.vue";
import SplitLeft from "../components/split/SplitLeft.vue";
import SplitRight from "../components/split/SplitRight.vue";

export default {
  components: {
    SplitNavBar,
    SplitLeft,
    SplitRight,
  },
};
</script>
<style>
.split {
  width: 100%;
}
.split-left {
  width: 50%;
  float: left;
}
.split-right {
  width: 50%;
  float: right;
}
</style>
