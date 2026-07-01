import { http } from '@kit.NetworkKit';

const API_BASE_URL: string = 'http://10.162.106.18:8080/api';

interface SendCodeRequest {
  phone: string;
}

interface LoginByCodeRequest {
  phone: string;
  code: string;
}

interface LoginByPasswordRequest {
  phone: string;
  password: string;
}

interface RegisterRequest {
  username: string;
  phone: string;
  password: string;
  code: string;
}

export interface SendCodeResult {
  phone: string;
  expiresInSeconds: number;
  message: string;
}

export interface UserInfo {
  id: number;
  phone: string;
  username: string;
}

export interface LoginResult {
  token: string;
  user: UserInfo;
}

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
      throw new Error(`Request failed: ${response.responseCode}`);
    }

    return JSON.parse(response.result as string) as T;
  } finally {
    request.destroy();
  }
}

export async function sendLoginCode(phone: string): Promise<SendCodeResult> {
  const requestBody: SendCodeRequest = {
    phone: phone
  };
  return postJson<SendCodeResult>('/auth/send-code', requestBody);
}

export async function sendRegisterCode(phone: string): Promise<SendCodeResult> {
  const requestBody: SendCodeRequest = {
    phone: phone
  };
  return postJson<SendCodeResult>('/auth/send-register-code', requestBody);
}

export async function loginByCode(phone: string, code: string): Promise<LoginResult> {
  const requestBody: LoginByCodeRequest = {
    phone: phone,
    code: code
  };
  return postJson<LoginResult>('/auth/login', requestBody);
}

export async function loginByPassword(phone: string, password: string): Promise<LoginResult> {
  const requestBody: LoginByPasswordRequest = {
    phone: phone,
    password: password
  };
  return postJson<LoginResult>('/auth/login', requestBody);
}

export async function registerUser(username: string, phone: string, password: string, code: string): Promise<LoginResult> {
  const requestBody: RegisterRequest = {
    username: username,
    phone: phone,
    password: password,
    code: code
  };
  return postJson<LoginResult>('/auth/register', requestBody);
}