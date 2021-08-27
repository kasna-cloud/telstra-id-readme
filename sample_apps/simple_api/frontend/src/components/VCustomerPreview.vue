<template>
  <div class="customer-preview">
    <RwvCustomerMeta isPreview :customer="customer" />
    <br>
    <tr>
    <router-link :to="customerLink" class="preview-link">
      <td v-text="customer.customer_id" />
    </router-link>
    <td v-text="customer.first_name" />
    <td v-text="customer.app_reg_date" />
    <td v-text="customer.crn_status" />
    </tr>
  </div>
</template>

<script>
import RwvCustomerMeta from "./CustomerMeta";

export default {
  name: "RwvCustomerPreview",
  components: {
    RwvCustomerMeta
  },
  props: {
    customer: { type: Object, required: true }
  },
  computed: {
    customerLink() {
      return {
        name: "customer",
        params: {
          slug: this.customer.customer_id
        }
      };
    }
  }
};
</script>
