// 认证 API —— 提供登录、注册、验证码发送的网络请求
import { http } from '@kit.NetworkKit';
import { API_BASE_URL } from './ApiConfig';

// 验证码请求体
interface SendCodeRequest {
  phone: string;
}

// 验证码登录请求体
interface LoginByCodeRequest {
  phone: string;
  code: string;
}

// 密码登录请求体
interface LoginByPasswordRequest {
  phone: string;
  password: string;
}

// 注册请求体
interface RegisterRequest {
  username: string;
  phone: string;
  password: string;
  code: string;
}

// 验证码发送结果
export interface SendCodeResult {
  phone: string;
  expiresInSeconds: number;
  message: string;
}

// 用户信息
export interface UserInfo {
  id: number;
  phone: string;
  username: string;
}

// 登录结果，包含 JWT Token 和用户信息
export interface LoginResult {
  token: string;
  user: UserInfo;
}

// 通用 POST 请求封装
async function postJson<T>(path: string, body: SendCodeRequest | LoginByCodeRequest | LoginByPasswordRequest | RegisterRequest): Promise<T> {
  const request = http.createHttp();
  try {
    const response = await request.request(`${API_BASE_URL}${path}`, {
      method: http.RequestMethod.POST,
      connectTimeout: 10000,
      readTimeout: 10000,
      header: {
        'Content-Type': 'application/json'
      },
      extraData: JSON.stringify(body)
    });

    if (response.responseCode < 200 || response.responseCode >= 300) {
      throw new Error(`请求失败: ${response.responseCode}`);
    }

    return JSON.parse(response.result as string) as T;
  } finally {
    request.destroy();
  }
}

// 发送登录验证码
export async function sendLoginCode(phone: string): Promise<SendCodeResult> {
  const requestBody: SendCodeRequest = {
    phone: phone
  };
  return postJson<SendCodeResult>('/auth/send-code', requestBody);
}

// 发送注册验证码
export async function sendRegisterCode(phone: string): Promise<SendCodeResult> {
  const requestBody: SendCodeRequest = {
    phone: phone
  };
  return postJson<SendCodeResult>('/auth/send-register-code', requestBody);
}

// 验证码登录
export async function loginByCode(phone: string, code: string): Promise<LoginResult> {
  const requestBody: LoginByCodeRequest = {
    phone: phone,
    code: code
  };
  return postJson<LoginResult>('/auth/login', requestBody);
}

// 密码登录
export async function loginByPassword(phone: string, password: string): Promise<LoginResult> {
  const requestBody: LoginByPasswordRequest = {
    phone: phone,
    password: password
  };
  return postJson<LoginResult>('/auth/login', requestBody);
}

// 用户注册
export async function registerUser(username: string, phone: string, password: string, code: string): Promise<LoginResult> {
  const requestBody: RegisterRequest = {
    username: username,
    phone: phone,
    password: password,
    code: code
  };
  return postJson<LoginResult>('/auth/register', requestBody);
}
