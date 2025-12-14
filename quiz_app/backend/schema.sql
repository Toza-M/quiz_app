-- MySQL schema for quiz_app backend
-- Create database and users table

CREATE DATABASE IF NOT EXISTS `quiz_app` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `quiz_app`;

CREATE TABLE IF NOT EXISTS `users` (
  `id` VARCHAR(36) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `full_name` VARCHAR(255),
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
