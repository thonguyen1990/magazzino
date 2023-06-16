<template>
    <div class="container-fluid my-3">
        <div class="row mx-2">
            <div class="col-md-12 item-viewed-title">
                <h6>RECENT JEWELS VIEWED</h6>
            </div>

            <div class="col-md-12 all-item--sections">
            <a href="#" class="previous">&laquo;</a>
                <div class="row">
                    <div class="col-md-3 col-sections" v-for="recentlyViewedItem in recentlyViewedItems">
                        <div class="row mx-0">
                            <div class="col-md-4 main-img-section">
                                <img :src="recentlyViewedItem.image " width="67px" height="75px" alt="">
                            </div>
                            <div class="col-md-8 main-content-right pl-0">
                                <h6>{{ recentlyViewedItem.postazione }}</h6>

                                <div class="content-section-2">
                                    <p>{{ recentlyViewedItem.titolo }}</p>
                                    <span>{{ recentlyViewedItem.descrizione }}</span>
                                    <p>{{ recentlyViewedItem.prezzo }} $</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- <div class="col-md-3 col-sections">
                        <div class="row mx-0">
                            <div class="col-md-4 main-img-section">
                                <img src="https://www.w3schools.com/images/w3schools_green.jpg" width="67px" height="75px" alt="xxxxxxxxx">
                            </div>
                            <div class="col-md-8 main-content-right pl-0">
                                <h6>DX BASSO</h6>

                                <div class="content-section-2">
                                    <p>CL A486</p>
                                    <span>sol. 1,00 G S12 g.S,10 Cert.</span>
                                    <p>10.310,00 $</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sections">
                        <div class="row mx-0">
                            <div class="col-md-4 main-img-section">
                                <img src="https://www.w3schools.com/images/w3schools_green.jpg" width="67px" height="75px" alt="xxxxxxxxx">
                            </div>
                            <div class="col-md-8 main-content-right pl-0">
                                <h6>DX BASSO</h6>

                                <div class="content-section-2">
                                    <p>CL A486</p>
                                    <span>sol. 1,00 G S12 g.S,10 Cert.</span>
                                    <p>10.310,00 $</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sections">
                        <div class="row mx-0">
                            <div class="col-md-4 main-img-section">
                                <img src="https://www.w3schools.com/images/w3schools_green.jpg" width="67px" height="75px" alt="xxxxxxxxx">
                            </div>
                            <div class="col-md-8 main-content-right pl-0">
                                <h6>DX BASSO</h6>

                                <div class="content-section-2">
                                    <p>CL A486</p>
                                    <span>sol. 1,00 G S12 g.S,10 Cert.</span>
                                    <p>10.310,00 $</p>
                                </div>
                            </div>
                        </div>
                    </div> -->
                </div>
                <a href="#" class="next">&raquo;</a>
            </div>
        </div>
    </div>
</template>
<<script>
import axios from "axios";

export default {
    data(){
        return {
            recentlyViewedItems : [
                // {
                //     id:"22",
                //     nome:"VETRINE",
                //     livello:"1",
                //     genitore:"0",
                //     img:"https:\/\/magazzino.daverio1933.it\/API\/img\/thumbsM\/22.jpg",
                //     pos:"1",
                //     descrizioneCat:"",
                //     nProdotti:"120",
                //     genitore_nome:""
                // },
                // {
                //     id:"88",
                //     nome:"TIMELESS",
                //     livello:"1",
                //     genitore:"0",
                //     img:"https:\/\/magazzino.daverio1933.it\/API\/img\/thumbsM\/88.jpg",
                //     pos:"2",
                //     descrizioneCat:"Anelli con solitari, braccialetti tennis, orecchini e pendenti con diamanti punto luce personalizzati secondo il vostro desiderio e realizzati nel nostro laboratorio con modelli sempre nuovi ed attuali.",
                //     nProdotti:"249",
                //     genitore_nome:""
                // },
                // {
                //     id:"21",
                //     nome:"COLLEZIONI",
                //     livello:"1",
                //     genitore:"0",
                //     img:"https:\/\/magazzino.daverio1933.it\/API\/img\/thumbsM\/21.jpg",
                //     pos:"3",
                //     descrizioneCat:"",
                //     nProdotti:"712",
                //     genitore_nome:""
                // },
                // {
                //     id:"92",
                //     nome:"GIOIELLI CLASSICI COLORATI",
                //     livello:"1",
                //     genitore:"0",
                //     img:"https:\/\/magazzino.daverio1933.it\/API\/img\/thumbsM\/92.jpg",
                //     pos:"6",
                //     descrizioneCat:"",
                //     nProdotti:"187",
                //     genitore_nome:""
                // },
                // {
                //     id:"97",
                //     nome:"INVENTARIO",
                //     livello:"1",
                //     genitore:"0",
                //     img:"https:\/\/magazzino.daverio1933.it\/API\/img\/thumbsM\/97.jpg",
                //     pos:"7",
                //     descrizioneCat:"inventario",
                //     nProdotti:"1725",
                //     genitore_nome:""
                // },
                // {
                //     id:"49",
                //     nome:"CASSAFORTE",
                //     livello:"1",
                //     genitore:"0",
                //     img:"https:\/\/magazzino.daverio1933.it\/API\/img\/thumbsM\/49.jpg",
                //     pos:"14",
                //     descrizioneCat:"",
                //     nProdotti:"417",
                //     genitore_nome:""
                // },
                // {
                //     id:"71",
                //     nome:"ANELLI, BRACCIALETTI, CIONDOLI, ORECCHINI",
                //     livello:"1",
                //     genitore:"0",
                //     img:"https:\/\/magazzino.daverio1933.it\/API\/img\/thumbsM\/71.jpg",
                //     pos:"15",
                //     descrizioneCat:"",
                //     nProdotti:"1157",
                //     genitore_nome:""
                // }
            ]
        }
    },
    mounted() {
        var url = this.$store.state.settings.URL_SERVER+"API/RecentView.php?get_user_id="+this.$session.get('ID_USR')
        axios.get(url,{headers: {
          'Content-Type': 'application/json'
        }}).then(response => {
            this.recentlyViewedItems = response.data;

        }).catch(error => {
            console.log({error});
        });
    },
}
</script>

<style>

.item-viewed-title {
	color: #500d00;	
}

.all-item--sections {
	border: 1px solid #500d00;
	border-radius: 2px;
}

.col-sections {
    padding: 10px;
}

.main-img-section {
    border: 2px solid #500d00;
    display: flex;
    align-items: end;
    border-radius: 6px;
}

.main-content-right H6 {
    color: #500d00;
    font-weight: 600;
}

.content-section-2 {
	margin-top: 25px;
}

.content-section-2 p {
	font-size: 13px;
    font-weight: 600;
    margin: 0;
}

.content-section-2 span {
	font-size: 11px;
}

.previous {
	position: absolute;
    left: -10px;
    bottom: 36%;
    color: #111;
    font-size: 18px;
    background: white;
    padding: 4px;
}

.next {
	position: absolute;
    right: -10px;
    bottom: 36%;
    color: #111;
    font-size: 18px;
    background: white;
    padding: 4px;
}
</style>