import Vue from "vue";
import {
  CustomersService,
} from "@/common/api.service";
import {
  FETCH_CUSTOMER,
  CUSTOMER_RESET_STATE
} from "./actions.type";
import {
  RESET_STATE,
  SET_CUSTOMER,
} from "./mutations.type";

const initialState = {
  customer: {
    customer_id : "",
    age : "",
    app_reg_date : "",
    crn_status : "",
    date_of_birth : "",
    first_name : "",
    gender : "",
    ib_reg_date : "",
    long_lat : "",
    is_bankrupt : "",
    is_in_collection : "",
    is_deceased : ""
  }
};

export const state = { ...initialState };

export const actions = {
  async [FETCH_CUSTOMER](context, customerSlug, prevCustomer) {
    if (prevCustomer !== undefined) {
      return context.commit(SET_CUSTOMER, prevCustomer);
    }
    const { data } = await CustomersService.get(customerSlug);
    context.commit(SET_CUSTOMER, data.customer);
    return data;
  },
  [CUSTOMER_RESET_STATE]({ commit }) {
    commit(RESET_STATE);
  }
};

/* eslint no-param-reassign: ["error", { "props": false }] */
export const mutations = {
  [SET_CUSTOMER](state, customer) {
    state.customer = customer;
  },
  [RESET_STATE]() {
    for (let f in state) {
      Vue.set(state, f, initialState[f]);
    }
  }
};

const getters = {
  customer(state) {
    return state.customer;
  }
};

export default {
  state,
  actions,
  mutations,
  getters
};
