<template>
  <div class="calculator">
    <div class="display">{{ current || "0" }}</div>
    <div @click="clear" class="btn">C</div>
    <div @click="sign" class="btn">+/-</div>
    <div @click="percent" class="btn">%</div>
    <div @click="divide" class="btn operator">/</div>
    <div @click="append('7')" class="btn">7</div>
    <div @click="append('8')" class="btn">8</div>
    <div @click="append('9')" class="btn">9</div>
    <div @click="times" class="btn operator">x</div>
    <div @click="append('4')" class="btn">4</div>
    <div @click="append('5')" class="btn">5</div>
    <div @click="append('6')" class="btn">6</div>
    <div @click="minus" class="btn operator">-</div>
    <div @click="append('1')" class="btn">1</div>
    <div @click="append('2')" class="btn">2</div>
    <div @click="append('3')" class="btn">3</div>
    <div @click="add" class="btn operator">+</div>
    <div @click="append('0')" class="btn zero">0</div>
    <div @click="dot" class="btn">.</div>
    <div @click="equal" class="btn operator">=</div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      previous: null,
      current: "",
      operatorClicked: false,
      calculated: false,
      operator: null,
    };
  },
  methods: {
    clear() {
      this.current = "";
      this.previous = "";
    },
    sign() {
      if (this.current && parseFloat(this.current) !== 0) {
        this.current =
          this.current.charAt(0) === "-"
            ? this.current.slice(1)
            : `-${this.current}`;
      }
    },
    percent() {
      var currentValue = `${this.operator(
        parseFloat(this.previous),
        parseFloat(this.current)
      )}`;
      this.current = `${parseFloat(currentValue) / 100}`;
    },
    append(number) {
      if (this.operatorClicked || this.calculated) {
        this.current = "";
        this.operatorClicked = false;
        this.calculated = false;
      }

      this.current = `${this.current}${number}`;
    },
    dot() {
      if (this.current.indexOf(".") === -1) {
        this.append(".");
      }
    },
    setPrevious() {
      this.previous = this.current;
      this.operatorClicked = true;
    },
    divide() {
      this.operator = (a, b) => a / b;
      this.setPrevious();
    },
    times() {
      this.operator = (a, b) => a * b;
      this.setPrevious();
    },
    minus() {
      this.operator = (a, b) => a - b;
      this.setPrevious();
    },
    add() {
      this.operator = (a, b) => a + b;
      this.setPrevious();
    },
    equal() {
      this.current = `${this.operator(
        parseFloat(this.previous),
        parseFloat(this.current)
      )}`;
      this.previous = null;
      this.calculated = true;
    },
  },
};
</script>

<style scoped>
.calculator {
  width: 300px;
  margin: 0 auto;
  font-size: 40px;
  box-shadow: 6px 6px 20px #1860a9;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: minmax(60px, auto);
}

.calculator > div {
  display: flex;
  justify-content: center;
  align-items: center;
}

.display {
  grid-column: 1 / 5;
  background-color: #1a1a1a;
  color: #fff;
}

.zero {
  grid-column: 1 / 3;
}

.btn {
  background-color: #1f1b1b;
  border: 1px solid #dcdcdc;
  cursor: pointer;
  color: #fff;
}

.btn:hover {
  background-color: #dcdcdc;
}

.btn:active {
  background-color: #d0d0d0;
}

.operator {
  background-color: #f39d00;
  color: #fff;
  border: 1px solid #da8d00;
}

.operator:hover {
  background-color: #da8d00;
}

.operator:active {
  background-color: #d08702;
}

.calculator {
  position: fixed;
  bottom: 0;
  left: 25%;
  width: 50%;
  z-index: 1;
}
</style>
