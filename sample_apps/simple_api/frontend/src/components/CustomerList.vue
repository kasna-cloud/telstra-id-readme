<template>
  <div>
    <div v-if="isLoading" class="customer-preview">Loading customers...</div>
    <div v-else>
      <div v-if="customers.length === 0" class="customer-preview">
        No customers are here... yet.
      </div>
      <RwvCustomerPreview
        v-for="(customer, index) in customers"
        :customer="customer"
        :key="customer.customer_id + index"
      />
      <VPagination :pages="pages" :currentPage.sync="currentPage" />
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import RwvCustomerPreview from "./VCustomerPreview";
import VPagination from "./VPagination";
import { FETCH_CUSTOMERS } from "../store/actions.type";

export default {
  name: "RwvCustomerList",
  components: {
    RwvCustomerPreview,
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
      if (this.isLoading || this.customersCount <= this.itemsPerPage) {
        return [];
      }
      return [
        ...Array(Math.ceil(this.customersCount / this.itemsPerPage)).keys()
      ].map(e => e + 1);
    },
    ...mapGetters(["customersCount", "isLoading", "customers"])
  },
  watch: {
    currentPage(newValue) {
      this.listConfig.filters.offset = (newValue - 1) * this.itemsPerPage;
      this.fetchCustomers();
    }
  },
  mounted() {
    this.fetchCustomers();
  },
  methods: {
    fetchCustomers() {
      this.$store.dispatch(FETCH_CUSTOMERS, this.listConfig); 
    },
    resetPagination() {
      this.listConfig.offset = 0;
      this.currentPage = 1;
    }
  }
};
</script>
