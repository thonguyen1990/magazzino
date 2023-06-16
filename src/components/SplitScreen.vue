<template>
    <div class="split-main-div d-flex">
        
        <div class="split-div">
            <NavBarHomeSplit :key="$route.params.genitore" v-bind:idCategoria="$route.params.genitore" />
            <CardsL2 v-if="$route.params.livello==2"/>
            <Prodotti v-else-if="$route.params.livello==3"/>

            
        </div>
        <div class="split-div second-div">
            <Agenda>
            </Agenda>
        </div>
    </div>
</template>

<script>
    import  Agenda  from "../views/Agenda.vue";
    import NavBarHomeSplit from '../components/NavBarHomeSplit.vue'
    import CardsHome from '../components/CardsHome.vue'
    import Prodotti from '../components/Prodotti.vue'
    import CardsL2 from '../components/CardsL2.vue'
    import ProdottoDettaglio from '../components/ProdottoDettaglio.vue'

    export default 
    {
        components:
        {
            Agenda,
            NavBarHomeSplit,
            CardsHome,
            Prodotti,
            ProdottoDettaglio,
            CardsL2,
        },
        beforeCreate: function () 
        {
            if (!this.$session.exists()) 
            {
                this.$router.replace('/login')
            }

            if(this.$session.get('vetrina')=='1')
            {
                this.$router.push({ name: 'vetrina' });
            }
        },
    }

</script>

<style>
    .split-main-div{
        width: 100%;
    }
    .split-div{
        width: 50%;
    }
    .first-div{
        float: left;
    }
    .second-div{
        float: right;
    }
</style>