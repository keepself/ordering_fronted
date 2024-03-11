<template>
    <div class="container">
        <div class="page-header text-center" style="margin-top: 20px"><h1>로그인</h1></div>
        <!-- submit은 기본적으로 폼 제출시 브라우저가 페이지를 새로고침하므로 해당동작을 막기 위해 prevent사용 -->
        <form @submit.prevent="doLogin">
            <div class="form-group">
                <label for="email"> email : </label>
                <input type="text" v-model="email" class="form-control">
            </div>
            <div class="form-group">
                <label for="password">password :</label>
                <input type="password" v-model="password" class="form-control">
            </div>
            <div class="form-group">
                <p><button class="btn btn-primary mt-3" type="submit"> login </button></p>
            </div>
        </form>
    </div>
</template>

<script>
import axios from 'axios';
// jwt-dec
import {jwtDecode} from 'jwt-decode';
export default {
    data(){
        return{
            eamil: "",
            password: ""
        }
    },
    methods: {
        async doLogin() {
            try {
                console.log(11);
                //2가지 예외 가능성 : 200번대 상태값 token이 비어있는 경우
                const loginData = {email:this.email, password:this.password};
                const response = await axios.post(`${process.env.VUE_APP_API_BASE_URL}/doLogin`, loginData)
                const token = response.data.result.token;
                if(token) {
                    const decoded = jwtDecode(token);
                    localStorage.setItem("token",token);
                    localStorage.setItem("role",decoded.role)
                    // created함수는 reload될때 1번만 실행되는 hook함수
                    // 그런데, router,push를 통한 화면전환은 reload를 실행시키지 않으므로, created함수 호출이 되지않음
                    // this,$router.push("/")
                    window.location.href = "/";
                } else {
                    console.log("200 OK but not token");
                    alert("login faild");
                }
            } catch(error) {
                const error_message = error.response.data.error_message;
                if(error_message) {
                    console.log(error_message)
                } else {
                    console.log(error);
                    alert("Login faild")
                }
            }
        }
    },
        
    

  }
</script>

<style lang="scss" scoped>

</style>