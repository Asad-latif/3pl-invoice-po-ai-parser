-- Staging table for extracted orders
CREATE TABLE IF NOT EXISTS logistics_staging (
    id SERIAL PRIMARY KEY,
    message_id VARCHAR(255) UNIQUE NOT NULL,
    sender VARCHAR(255),
    vendor_name VARCHAR(255),
    total_amount NUMERIC(12, 2) DEFAULT 0,
    payload_json JSONB,
    status VARCHAR(50) DEFAULT 'PENDING_HUMAN_REVIEW',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Human approval triage table (>15MB files)
CREATE TABLE IF NOT EXISTS pending_human_approvals (
    id SERIAL PRIMARY KEY,
    message_id VARCHAR(255) NOT NULL,
    sender VARCHAR(255),
  
    subject TEXT,
    file_size_status VARCHAR(50),
    human_instruction_status VARCHAR(50) DEFAULT 'AWAITING_HUMAN_DIRECTION',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Human triage queue for non-actionable emails
CREATE TABLE IF NOT EXISTS human_triage_queue (
    id SERIAL PRIMARY KEY,
    message_id VARCHAR(255) NOT NULL,
    sender VARCHAR(255),
    subject TEXT,
    reason VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
