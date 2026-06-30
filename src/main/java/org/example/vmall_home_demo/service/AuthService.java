package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.dto.AuthResponse;
import org.example.vmall_home_demo.dto.LoginRequest;
import org.example.vmall_home_demo.dto.RegisterRequest;
import org.example.vmall_home_demo.dto.SendCodeRequest;
import org.example.vmall_home_demo.dto.SendCodeResponse;
import org.example.vmall_home_demo.dto.UserInfo;
import org.example.vmall_home_demo.entity.SmsCode;
import org.example.vmall_home_demo.entity.User;
import org.example.vmall_home_demo.mapper.SmsCodeMapper;
import org.example.vmall_home_demo.mapper.UserMapper;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.HexFormat;
import java.util.UUID;

@Service
public class AuthService {
    private static final int CODE_EXPIRES_SECONDS = 300;
    private static final SecureRandom RANDOM = new SecureRandom();

    private final UserMapper userMapper;
    private final SmsCodeMapper smsCodeMapper;

    public AuthService(UserMapper userMapper, SmsCodeMapper smsCodeMapper) {
        this.userMapper = userMapper;
        this.smsCodeMapper = smsCodeMapper;
    }

    public SendCodeResponse sendCode(SendCodeRequest request) {
        String phone = normalizePhone(request.getPhone());
        User user = userMapper.findByPhone(phone);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "phone not registered");
        }
        if (user.getStatus() != null && user.getStatus() == 0) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "user disabled");
        }

        String code = createAndSaveCode(phone);
        System.out.printf("[VMALL LOGIN CODE] phone=%s code=%s expires=%ds%n", phone, code, CODE_EXPIRES_SECONDS);
        return new SendCodeResponse(phone, CODE_EXPIRES_SECONDS, "login code generated, check backend console");
    }

    public SendCodeResponse sendRegisterCode(SendCodeRequest request) {
        String phone = normalizePhone(request.getPhone());
        User user = userMapper.findByPhone(phone);
        if (user != null) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "phone already registered");
        }

        String code = createAndSaveCode(phone);
        System.out.printf("[VMALL REGISTER CODE] phone=%s code=%s expires=%ds%n", phone, code, CODE_EXPIRES_SECONDS);
        return new SendCodeResponse(phone, CODE_EXPIRES_SECONDS, "register code generated, check backend console");
    }

    public AuthResponse register(RegisterRequest request) {
        String phone = normalizePhone(request.getPhone());
        String username = normalizeUsername(request.getUsername());
        String password = normalizePassword(request.getPassword());
        String code = normalizeCode(request.getCode());

        User exists = userMapper.findByPhone(phone);
        if (exists != null) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "phone already registered");
        }

        SmsCode smsCode = smsCodeMapper.findValidCode(phone, code);
        if (smsCode == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "invalid or expired code");
        }
        smsCodeMapper.markUsed(smsCode.getId());

        User user = new User();
        user.setPhone(phone);
        user.setUsername(username);
        user.setPasswordSalt(randomHex(16));
        user.setPasswordHash(sha256(user.getPasswordSalt() + password));
        userMapper.insert(user);

        return new AuthResponse(buildToken(user), new UserInfo(user.getId(), user.getPhone(), user.getUsername()));
    }

    public AuthResponse login(LoginRequest request) {
        String phone = normalizePhone(request.getPhone());
        User user;

        if (hasText(request.getPassword())) {
            user = loginByPassword(phone, request.getPassword());
        } else if (hasText(request.getCode())) {
            user = loginByCode(phone, request.getCode());
        } else {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "password or code is required");
        }

        if (user.getStatus() != null && user.getStatus() == 0) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "user disabled");
        }

        userMapper.updateLastLoginAt(user.getId());
        return new AuthResponse(buildToken(user), new UserInfo(user.getId(), user.getPhone(), user.getUsername()));
    }

    private User loginByPassword(String phone, String password) {
        User user = userMapper.findByPhone(phone);
        if (user == null || !hasText(user.getPasswordHash()) || !hasText(user.getPasswordSalt())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "invalid phone or password");
        }

        String inputHash = sha256(user.getPasswordSalt() + password);
        if (!inputHash.equalsIgnoreCase(user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "invalid phone or password");
        }
        return user;
    }

    private User loginByCode(String phone, String code) {
        SmsCode smsCode = smsCodeMapper.findValidCode(phone, normalizeCode(code));
        if (smsCode == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "invalid or expired code");
        }
        smsCodeMapper.markUsed(smsCode.getId());

        User user = userMapper.findByPhone(phone);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "phone not registered");
        }
        return user;
    }

    private String createAndSaveCode(String phone) {
        String code = String.format("%06d", RANDOM.nextInt(1_000_000));
        SmsCode smsCode = new SmsCode();
        smsCode.setPhone(phone);
        smsCode.setCode(code);
        smsCode.setExpiresAt(LocalDateTime.now().plusSeconds(CODE_EXPIRES_SECONDS));
        smsCodeMapper.insert(smsCode);
        return code;
    }

    private String normalizeUsername(String username) {
        if (!hasText(username)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "username is required");
        }
        String normalized = username.trim();
        if (normalized.length() < 2 || normalized.length() > 20) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "username length must be 2-20");
        }
        return normalized;
    }

    private String normalizePassword(String password) {
        if (!hasText(password)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "password is required");
        }
        String normalized = password.trim();
        if (normalized.length() < 6 || normalized.length() > 32) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "password length must be 6-32");
        }
        return normalized;
    }

    private String normalizeCode(String code) {
        if (!hasText(code)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "code is required");
        }
        String normalized = code.trim();
        if (!normalized.matches("^\\d{6}$")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid code format");
        }
        return normalized;
    }

    private String normalizePhone(String phone) {
        if (!hasText(phone)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "phone is required");
        }
        String normalized = phone.trim();
        if (!normalized.matches("^1[3-9]\\d{9}$")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid phone format");
        }
        return normalized;
    }

    private String buildToken(User user) {
        return user.getId() + "." + UUID.randomUUID();
    }

    private String randomHex(int bytes) {
        byte[] data = new byte[bytes];
        RANDOM.nextBytes(data);
        return HexFormat.of().formatHex(data);
    }

    private String sha256(String value) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            return HexFormat.of().formatHex(digest.digest(value.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 is not available", e);
        }
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }
}