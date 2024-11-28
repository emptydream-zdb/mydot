<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useForm } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'
import * as z from 'zod'
import { Button } from '@/components/ui/button'
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'
import { Input } from '@/components/ui/input'
import { LuBrain } from 'vue-icons-plus/lu'

const router = useRouter()
const message = ref('')
const isError = ref(false)

const formSchema = toTypedSchema(z.object({
  username: z.string().min(2, {
    message: "用户名至少需要2个字符。",
  }),
  password: z.string().min(6, {
    message: "密码至少需要6个字符。",
  }),
}))

const form = useForm({
  validationSchema: formSchema,
})

const onSubmit = form.handleSubmit(async (values) => {
  try {
    // 这里应该是您的实际登录API调用
    const response = await fetch('/api/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(values),
    })
    
    if (!response.ok) {
      throw new Error('登录失败')
    }
    
    const data = await response.json()
    localStorage.setItem('token', data.token)
    
    message.value = "登录成功，欢迎回来！"
    isError.value = false
    
    router.push('/')
  } catch (error) {
    message.value = "登录失败，请检查您的用户名和密码。"
    isError.value = true
  }
})
</script>

<template>
  <div class="flex flex-col items-center justify-center min-h-screen">
    <div class="mb-8 text-center">
      <LuBrain class="w-16 h-16 mx-auto mb-2 text-primary" />
      <h1 class="text-2xl font-bold text-gray-900">AI辅助评分系统</h1>
    </div>
    <div class="w-full max-w-md">
      <div v-if="message" :class="['mb-4 p-2 rounded', isError ? 'bg-red-100 text-red-700' : 'bg-green-100 text-green-700']">
        {{ message }}
      </div>
      <Form @submit="onSubmit" class="space-y-8">
        <FormField
          v-slot="{ componentField }"
          name="username"
        >
          <FormItem>
            <FormLabel>用户名</FormLabel>
            <FormControl>
              <Input placeholder="请输入用户名" v-bind="componentField" />
            </FormControl>
            <FormMessage />
          </FormItem>
        </FormField>
        <FormField
          v-slot="{ componentField }"
          name="password"
        >
          <FormItem>
            <FormLabel>密码</FormLabel>
            <FormControl>
              <Input type="password" placeholder="请输入密码" v-bind="componentField" />
            </FormControl>
            <FormMessage />
          </FormItem>
        </FormField>
        <Button type="submit" class="w-full">登录</Button>
      </Form>
    </div>
  </div>
</template>
