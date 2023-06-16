<template>
    <!-- SplitLeft.vue -->
    <div class="container">
        <Home :if="selectComponent('Home')"></Home>
    </div>
</template>
<script>
import Home from "../../components/split/Home.vue";
export default {
    components : {
        Home
    },
    data() {
        return {
            selectedComponent : "Home"
        }
    },
    methods:{
        selectComponent(name)
        {
            return this.selectedComponent == name;
        }
    }
}
</script>