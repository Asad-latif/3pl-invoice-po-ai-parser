# 3PL & Logistics PO/Invoice Parsing Pipeline

An enterprise-ready, fault-tolerant **AUTOMATION workflow** designed for 3PLs, freight brokers, and logistics service providers. This pipeline automatically parses complex multi-page PDF Purchase Orders (POs), Rate Confirmations (Rate Cons), Bills of Lading (BOLs), and Carrier Invoices from inbound emails and creates structured **Draft Orders** in your TMS or ERP.

---

## 🎯 The Problem

Logistics operators and dispatch teams waste dozens of hours daily manually typing line-item data (SKUs, part numbers, quantities, rate items) from messy PDF attachments into their TMS/ERP systems. Manual entry leads to:
- High labor overhead ($40k–$50k/year per data entry clerk)
- Frequent data entry typos causing mis-shipped inventory
- Delayed dispatch readiness and slow invoice processing

---

## 💡 The Solution

This automated pipeline listens for inbound emails, executes multi-tier spam/hygiene filtering, computes SHA-256 binary deduplication, and routes attachments to LLMs. Extracted payloads are validated, normalized, and staged directly into a PostgreSQL database or TMS REST API endpoint.

[Inbound Email]
│
▼
[Stage 1: Hygiene & SHA-256 Hash Deduplication]
│
▼
[Stage 2: File Size (>15MB) & Domain Triage]
│
├──> (Large Files >15MB) ──> [Pending Human Triage DB]
└──> (Standard PDFs/Emails)
│
▼
[JEV Fast Classifier Filter]
│
▼
[AI Concurrency Guard (Batch: 1)]
│
▼
[Model Switcher Node]
├──> Attachments  ──> [LLM Vision]
└──> Email Body   ──> [LLM Text Extraction]
│
▼
[Normalizer & Schema Validator (Markdown Stripping)]
│
▼
[PostgreSQL Staging DB Insert ($1..$N Parameterized)]

## ✨ Key Technical Features

- **Multi-Stage Filtering:** Auto-drops spam, marketing emails, and handles out-of-office auto-replies dynamically.
- **SHA-256 Binary Hash Deduplication:** Prevents duplicate processing and double billing by checking file hashes before triggering LLMs.
- **AI Vision Extraction:** Uses `gemini` for visual scanning of complex, multi-page PDF tables, invoices, and hand-written annotations.
- **SQL Injection & Quote Protection:** All database interactions use parameterized queries (`$1, $2, $3...` with `$5::jsonb` casting) to cleanly handle single quotes without syntax crashes.
- **Markdown Code Fence Stripping:** Automatically strips ` ```json ` blocks prior to JSON parsing to eliminate schema validation exceptions.
- **JEV Microservice Error Fallback:** Automatically degrades gracefully to the primary LLM pipeline if classification endpoints timeout (>3000ms).

---

## 🚀 Architecture & Database Setup

The database schema definition for staging tables is available in [`schema.sql`](./schema.sql).

🔒 Security & Display Notice
​This repository is maintained as a public Proof of Work Architecture Blueprint for technical audit and portfolio review purposes. All credentials, API endpoints, and database connection strings are fully sanitized. Refer to the LICENSE file for usage terms.
