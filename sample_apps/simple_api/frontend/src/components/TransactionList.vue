<template>
  <div>
    <div v-if="isTransactionsLoading" class="transaction-preview">Loading transactions...</div>
    <div v-else>
      <div v-if="transactions.length === 0" class="transaction-preview">
        No transactions are here... yet.
      </div>
      <RwvTransactionPreview
        v-for="(transaction, index) in transactions"
        :transaction="transaction"
        :key="transaction.txn_id + index"
      />
      <VPagination :pages="pages" :currentPage.sync="currentPage" />
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import RwvTransactionPreview from "./VTransactionPreview";
import VPagination from "./VPagination";
import { FETCH_TRANSACTIONS } from "../store/actions.type";

export default {
  name: "RwvTransactionList",
  components: {
    RwvTransactionPreview,
    VPagination
  },
  props: {
    itemsPerPage: {
      required: false,
      default: 10
    }
  },
  data() {
    return {
      currentPage: 1
    };
  },
  computed: {
    listConfig() {
      const { type } = this;
      const filters = {
        offset: (this.currentPage - 1) * this.itemsPerPage,
        limit: this.itemsPerPage
      };
      return {
        type,
        filters
      };
    },
    pages() {
      if (this.isTransactionsLoading || this.transactionsCount <= this.itemsPerPage) {
        return [];
      }
      return [
        ...Array(Math.ceil(this.transactionsCount / this.itemsPerPage)).keys()
      ].map(e => e + 1);
    },
    ...mapGetters(["transactionsCount", "isTransactionsLoading", "transactions"])
  },
  watch: {
    currentPage(newValue) {
      this.listConfig.filters.offset = (newValue - 1) * this.itemsPerPage;
      this.fetchTransactions();
    }
  },
  mounted() {
    this.fetchTransactions();
  },
  methods: {
    fetchTransactions() {
      this.$store.dispatch(FETCH_TRANSACTIONS, this.listConfig); 
    },
    resetPagination() {
      this.listConfig.offset = 0;
      this.currentPage = 1;
    }
  }
};
</script>
