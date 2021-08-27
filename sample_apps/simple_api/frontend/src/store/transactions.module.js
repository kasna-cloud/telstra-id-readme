import { TransactionsService } from "@/common/api.service";
import { FETCH_TRANSACTIONS } from "./actions.type";
import {
FETCH_TRANSACTIONS_END,
FETCH_TRANSACTIONS_START,
} from "./mutations.type";

const state = {
  transactions: [],
  isTransactionsLoading: true,
  transactionsCount: 0
};

const getters = {
  transactionsCount(state) {
    return state.transactionsCount;
  },
  transactions(state) {
    return state.transactions;
  },
  isTransactionsLoading(state) {
    return state.isTransactionsLoading;
  }
};

const actions = {
  [FETCH_TRANSACTIONS]({ commit }, params) {
    commit(FETCH_TRANSACTIONS_START);
    return TransactionsService.query(params.type, params.filters)
      .then(({ data }) => {
        commit(FETCH_TRANSACTIONS_END, data);
      })
      .catch(error => {
        throw new Error(error);
      });
  }
};

/* eslint no-param-reassign: ["error", { "props": false }] */
const mutations = {
  [FETCH_TRANSACTIONS_START](state) {
    state.isTransactionsLoading = true;
  },
  [FETCH_TRANSACTIONS_END](state, { transactions }) {
    console.log(state)
    state.transactions = transactions;
    state.transactionsCount = transactions.length;
    state.isTransactionsLoading = false;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};