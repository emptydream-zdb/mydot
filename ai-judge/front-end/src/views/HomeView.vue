<script setup lang="ts">
import { ref } from 'vue'
import { Button } from '@/components/ui/button'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
import { HiOutlineX, HiCheck } from 'vue-icons-plus/hi'
import SiderBarLayout from '@/components/SiderBarLayout.vue'

const studentAnswer = ref('')
const gradingCriteria = ref('')
const aiResponse = ref('')
const excelFile = ref<File | null>(null)
const resultFileUrl = ref('')

const isGrading = ref(false)
const gradingCompleteMessage = ref('')

const showResult = ref(false)

const submitForGrading = async () => {
  // TODO: 实现单个评分的AI API调用逻辑
  aiResponse.value = '这是AI对学生答案的评分和反馈...'
  showResult.value = true
}

const handleFileChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  if (target.files) {
    excelFile.value = target.files[0]
  }
}

const submitExcelForGrading = async () => {
  if (!excelFile.value) return

  isGrading.value = true
  gradingCompleteMessage.value = ''

  try {
    // TODO: 实现Excel文件上传和批量评分的API调用逻辑
    // 示例:
    // const formData = new FormData()
    // formData.append('file', excelFile.value)
    // const response = await fetch('/api/grade-excel', {
    //   method: 'POST',
    //   body: formData
    // })
    // const blob = await response.blob()
    // resultFileUrl.value = URL.createObjectURL(blob)

    // 临时模拟响应
    await new Promise(resolve => setTimeout(resolve, 2000)) // 模拟2秒的处理时间
    resultFileUrl.value = '#'
    gradingCompleteMessage.value = '评分完成!您可以下载结果文件了。'
  } catch (error) {
    console.error('评分过程中出错:', error)
    gradingCompleteMessage.value = '评分过程中出错,请重试。'
  } finally {
    isGrading.value = false
  }
}

const downloadResult = () => {
  // 实下载逻辑
  // window.open(resultFileUrl.value, '_blank')
  console.log('下载结果文件')
}

const fileInputRef = ref<HTMLInputElement | null>(null)

const triggerFileInput = () => {
  fileInputRef.value?.click()
}

const question = ref('')
</script>

<template>
  <SiderBarLayout>
  <main class="container mx-auto p-4 flex flex-col min-h-screen">
    <h1 class="text-2xl font-bold mb-4 w-full text-center">AI辅助主观题评分系统</h1>
    
    <!-- 单题评分部分 -->
    <section class="mb-8">
      <h2 class="text-xl font-semibold mb-4">单题评分</h2>

      <div class="flex justify-between items-center mb-6">
        <p class="text-gray-600">输入题目、学生作答和评分标准,让AI为您提供评分建议</p>
        <Button @click="submitForGrading">提交评分</Button>
      </div>

      <div class="mb-4">
        <Label for="question" class="block mb-2">题目</Label>
        <Textarea id="question" v-model="question" placeholder="请输入题目..." class="w-full h-15" />
      </div>

      <div class="grid grid-cols-2 gap-4 mb-6">
        <div>
          <Label for="student-answer" class="block mb-2">学生作答</Label>
          <Textarea id="student-answer" v-model="studentAnswer" placeholder="请输入学生的作答内容..." class="w-full h-32" />
        </div>
        <div>
          <Label for="grading-criteria" class="block mb-2">评分标准</Label>
          <Textarea id="grading-criteria" v-model="gradingCriteria" placeholder="请输入评分标准..." class="w-full h-32" />
        </div>
      </div>
    </section>

    <!-- AI评分结果部分 -->
    <section v-if="showResult" class="mb-8">
      <h2 class="text-xl font-semibold mb-4">评分结果</h2>
      <div class="bg-gray-100 p-4 rounded">
        <p>{{ aiResponse }}</p>
      </div>
    </section>

    <!-- 分隔线 -->
    <hr class="my-8 border-t border-gray-300">

    <!-- 批量评分部分 -->
    <section>
      <h2 class="text-xl font-semibold mb-4">批量评分</h2>
      <div class="flex items-center gap-4 mb-4">
        <div class="relative flex items-center">
          <input
            ref="fileInputRef"
            type="file"
            accept=".xlsx,.xls,.all"
            @change="handleFileChange"
            class="hidden"
          />
          <Button @click="triggerFileInput" class="mr-2" size="sm" variant="destructive">选择文件</Button>
          <div class="border border-gray-300 rounded-md px-3 w-72 overflow-hidden h-9 flex items-center">
            <span class="text-gray-500 truncate block">{{ excelFile ? excelFile.name : '未选择文件' }}</span>
          </div>
        </div>
        <Button @click="submitExcelForGrading" :disabled="!excelFile || isGrading">
          {{ isGrading ? '评分中...' : '上传Excel文件进行批量评分' }}
        </Button>
        <div v-if="gradingCompleteMessage" class="flex items-center">
          <HiCheck v-if="resultFileUrl" class="w-5 h-5 text-green-500 mr-2" />
          <HiOutlineX v-else class="w-5 h-5 text-red-500 mr-2" />
          <span :class="resultFileUrl ? 'text-green-700' : 'text-red-700'">
            {{ gradingCompleteMessage }}
          </span>
        </div>
        <Button v-if="resultFileUrl" @click="downloadResult">下载评分结果</Button>
      </div>
    </section>
  </main>
  </SiderBarLayout>
</template>

<style scoped>
</style>
