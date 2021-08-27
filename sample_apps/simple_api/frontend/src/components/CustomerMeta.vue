<template>
  <div class="customer-meta">
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "RwvCustomerMeta",
  props: {
    customer: {
      type: Object,
      required: true
    }
  }
};
</script>
