-- Conversation persistence for AI assistant
USE vmall;

CREATE TABLE IF NOT EXISTS vmall_conversations (
    id         BIGINT NOT NULL AUTO_INCREMENT,
    user_id    BIGINT DEFAULT NULL COMMENT 'NULL for anonymous conversations',
    title      VARCHAR(200) DEFAULT '新对话',
    status     TINYINT DEFAULT 1 COMMENT '1=active, 0=archived',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS vmall_conversation_messages (
    id              BIGINT NOT NULL AUTO_INCREMENT,
    conversation_id BIGINT NOT NULL,
    role            VARCHAR(20) NOT NULL COMMENT 'user / assistant',
    content         TEXT NOT NULL,
    metadata        TEXT COMMENT 'JSON: recommended products etc.',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_conversation_id (conversation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;