<template>
  <div class="bg-green-200 h-screen">
    <div class="w-full bg-indigo-300 py-4 flex items-center justify-center">
      Your Wallet Address :
      <p class="font-medium">{{ token }}</p>
    </div>
    <h1 class="w-full py-4 flex items-center justify-center mt-10 text-3xl">
      Your Verified Certificates are here
    </h1>

    <div v-for="item in items" :key="item.ipfsUrl" class="flex">

      <div class="max-w-sm mx-auto p-8 bg-white rounded-xl shadow-md space-y-2">
        <img class="h-24 mx-auto rounded-full ring-4 ring-green-400" :src="item.ipfsUrl"
          alt="Certificate Verification" />
        <div class="text-center space-y-2">
          <div class="space-y-0.5">
            <p class="text-lg text-black font-semibold">{{ item.name }}</p>
          </div>
          <button @click="openCertificate(item)" class="px-4 py-1 border border-purple-200 rounded-full text-sm text-purple-600 font-semibold">See Full</button>
        </div>
      </div>
    </div>
  </div>
</template>
  
<script>

import getInstituteContract from "../utils/contract";

export default {
  name: "DetailsComponent",
  data() {
    return {
      loading: false,
      token: null,
      certificateImage: null,
      items: [],
    };
  },
  async mounted() {
    this.token = this.getSavedState('token');
    let instituteContract = await getInstituteContract();
    this.items = await instituteContract.ownerOfCertificates(this.token);
  },
  methods: {
    getSavedState(key) {
      const state = window.localStorage.getItem(key);

      if (state) {
        return JSON.parse(state);
      }

      return {
        token: "",
      };
    },

    openCertificate(data) {
      window.open(data.ipfsUrl, "_blank");
    }
  },
};
</script>
  
<style scoped>

</style>
  