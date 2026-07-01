package org.example.vmall_home_demo.security;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.example.vmall_home_demo.entity.User;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;

@Component
public class JwtTokenProvider {
    private static final String HMAC_ALGORITHM = "HmacSHA256";
    private static final String SECRET = "vmall-home-demo-jwt-secret-change-before-production-2026";
    private static final long EXPIRES_SECONDS = 7 * 24 * 60 * 60;

    private final ObjectMapper objectMapper = new ObjectMapper();

    public String generateToken(User user) {
        long now = Instant.now().getEpochSecond();

        Map<String, Object> header = new LinkedHashMap<>();
        header.put("alg", "HS256");
        header.put("typ", "JWT");

        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("sub", String.valueOf(user.getId()));
        payload.put("phone", user.getPhone());
        payload.put("username", user.getUsername());
        payload.put("iat", now);
        payload.put("exp", now + EXPIRES_SECONDS);

        String headerPart = encodeJson(header);
        String payloadPart = encodeJson(payload);
        String signingInput = headerPart + "." + payloadPart;
        return signingInput + "." + sign(signingInput);
    }

    public boolean validateToken(String token) {
        try {
            String[] parts = token.split("\\.");
            if (parts.length != 3) {
                return false;
            }

            String signingInput = parts[0] + "." + parts[1];
            if (!constantTimeEquals(sign(signingInput), parts[2])) {
                return false;
            }

            Map<String, Object> payload = parsePayload(token);
            long exp = readLong(payload.get("exp"));
            return exp > Instant.now().getEpochSecond();
        } catch (Exception e) {
            return false;
        }
    }

    public Long getUserId(String token) {
        Map<String, Object> payload = parsePayload(token);
        Object subject = payload.get("sub");
        if (subject == null) {
            throw new IllegalArgumentException("JWT subject is missing");
        }
        return Long.valueOf(subject.toString());
    }

    private Map<String, Object> parsePayload(String token) {
        try {
            String[] parts = token.split("\\.");
            byte[] payloadBytes = Base64.getUrlDecoder().decode(parts[1]);
            return objectMapper.readValue(payloadBytes, new TypeReference<Map<String, Object>>() {});
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid JWT payload", e);
        }
    }

    private String encodeJson(Map<String, Object> data) {
        try {
            byte[] json = objectMapper.writeValueAsBytes(data);
            return Base64.getUrlEncoder().withoutPadding().encodeToString(json);
        } catch (Exception e) {
            throw new IllegalStateException("JWT JSON encode failed", e);
        }
    }

    private String sign(String value) {
        try {
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);
            SecretKeySpec keySpec = new SecretKeySpec(SECRET.getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM);
            mac.init(keySpec);
            return Base64.getUrlEncoder().withoutPadding()
                    .encodeToString(mac.doFinal(value.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception e) {
            throw new IllegalStateException("JWT signature failed", e);
        }
    }

    private long readLong(Object value) {
        if (value instanceof Number number) {
            return number.longValue();
        }
        return Long.parseLong(value.toString());
    }

    private boolean constantTimeEquals(String left, String right) {
        byte[] leftBytes = left.getBytes(StandardCharsets.UTF_8);
        byte[] rightBytes = right.getBytes(StandardCharsets.UTF_8);
        if (leftBytes.length != rightBytes.length) {
            return false;
        }

        int result = 0;
        for (int index = 0; index < leftBytes.length; index++) {
            result |= leftBytes[index] ^ rightBytes[index];
        }
        return result == 0;
    }
}
