<template>
  <div id="app" v-on:click="this.onClick">
    <div class="help">
      <p>
        <em
          >Click or tap anywhere on the screen to start. Click again when lights
          go off.</em
        >
      </p>
    </div>
    <div id="container" ref="app">
      <div id="connector"></div>
      <Light ref="lights" v-for="id in [0, 1, 2, 3, 4]" :key="id" />
    </div>
    <h1 class="display-2">
      {{ this.result !== null ? this.result : "" }}
    </h1>
    <div>Best time: {{ this.best }}</div>
  </div>
</template>

<script>
import Light from "./components/Light.vue";
import _ from "lodash";

const IDLE = "idle";
const RUNNING = "running";
const WAITING = "waiting";

const SWITCH_INTERVAL = 1000; // ms

export default {
  components: { Light },

  data() {
    return {
      state: IDLE,
      nextLight: 0,
      result: "00.000",
      startTime: null,
      timerId: null,
    };
  },

  computed: {
    best: function() {
      return this.format(localStorage.best || 0);
    },
  },

  methods: {
    start() {
      if (this.state !== RUNNING) {
        return;
      }

      this.nextLight = 0;
      this.result = "00.000";
      this.startTime = null;
      this.clearLights();

      this.turnOnNextLight();
      this.timerId = setInterval(() => this.turnOnNextLight(), SWITCH_INTERVAL);
    },

    turnOnNextLight() {
      if (this.nextLight == 5) {
        this.clearLights();
        this.startTime = Date.now();
        this.state = WAITING;
        clearInterval(this.timerId);
      } else {
        this.$refs.lights[this.nextLight].switchOn(true);
        this.nextLight++;
      }
    },

    clearLights() {
      _.forEach(this.$refs.lights, (l) => l.switchOn(false));
    },

    onClick() {
      if (this.state == RUNNING) {
        this.state = IDLE;
        this.result = "JUMP START!!";
        clearInterval(this.timerId);
        return;
      } else if (this.state == IDLE) {
        this.state = RUNNING;
        this.start();
      } else if (this.state == WAITING) {
        this.state = IDLE;
        this.result = this.format(Date.now() - this.startTime);
        localStorage.best = Math.min(
          this.best == 0 ? 10 : this.best,
          this.result
        );
      } else {
        this.state = IDLE;
        this.result = "JUMP START!";
      }
    },

    format(ms) {
      const secs = (ms / 1000).toFixed(3);
      return `${(parseInt(secs) < 10 ? "0" : "") + secs}`;
    },
  },
};
</script>

<style scoped>
#app {
  height: 100%;
  width: 100%;
  display: flex;
  flex-flow: column;
  justify-content: center;
  align-items: center;
}

#container {
  position: relative;
  display: flex;
  flex-direction: row;
}

#connector {
  position: absolute;
  background: black;
  height: 3%;
  top: 50%;
  width: 80%;
  left: 10%;
  z-index: -1;
}

@media only screen and (max-width: 600px) {
  .info {
    padding: 10px;
    text-align: center;
  }
}
</style>
