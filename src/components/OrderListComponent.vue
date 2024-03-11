<template>
    <div>
        <div class="container">
            <div class="page-header" style="margin-top: 20px"><h1>주문 목록</h1></div>
            <table class="table">
                <thead>
                    <th>#</th>
                    <th>회원이메일</th>
                    <th>주문상태</th>
                    <th v-if="isAdmin === true">ACTION</th>
                </thead>
                <tbody>                
                <template v-for="order in orderList" :key="order.id" >        
                <tr @click="toggleOrder(order.id)" style="cursor: pointer">
                    <td>{{order.id}}</td>
                    <td>{{order.memberEmail}}</td>
                    <td>{{order.orderStatus}}</td>
                    <td><button v-if="order.orderStatus === 'ORDERED'" @click.stop="cancelOrder(order.id)">CANCEL</button></td>
                </tr>
                <tr v-if="visableOrder.has(order.id)">
                    <td colspan="4">
                        <span v-for="orderItem in order.orderResItemDtos" :key="orderItem.id">
                            {{ orderItem.itemName }} {{ orderItem.count }}개
                        </span>
                    </td>
                </tr>
                </template>
                </tbody>
            </table>
        </div>
    </div>

</template>

<script>
import axios from 'axios';
export default {
    props: ['isAdmin', 'apiUrl'],
    data(){
        return{
            orderList: [],
            visableOrder: new Set(),
                    
        }
    },
    async created(){
        try{
        const token = localStorage.getItem('token');
        const headers ={Authorization: `Bearer ${token}`}; 
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}${this.apiUrl}`, {headers});
        this.orderList = response.data;
        
        }catch(error){
                console.log(error)
            }
        },
    methods: {
        toggleOrder(orderId){
            if(this.visableOrder.has(orderId)){
                this.visableOrder.delete(orderId)
            }else{
                this.visableOrder.add(orderId)
            }


        
        },
    
        async cancelOrder(orderId){
           if(confirm("정말 삭제 하시겠습니까")){
           try{ 
             const token = localStorage.getItem('token');
             const headers = token ? {Authorization: `Bearer ${token}`} : {}; 
             await axios.delete(`${process.env.VUE_APP_API_BASE_URL}/order/${orderId}/cancel`, {headers});
             const order = this.orderList.find(order => order.id === orderId)
             order.orderStatus = "CANCELD";
           }catch(error){
             console.log(error)
             alert("주문취소에 실패했습니다.")}
        

            }
        }
    }
}

</script>
