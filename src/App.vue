<template>
  <div id="app" v-on:click="this.onClick">
    <div class="help">
      <p>
        <em>
          Click or tap anywhere on the screen to start. Click again when lights
          go off.
        </em>
      </p>
    </div>

    <div id="lights-container">
      <div id="connector"></div>
      <LightStrip ref="lights" v-for="id in [0, 1, 2, 3, 4]" :key="id" />
    </div>

    <h1 class="time">{{ this.result !== null ? this.result : "" }}</h1>
    <div>Your best: {{ this.format(this.best) }}</div>
  </div>
</template>

<script>
import LightStrip from "./components/LightStrip.vue";

// Possible states
const IDLE = "idle";
const RUNNING = "running";
const WAITING = "waiting";

const SWITCH_INTERVAL = 1000; // ms

export default {
  components: { LightStrip },

  data() {
    return {
      state: IDLE,
      nextLightStrip: 0,
      result: "00.000",
      startTime: null,
      timerId: null,
      best: localStorage.best || 0,
    };
  },

  methods: {
    start() {
      this.nextLightStrip = 0;
      this.result = "00.000";
      this.startTime = null;
      this.clearLights();

      this.turnOnNextLight();
      this.timerId = setInterval(() => this.turnOnNextLight(), SWITCH_INTERVAL);
    },

    turnOnNextLight() {
      // TODO introduce variable time for lights off
      if (this.nextLightStrip == 5) {
        this.clearLights();
        this.startTime = Date.now();
        this.state = WAITING;
        clearInterval(this.timerId);
      } else {
        this.$refs.lights[this.nextLightStrip].switchOn(true);
        this.nextLightStrip++;
      }
    },

    clearLights() {
      this.$refs.lights.forEach((l) => l.switchOn(false));
    },

    onClick() {
      if (this.state == RUNNING) {
        this.state = IDLE;
        this.result = "JUMP START!";
        clearInterval(this.timerId);
      } else if (this.state == IDLE) {
        this.state = RUNNING;
        this.start();
      } else if (this.state == WAITING) {
        this.state = IDLE;
        const timeDiff = Date.now() - this.startTime;
        this.result = this.format(timeDiff);
        this.best = this.best === 0 ? timeDiff : Math.min(this.best, timeDiff);
        localStorage.best = this.best;
      }
    },

    format(ms) {
      // Convert milliseconds to seconds.milliseconds format
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

#lights-container {
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
  .help {
    width: 90%;
    text-align: center;
  }

  /* Copied from display-4 of bootstrap */
  .time {
    font-size: 3.5rem;
    font-weight: 300;
    line-height: 1.2;
  }
}

@media only screen and (min-width: 600px) {
  /* Copied from display-2 of bootstrap */
  .time {
    font-size: 5.5rem;
    font-weight: 300;
    line-height: 1.2;
  }
}
</style>
