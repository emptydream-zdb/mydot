<script setup>
  import {ref} from 'vue'
  import { RouterLink} from 'vue-router'
  import { Button } from '@/components/ui/button'
  import { AiOutlineAlignLeft, AiOutlineForm, AiOutlineUser } from 'vue-icons-plus/ai'
  import { cn } from '@/lib/utils'

  const isSidebarOpen = ref(true)

  const toggleSidebar = () => {
    isSidebarOpen.value = !isSidebarOpen.value
  }
</script>

<template>
  <div class="flex h-screen">
    <aside :class="[
      'bg-background border-r transition-all duration-300 ease-in-out',
      isSidebarOpen ? 'w-1/12 min-w-20' : 'w-14'
    ]">
      <Button @click="toggleSidebar" variant="ghost" size="icon" class="w-full h-10 hover:bg-gray-100 hover:text-gray-900 flex justify-start pl-4">
        <AiOutlineAlignLeft />
      </Button>
      <nav class="space-y-1 p-2">
        <RouterLink 
          v-for="(link, index) in [
            { to: '/', label: 'AI评分', icon: AiOutlineForm },
            { to: '/info', label: '用户信息', icon: AiOutlineUser }
          ]" 
          :key="index"
          :to="link.to"
          :class="cn(
            'flex items-center w-full p-2 rounded-md transition-colors hover:bg-gray-100 hover:text-gray-900 h-10',
            $route.path === link.to ? 'bg-gray-200 text-gray-900' : 'text-gray-600'
          )"
        >
          <component :is="link.icon" class="h-5 w-5 flex-shrink-0" />
          <div class="ml-2 overflow-hidden transition-all duration-300" :class="isSidebarOpen ? 'w-24 opacity-100' : 'w-0 opacity-0'">
            <span class="whitespace-nowrap font-mono text-center block w-full">{{ link.label.padEnd(4, '\u3000') }}</span>
          </div>
        </RouterLink>
      </nav>
    </aside>
    <main class="flex-grow p-5">
      <slot></slot>
    </main>
  </div>
</template>


