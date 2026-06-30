CREATE TABLE IF NOT EXISTS vmall_users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    phone VARCHAR(20) NOT NULL,
    username VARCHAR(64) NOT NULL,
    password_hash VARCHAR(128) DEFAULT '',
    password_salt VARCHAR(64) DEFAULT '',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '1=active,0=disabled',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login_at DATETIME NULL,
    UNIQUE KEY uk_vmall_users_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS vmall_sms_codes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    phone VARCHAR(20) NOT NULL,
    code VARCHAR(10) NOT NULL,
    used TINYINT NOT NULL DEFAULT 0 COMMENT '0=unused,1=used',
    expires_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_vmall_sms_phone_code (phone, code),
    KEY idx_vmall_sms_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Optional test user for password login.
-- phone: 13800138000, password: 123456
INSERT INTO vmall_users (phone, username, password_salt, password_hash, status)
VALUES (
    '13800138000',
    'test_user',
    'vmall-demo-salt',
    SHA2(CONCAT('vmall-demo-salt', '123456'), 256),
    1
)
ON DUPLICATE KEY UPDATE
    username = VALUES(username),
    password_salt = VALUES(password_salt),
    password_hash = VALUES(password_hash),
    status = VALUES(status);