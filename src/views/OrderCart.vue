<template>
    <div class="d-flex justify-content-between">
        <button class="btn btn-secondary" @click="clearCart">장바구니 비우기</button>
        <button class="btn btn-secondary" @click="placeOrder">주문하기</button>
    </div>       
    <div class="container">
        <div class="page-header" style="margin-top: 20px"><h1>장바구니 목록</h1></div>
        <table class="table">
            <thead>
            <tr>
                <th>제품id</th>
                <th>제품명</th>
                <th>주문수량</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="item in getCartItems" :key="item.itemId">
                <td>{{item.itemId}}</td>
                <td>{{item.name}}</td>
                <td>{{item.count}}</td>
            </tr>
            </tbody>
        
            
        </table>
    </div>
</template>

<script>
import axios from 'axios';
import {mapGetters,mapActions} from 'vuex'

export default {
    computed: {
       ...mapGetters(['getCartItems', 'getTotalQuantitiy'])
   
    },
    methods:{
        ...mapActions(['clearCart']),
    
        // clearCart(){
        //     this.$store.dispatch('clearCart');
        // },
        async placeOrder(){  
            const orderItems = this.getCartItems.map(item =>{
                return {itemId:item.itemId, count: item.count}; }
            )
    
        if(!confirm(`${this.getTotalQuantitiy}개의 상품을 주문하시겠습니까?`)){
                console.log("주문이취소되었습니다")
                return;
        }

        if(this.getTotalQuantitiy < 1){
            alert("장바구니에 물건이 없습니다")
            return;
        }
        const token = localStorage.getItem('token')
        const headers = token ? {Authorization: `Bearer ${token}`} : {}; 
        try{
            await axios.post(`${process.env.VUE_APP_API_BASE_URL}/order/create`, orderItems ,{headers})
            console.log(orderItems);
            alert("주문완료")
            this.$store.commit('clearCart');
            

        }catch(error){
                
                alert("주문실패")
            

            }

        }
    }
}
</script>
