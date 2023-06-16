<template>
  <div class="track-container">
    <span class="range-value min">{{ minValue }} </span> <span class="range-value max">{{ maxValue }}</span>
    <div class="track" ref="_vpcTrack"></div>
    <div class="track-highlight" ref="trackHighlight"></div>
    <button class="track-btn track1" ref="track1"></button>
    <button class="track-btn track2" ref="track2"></button>
    <h5 class="price-value">Price: {{ minValue }}€ <span><span><b-icon icon="dash-lg" font-scale="0.9" style="margin: 0 0.25rem;"></b-icon></span></span> {{ maxValue }}€</h5>
  </div>
</template>

<script>

export default {
  name: "vue-price-range",
  data() {
    return {
      min: 10,
      max: 2200,
      minValue: 235,
      maxValue: 2130,
      step: 5,
      totalSteps: 0,
      percentPerStep: 1,
      trackWidth: null,
      isDragging: false,
      pos: {
        curTrack: null
      }
    }

  },
  methods: {
    moveTrack(track, ev) {
      let percentInPx = this.getPercentInPx();
      let trackX = Math.round(this.$refs._vpcTrack.getBoundingClientRect().left);
      let clientX = ev.clientX;
      let moveDiff = clientX - trackX;

      let moveInPct = moveDiff / percentInPx;

      if (moveInPct < 1 || moveInPct > 100) return;
      let value = (Math.round(moveInPct / this.percentPerStep) * this.step) + this.min;
      if (track === "track1") {
        if (value >= (this.maxValue - this.step)) return;
        this.minValue = value;
      }

      if (track === "track2") {
        if (value <= (this.minValue + this.step)) return;
        this.maxValue = value;
      }

      let trackRef = this.$refs[track];
      if(trackRef && trackRef.style) {
        trackRef.style.left = moveInPct + "%";
      }
      this.setTrackHightlight()
    },
    mousedown(ev, track) {
      if (this.isDragging) return;
      this.isDragging = true;
      this.pos.curTrack = track;
    },
    touchstart(ev, track) {
      this.mousedown(ev, track)
    },
    mouseup(ev, track) {
      if (!this.isDragging) return;
      this.isDragging = false
    },
    touchend(ev, track) {
      this.mouseup(ev, track)
    },
    mousemove(ev, track) {
      if (!this.isDragging) return;
      this.moveTrack(track, ev)
    },
    touchmove(ev, track) {
      this.mousemove(ev.changedTouches[0], track)
    },
    valueToPercent(value) {
      return ((value - this.min) / this.step) * this.percentPerStep
    },
    setTrackHightlight() {
      this.$refs.trackHighlight.style.left = this.valueToPercent(this.minValue) + "%"
      this.$refs.trackHighlight.style.width = (this.valueToPercent(this.maxValue) - this.valueToPercent(this.minValue)) + "%"
    },
    getPercentInPx() {
      let trackWidth = this.$refs._vpcTrack.offsetWidth;
      let oneStepInPx = trackWidth / this.totalSteps;
      let percentInPx = oneStepInPx / this.percentPerStep;

      return percentInPx;
    },
    setClickMove(ev) {
      let track1Left = this.$refs.track1.getBoundingClientRect().left;
      let track2Left = this.$refs.track2.getBoundingClientRect().left;

      if (ev.clientX < track1Left) {
        this.moveTrack('track1', ev)
      } else if ((ev.clientX - track1Left) < (track2Left - ev.clientX)) {
        this.moveTrack('track', ev)
      } else {
        this.moveTrack('track2', ev)
      }
    },
  },
  mounted() {
    // calc per step value
    this.totalSteps = (this.max - this.min) / this.step;

    // percent the track button to be moved on each step
    this.percentPerStep = 100 / this.totalSteps;

    // set track1 initial
    document.querySelector('.track1').style.left = this.valueToPercent(this.minValue) + "%"
    // track2 initial position
    document.querySelector('.track2').style.left = this.valueToPercent(this.maxValue) + "%"

    // // set initial track highlight
    this.setTrackHightlight()

    var self = this;

    ['mouseup', 'mousemove'].forEach(type => {
      document.body.addEventListener(type, (ev) => {
        if (self.isDragging && self.pos.curTrack) {
          self[type](ev, self.pos.curTrack)
        }
      })
    });

    ['mousedown', 'mouseup', 'mousemove', 'touchstart', 'touchmove', 'touchend'].forEach(type => {
      document.querySelector('.track1').addEventListener(type, (ev) => {
        ev.stopPropagation();
        self[type](ev, 'track1')
      })

      document.querySelector('.track2').addEventListener(type, (ev) => {
        ev.stopPropagation();
        self[type](ev, 'track2')
      })
    })

    // on track click
    // determine direction based on click proximity
    // determine percent to move based on track.clientX - click.clientX
    document.querySelector('.track').addEventListener('click', function (ev) {
      ev.stopPropagation();
      self.setClickMove(ev)
    })

    document.querySelector('.track-highlight').addEventListener('click', function (ev) {
      ev.stopPropagation();
      self.setClickMove(ev)
    })
  }
}
</script>
<style>
.range-value {
  position: absolute;
  bottom: -3rem;
  border: 1px rgb(158,158,158) solid;
  width: 48%;
  text-align: center;
  padding: 0.1rem;
  color: rgb(158,158,158);
}

.range-value.max {
  right: 0;
}

.range-value.min {
  left: 0;
}

.track-container {
  width: 100%;
  position: relative;
  cursor: pointer;
  height: 0.5rem;
  top: 3.5rem;
}

.track,
.track-highlight {
  display: block;
  position: absolute;
  width: 100%;
  height: 0.5rem;
}

.track {
  background-color: #e1e1e1;
}

.track-highlight {
  background-color: rgba(155,155,155,255);
  z-index: 2;
}

.track-btn {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  outline: none;
  cursor: pointer;
  display: block;
  position: absolute;
  z-index: 2;
  width: 1rem;
  height: 1rem;
  top: calc(-50%);
  margin-left: -1rem;
  border: 1px gray solid;
  border-radius: 50%;
  background-color: whitesmoke;
  -ms-touch-action: pan-x;
  touch-action: pan-x;
  transition: box-shadow .3s ease-out, background-color .3s ease, -webkit-transform .3s ease-out;
  transition: transform .3s ease-out, box-shadow .3s ease-out, background-color .3s ease;
  transition: transform .3s ease-out, box-shadow .3s ease-out, background-color .3s ease, -webkit-transform .3s ease-out;
}

.price-value {
  bottom: -5rem;
  position: absolute;
  display: flex;
  justify-content: flex-end;
  width: 100%;
  color: rgb(158,158,158);
  font-family: GFS Didot;
  font-size: 15px;
}
</style>