<template>
  <div id="app" v-on:click="this.onClick">
    <div id="container" ref="app">
      <Light ref="lights" v-for="id in [0, 1, 2, 3, 4]" :key="id" />
    </div>
    <div id="connector"></div>
    <div>
      {{ this.result !== null ? this.result : "" }}
    </div>
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
      result: null,
      startTime: null,
    };
  },

  methods: {
    start() {
      if (this.state !== RUNNING) {
        return;
      }

      this.nextLight = 0;
      this.result = null;
      this.startTime = null;
      this.clearLights();

      this.turnOnNextLight();
      const id = setInterval(() => this.turnOnNextLight(id), SWITCH_INTERVAL);
    },

    turnOnNextLight(id) {
      if (this.nextLight == 5) {
        this.clearLights();
        this.startTime = Date.now();
        this.state = WAITING;
        clearInterval(id);
      } else {
        this.$refs.lights[this.nextLight].switchOn(true);
        this.nextLight++;
      }
    },

    clearLights() {
      _.forEach(this.$refs.lights, (l) => l.switchOn(false));
    },

    onClick() {
      console.log("single click");
      if (this.state == RUNNING) {
        return;
      } else if (this.state == IDLE) {
        this.state = RUNNING;
        this.start();
      } else if (this.state == WAITING) {
        this.state = IDLE;
        this.result = `${Date.now() - this.startTime} ms`;
      } else {
        this.state = IDLE;
        this.result = "JUMP START!";
      }
    },
  },
};
</script>

<style scoped>
#app {
  height: 100%;
  width: 100%;
}

#container {
  display: flex;
  flex-direction: row;
}

#connector {
  height: 20px;
  width: 20px;
  background-color: black;
}
</style>
