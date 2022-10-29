<template>
    <div>
      <div class="w-full bg-indigo-300 py-4 flex items-center justify-center">
        Your Wallet Address :
        <p class="font-medium">{{ token }}</p>
      </div>
  
      <div
        class="flex flex-col items-center justify-center pt-20 h-screen bg-green-100"
      >
        <div class="flex items-center justify-center text-3xl pb-10">
          Submit Your Educational Certificate
        </div>
        <div v-if="loading">
          <vue-loaders-ball-beat color="red" scale="1"></vue-loaders-ball-beat>
          <hr />
          <vue-loaders name="ball-beat" color="red" scale="1"></vue-loaders>
        </div>
        <div class="w-full flex flex-col items-center justify-center">
          <form class="w-full" @submit="checkForm">
            <div
              class="border-gray-300 w-full flex flex-col justify-center items-center mb-2"
            >
              <input
                v-model="form.name"
                type="text"
                id="name"
                name="name"
                placeholder=" Enter your full name"
                class="bg-gray-50 border border-gray-500 text-gray-900 w-1/2 mt-2 py-2"
              />
            </div>
            <div
              class="border-gray-300 w-full flex flex-col justify-center items-center mb-2"
            >
              <input
                v-model="form.roll"
                type="text"
                id="roll"
                name="roll"
                placeholder=" Enter your roll number"
                class="bg-gray-50 border border-gray-500 text-gray-900 w-1/2 mt-2 py-2"
              />
            </div>
  
            <div
              class="border-gray-300 w-full flex flex-col justify-center items-center mb-2"
            >
              <input
                v-model="form.session"
                type="text"
                id="session"
                name="session"
                placeholder=" Enter your session number"
                class="bg-gray-50 border border-gray-500 text-gray-900 w-1/2 mt-2 py-2"
              />
            </div>
  
            <div
              class="border-gray-300 w-full flex flex-col justify-center items-center mb-2"
            >
              <v-select
                v-model="form.program"
                :options="programOption"
                label="name"
                @input="onProgramSelection"
                class="pt-2 py-2 w-1/2"
              ></v-select>
            </div>
  
            <div
              class="border-gray-300 w-full flex flex-col justify-center items-center mb-2"
            >
              <v-select
                v-model="form.university_token"
                :options="organizationOptions"
                label="name"
                @input="onOrgSelection"
                class="pt-2 py-2 w-1/2"
              ></v-select>
            </div>
  
            <div
              class="border-gray-300 w-full flex flex-col justify-center items-center mb-2"
            >
              <input
                type="file"
                id="image"
                name="image"
                title=" "
                class="border-gray-400 bg-gray-200 pt-2 py-2 w-1/2"
                @change="handleUploadImage"
              />
            </div>
  
            <div
              class="border-gray-300 w-full flex flex-col justify-center items-center mb-2"
            >
              <button
                type="sumbit"
                class="border-gray-300 bg-green-300 w-1/2 p-2 rounded-full py-3 px-6 mt-8"
              >
                Submit
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import makeRequest from "../utils/apiRequest";
  import getInstituteContract from "../utils/contract";
  import { WALLET_KEY } from "@/utils/constanst";
  
  export default {
    name: "DetailsComponent",
    data() {
      return {
        loading: false,
        token: null,
        certificateImage: null,
        selectedOrg: null,
        selectedProgram: null,
        programOption: [
          { id: 1, name: "CSE" },
          { id: 2, name: "EEE" },
          { id: 3, name: "BlockChain" },
          { id: 4, name: "APPLIED MATH" },
        ],
        organizationOptions: [
          { id: 1, name: "MIT" },
          { id: 2, name: "STANFORD" },
          { id: 3, name: "HARVARD" },
          { id: 4, name: "OXFORD" },
        ],
      };
    },
    mounted() {
      this.token = this.getSavedState(WALLET_KEY);
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
  
      handleUploadImage(event) {
        const input = event.target.files[0];
        this.form.certificate_image = input;
        if (input && input.size > 2 * 1020 * 1020) {
          let size = input.size / (1020 * 1024);
          window.alert(
            `File size must be less than 2mb. current file size: ${size.toFixed(
              2
            )} mb`
          );
        }
        if (input) {
          const reader = new FileReader();
          reader.onload = (e) => {
            this.certificateImage = e.target.result;
          };
          reader.readAsDataURL(input);
        }
      },
  
      onOrgSelection(data) {
        if (typeof data === "object") {
          this.selectedOrg = data;
        }
      },
  
      onProgramSelection(data) {
        if (typeof data === "object") {
          this.selectedProgram = data;
        }
      },
  
      async checkForm(event) {
        // this.loading = true;
        event.preventDefault();
  
        const filePostUrl = process.env.VUE_APP_FILE_UPLOAD_URL;
  
        var formData = new FormData();
  
        let { name, roll, session } = this.form;
  
        formData.append("certificate", this.form.certificate_image);
        try {
          this.loading = true;
  
          // file uploading
          const result = await makeRequest({
            url: filePostUrl,
            method: "post",
            data: formData,
            headers: {
              "Content-Type": "multipart/form-data",
            },
          });
          this.loading = false;
          console.log(result);
  
          let certificate_url = result.data.filePath;
  
          let instituteContract = await getInstituteContract();
  
          if (this.selectedOrg === null) {
            window.alert("Please select Your Organization");
            return;
          }
  
          if (this.selectedProgram === null) {
            window.alert("Please select study program");
            return;
          }
  
          let transactionInformation =
            await instituteContract.applyForCertificate(
              name,
              roll,
              session,
              this.selectedProgram.id,
              this.selectedOrg.id,
              certificate_url
            );
  
          this.loading = false;
  
          console.log(transactionInformation);
  
          this.$router.push({
            name: "Document-Details",
            info: transactionInformation
          });
  
        } catch (error) {
          console.log("error");
          this.loading = false;
          throw error;
        }
      },
    },
  };
  </script>
  
  <style scoped>
  .image-container img {
    width: 100%;
    height: 100%;
  }
  
  .image-container .upload-btn {
    position: absolute;
    top: 80%;
    left: 50%;
    transform: translate(-50%, -50%);
  }
  </style>
  