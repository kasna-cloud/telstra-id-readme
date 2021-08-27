import Vue from "vue";
import Vuex from "vuex";

import home from "./home.module";
import customer from "./customer.module";
import transactions from "./transactions.module";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    home,
    customer,
    transactions
  }
});
