import { createRouter, createWebHistory } from "vue-router";
import LoginView from "@/views/LoginView.vue";
import HomeView from "@/views/HomeView.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: HomeView,
    meta: { requiresAuth: false },
  },
  {
    path: "/info",
    name: "info",
    // route level code-splitting
    // this generates a separate chunk (About.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import("../views/InfoView.vue"),
    meta: { requiresAuth: false },
  },
  {
    path: "/login",
    name: "Login",
    component: LoginView,
    meta: { requiresAuth: false },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem("token");

  if (to.meta.requiresAuth && !isAuthenticated) {
    // 需要认证但未登录，重定向到登录页
    next({ name: "Login" });
  } else if (to.name === "Login" && isAuthenticated) {
    // 已登录用户试图访问登录页，重定向到仪表板
    next({ name: "Dashboard" });
  } else {
    // 其他情况正常导航
    next();
  }
});

export default router;
