<script setup>
import SiderBarLayout from '@/components/SiderBarLayout.vue';
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion"
import {
  Pagination,
  PaginationEllipsis,
  PaginationFirst,
  PaginationLast,
  PaginationList,
  PaginationListItem,
  PaginationNext,
  PaginationPrev,
} from "@/components/ui/pagination"
import { Button } from "@/components/ui/button"
import { onMounted, ref, computed } from 'vue'

const userInfo = ref({
  name: '张三',
  school: '某某大学',
  subject: '计算机科学',
  avatar: '/path/to/avatar.jpg'
})

const scoreRecords = ref([])
const currentPage = ref(1)
const pageSize = 10
const totalItems = ref(0)
const totalPages = ref(1)

onMounted(async () => {
  await fetchScoreRecords()
})

const fetchScoreRecords = async () => {
  try {
    // 这里调用服务端接口,传入当前页码和每页大小
    // const response = await api.getScoreRecords(currentPage.value, pageSize)
    // scoreRecords.value = response.data
    // totalItems.value = response.totalItems
    // totalPages.value = response.totalPages

    // 模拟数据,实际使用时请删除
    scoreRecords.value = Array(10).fill().map((_, index) => ({
      id: (currentPage.value - 1) * pageSize + index + 1,
      date: new Date().toISOString(),
      score: Math.floor(Math.random() * 100),
      question: `题目${(currentPage.value - 1) * pageSize + index + 1}`,
      studentAnswer: `学生答案${(currentPage.value - 1) * pageSize + index + 1}`,
      scoringCriteria: `评分标准${(currentPage.value - 1) * pageSize + index + 1}`,
      detailedScore: `详细评分${(currentPage.value - 1) * pageSize + index + 1}`
    }))
    totalItems.value = 100 // 假设总共有100条记录
    totalPages.value = Math.ceil(totalItems.value / pageSize)
  } catch (error) {
    console.error('获取评分记录失败', error)
  }
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleString('zh-CN', { 
    year: 'numeric', 
    month: '2-digit', 
    day: '2-digit', 
    hour: '2-digit', 
    minute: '2-digit' 
  })
}

const handlePageChange = (newPage) => {
  currentPage.value = newPage
  fetchScoreRecords()
}


// ... 其他方法保持不变 ...
</script>

<template>
  <SiderBarLayout>
    <div class="p-6 space-y-6">
      <!-- 用户信息卡片 -->
      <Card>
        <CardHeader>
          <CardTitle>个人信息</CardTitle>
        </CardHeader>
        <CardContent class="flex items-center space-x-4">
          <Avatar>
            <AvatarImage :src="userInfo.avatar" />
            <AvatarFallback>{{ userInfo.name[0] }}</AvatarFallback>
          </Avatar>
          <div>
            <p><strong>姓名:</strong> {{ userInfo.name }}</p>
            <p><strong>学校:</strong> {{ userInfo.school }}</p>
            <p><strong>专业:</strong> {{ userInfo.subject }}</p>
          </div>
        </CardContent>
      </Card>

      <!-- 评分记录卡片 -->
      <Card>
        <CardHeader>
          <CardTitle>使用评分记录</CardTitle>
        </CardHeader>
        <CardContent>
          <Accordion type="single" collapsible class="w-full">
            <AccordionItem v-for="record in scoreRecords" :key="record.id" :value="record.id.toString()">
              <AccordionTrigger>
                <div class="flex justify-between w-full">
                  <span>{{ formatDate(record.date) }}</span>
                  <span>得分: {{ record.score }}</span>
                </div>
              </AccordionTrigger>
              <AccordionContent>
                <div class="space-y-2">
                  <p><strong>题目:</strong> {{ record.question }}</p>
                  <p><strong>学生作答:</strong> {{ record.studentAnswer }}</p>
                  <p><strong>评分标准:</strong> {{ record.scoringCriteria }}</p>
                  <p><strong>详细评分:</strong> {{ record.detailedScore }}</p>
                </div>
              </AccordionContent>
            </AccordionItem>
          </Accordion>
          
          <!-- 修改分页控件 -->
          <Pagination 
            v-slot="{ page }" 
            :total="totalItems" 
            :sibling-count="1" 
            show-edges 
            :default-page="currentPage"
            @update:page="handlePageChange"
            class="mt-4"
          >
            <PaginationList v-slot="{ items }" class="flex items-center gap-1">
              <PaginationFirst />
              <PaginationPrev />

              <template v-for="(item, index) in items">
                <PaginationListItem v-if="item.type === 'page'" :key="index" :value="item.value" as-child>
                  <Button class="w-10 h-10 p-0" :variant="item.value === page ? 'default' : 'outline'">
                    {{ item.value }}
                  </Button>
                </PaginationListItem>
                <PaginationEllipsis v-else :key="item.type" :index="index" />
              </template>

              <PaginationNext />
              <PaginationLast />
            </PaginationList>
          </Pagination>
        </CardContent>
      </Card>
    </div>
  </SiderBarLayout>
</template>

<style>

</style>
