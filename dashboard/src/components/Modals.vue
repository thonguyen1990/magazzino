<template>
    <div class="basix-modals row">

        <div class="col-md-12">

          <card header-text="Modals" header-icon="fa fa-align-justify">

                <!-- Button trigger modal -->
                <button type="button" class="btn btn-secondary" @click="showSmallModal()">
                  Small
                </button>
                <button type="button" class="btn btn-secondary" @click="showMediumModal()">
                  Medium
                </button>
                <button type="button" class="btn btn-secondary" @click="showLargeModal()">
                  Large
                </button>
                <button type="button" class="btn btn-secondary" @click="showScrollingModal()">
                  Scrolling
                </button>
                <button type="button" class="btn btn-secondary" @click="showStaticModal()">
                  Static
                </button>

                <!--//Modals-->
                <basix-modal :show.sync="show" ref="smallModal" v-bind:small="true" :cancelClass="'btn btn-secondary'">
                  <div slot="title">Small modal</div>
                  <p>
                    There are three species of zebras: the plains zebra, the mountain zebra and the Grévy's zebra. The plains zebra
                    and the mountain zebra belong to the subgenus Hippotigris, but Grévy's zebra is the sole species of subgenus
                    Dolichohippus. The latter resembles an ass, to which it is closely related, while the former two are more
                    horse-like. All three belong to the genus Equus, along with other living equids.
                  </p>
                </basix-modal>

                <basix-modal :show.sync="show" ref="mediumModal">
                  <div slot="title">Medium modal</div>
                  <p>
                    There are three species of zebras: the plains zebra, the mountain zebra and the Grévy's zebra. The plains zebra
                    and the mountain zebra belong to the subgenus Hippotigris, but Grévy's zebra is the sole species of subgenus
                    Dolichohippus. The latter resembles an ass, to which it is closely related, while the former two are more
                    horse-like. All three belong to the genus Equus, along with other living equids.
                  </p>
                </basix-modal>
                <basix-modal :show.sync="show" v-bind:large="true" ref="largeModal">
                  <div slot="title">Large Modal</div>
                  <p>
                    There are three species of zebras: the plains zebra, the mountain zebra and the Grévy's zebra. The plains zebra
                    and the mountain zebra belong to the subgenus Hippotigris, but Grévy's zebra is the sole species of subgenus
                    Dolichohippus. The latter resembles an ass, to which it is closely related, while the former two are more
                    horse-like. All three belong to the genus Equus, along with other living equids.
                  </p>
                </basix-modal>
                <basix-modal :show.sync="show" v-bind:large="true" ref="scrollingeModal">
                  <div slot="title">Scrolling Long Content Modal</div>
                  <p>
                    Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. <br>

                    Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor.<br>

                    Aenean lacinia bibendum nulla sed consectetur. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla.<br>

                    Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.<br>

                    Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor.<br>

                    Aenean lacinia bibendum nulla sed consectetur. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla.<br>

                    Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.<br>

                    Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor.<br>

                    Aenean lacinia bibendum nulla sed consectetur. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla.<br>

                    Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.<br>

                    Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor.<br>

                    Aenean lacinia bibendum nulla sed consectetur. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla.<br>

                    Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.<br>

                    Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor.<br>

                    Aenean lacinia bibendum nulla sed consectetur. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla.<br>

                    Cras mattis consectetur purus sit amet fermentum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.<br>

                    Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor.<br>

                    Aenean lacinia bibendum nulla sed consectetur. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla.
                  </p>
                </basix-modal>
                <basix-modal :show.sync="show" v-bind:small="true" v-bind:force="true" ref="staticModal" :cancelClass="'btn btn-secondary'" :okText="'CLOSE'">
                  <div slot="title">Static Modal</div>
                  <p>
                    This is a static modal, backdrop click will not close it.
                  </p>
                </basix-modal>

          </card>

        </div>

    </div>
</template>


<script>
  import CardTemplate from './widgets/CardTemplate.vue';
  import BasixModal from './basix-modal/BasixModal.vue';
  export default{
    //name: 'basix-modals',
    data () {
      return {
        show: true
      }
    },
    components:{
      Card : CardTemplate,
      BasixModal
    },
    methods: {
      showSmallModal () {
        this.$refs.smallModal.open()
      },
      showMediumModal () {
        this.$refs.mediumModal.open()
      },
      showLargeModal () {
        this.$refs.largeModal.open()
      },
      showScrollingModal () {
        this.$refs.scrollingeModal.open()
      },
      showStaticModal () {
        this.$refs.staticModal.open()
      }
    }

  }
</script>