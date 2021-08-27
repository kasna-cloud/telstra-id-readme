<template>
  <div class="customer-global"><RwvCustomerList type="all" /></div>
</template>
<script>
import RwvCustomerList from "@/components/CustomerList";

export default {
  name: "rwv-customer-global",
  components: {
    RwvCustomerList
  }
};
</script>
