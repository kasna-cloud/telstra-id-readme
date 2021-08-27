import { CustomersService } from "@/common/api.service";
import { FETCH_CUSTOMERS } from "./actions.type";
import {
  FETCH_CUST_START,
  FETCH_CUST_END,
} from "./mutations.type";

const state = {
  customers: [],
  isLoading: true,
  customersCount: 0
};

const getters = {
  customersCount(state) {
    return state.customersCount;
  },
  customers(state) {
    return state.customers;
  },
  isLoading(state) {
    return state.isLoading;
  }
};

const actions = {
  [FETCH_CUSTOMERS]({ commit }, params) {
    commit(FETCH_CUST_START);
    return CustomersService.query(params.type, params.filters)
      .then(({ data }) => {
        commit(FETCH_CUST_END, data);
        console.log(state)
      })
      .catch(error => {
        throw new Error(error);
      });
  }
};

/* eslint no-param-reassign: ["error", { "props": false }] */
const mutations = {
  [FETCH_CUST_START](state) {
    state.isLoading = true;
  },
  [FETCH_CUST_END](state, { customers }) {
    state.customers = customers;
    state.customersCount = customers.length;
    state.isLoading = false;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};
