SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `account`
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(32) NOT NULL,
  -- 0.85 Billing 兼容字段：游戏密码和超级密码均保存为 32 位小写 MD5。
  `password` char(32) NOT NULL,
  `question` varchar(64) default NULL,
  `answer` varchar(64) default NULL,
  `email` varchar(64) default NULL,
  `qq` varchar(16) default NULL,
  `tel` varchar(16) default NULL,
  `id_type` enum('IdCard') default 'IdCard',
  `id_card` varchar(32) default NULL,
  `real_name_status` tinyint(3) unsigned NOT NULL default '0',
  `point` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`,`name`),
  UNIQUE KEY `id` USING BTREE (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of account
-- ----------------------------

-- ----------------------------
-- Table structure for `billing_mibao_card`
-- card_data 按列存放 7x7 个两字符单元：11,21...71,12...77。
-- ----------------------------
DROP TABLE IF EXISTS `billing_mibao_card`;
CREATE TABLE `billing_mibao_card` (
  `account_name` varchar(32) COLLATE utf8_general_ci NOT NULL,
  `card_data` char(98) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`account_name`),
  CONSTRAINT `fk_billing_mibao_account` FOREIGN KEY (`account_name`)
    REFERENCES `account` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for `billing_mibao_admin`
-- ----------------------------
DROP TABLE IF EXISTS `billing_mibao_admin`;
CREATE TABLE `billing_mibao_admin` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `password_hash` varchar(255) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `active` tinyint unsigned NOT NULL DEFAULT '1',
  `must_change_password` tinyint unsigned NOT NULL DEFAULT '1',
  `last_login_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_billing_mibao_admin_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for `billing_mibao_audit`
-- ----------------------------
DROP TABLE IF EXISTS `billing_mibao_audit`;
CREATE TABLE `billing_mibao_audit` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `occurred_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `actor_type` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `actor_name` varchar(64) COLLATE utf8_general_ci NOT NULL,
  `event` varchar(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `target_account` varchar(32) COLLATE utf8_general_ci DEFAULT NULL,
  `success` tinyint unsigned NOT NULL,
  `ip_address` varchar(45) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_billing_mibao_audit_time` (`occurred_at`),
  KEY `idx_billing_mibao_audit_target` (`target_account`,`occurred_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for `billing_mibao_throttle`
-- ----------------------------
DROP TABLE IF EXISTS `billing_mibao_throttle`;
CREATE TABLE `billing_mibao_throttle` (
  `principal_type` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `principal_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `ip_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `failures` smallint unsigned NOT NULL DEFAULT '0',
  `window_started_at` datetime NOT NULL,
  `locked_until` datetime DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`principal_type`,`principal_hash`,`ip_hash`),
  KEY `idx_billing_mibao_throttle_updated` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for `pay`
-- ----------------------------
DROP TABLE IF EXISTS `pay`;
CREATE TABLE `pay` (
  `trade_no` varchar(20) NOT NULL,
  `channel` varchar(10) default NULL,
  `server_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `fee` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `create_time` datetime NOT NULL,
  `pay_time` datetime default NULL,
  PRIMARY KEY  (`trade_no`),
  KEY `trade_no` (`trade_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pay
-- ----------------------------

-- ----------------------------
-- Table structure for `server`
-- ----------------------------
DROP TABLE IF EXISTS `server`;
CREATE TABLE `server` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(32) NOT NULL,
  `host` char(60) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of server
-- ----------------------------
INSERT INTO `server` VALUES ('1', '', '127.0.0.1');

-- ----------------------------
-- BillingServer extension schema
-- ----------------------------

SET NAMES utf8;

CREATE TABLE IF NOT EXISTS `billing_schema_version` (
  `version` INT UNSIGNED NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `applied_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `billing_point_order` (
  `order_id` VARCHAR(21) COLLATE utf8_bin NOT NULL,
  `account_name` VARCHAR(50) COLLATE utf8_general_ci NOT NULL,
  `goods_type` INT UNSIGNED DEFAULT NULL,
  `goods_number` INT UNSIGNED DEFAULT NULL,
  `cost_point` INT UNSIGNED DEFAULT NULL,
  `result` TINYINT UNSIGNED DEFAULT NULL,
  `balance_before` INT UNSIGNED DEFAULT NULL,
  `balance_after` INT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `idx_billing_point_account` (`account_name`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `account_prize` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `account` VARCHAR(50) COLLATE utf8_general_ci NOT NULL,
  `world` INT NOT NULL DEFAULT 0,
  `charguid` INT UNSIGNED NOT NULL DEFAULT 0,
  `itemid` INT UNSIGNED NOT NULL DEFAULT 0,
  `itemnum` INT NOT NULL,
  `isget` SMALLINT NOT NULL DEFAULT 0,
  `validtime` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_account_prize` (`account`, `world`, `charguid`, `isget`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `billing_prize_order` (
  `serial` VARCHAR(21) COLLATE utf8_bin NOT NULL,
  `account_name` VARCHAR(50) COLLATE utf8_general_ci NOT NULL,
  `result` TINYINT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`serial`),
  KEY `idx_billing_prize_account` (`account_name`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `billing_cdk_batch` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `batch_no` CHAR(4) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `card_type` TINYINT UNSIGNED NOT NULL,
  `name` VARCHAR(64) NOT NULL DEFAULT '',
  `is_enabled` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_billing_cdk_batch` (`batch_no`, `card_type`),
  KEY `idx_billing_cdk_batch_type` (`card_type`, `is_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `billing_cdk_batch_reward` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `batch_id` BIGINT UNSIGNED NOT NULL,
  `reward_order` INT UNSIGNED NOT NULL DEFAULT 0,
  `reward_string` VARCHAR(20) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `reward_num` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `is_enabled` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_billing_cdk_reward_batch` (`batch_id`, `is_enabled`, `reward_order`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `billing_cdk_card` (
  `card` VARCHAR(20) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `batch_id` BIGINT UNSIGNED NOT NULL,
  `status` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `used_at` TIMESTAMP NULL DEFAULT NULL,
  `used_account` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL,
  `used_charguid` INT UNSIGNED DEFAULT NULL,
  `used_charname` VARCHAR(30) DEFAULT NULL,
  `used_ip` VARCHAR(15) DEFAULT NULL,
  PRIMARY KEY (`card`),
  KEY `idx_billing_cdk_card_batch_status` (`batch_id`, `status`),
  KEY `idx_billing_cdk_card_used_account` (`used_account`, `used_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `billing_cdk_redeem_log` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `card` VARCHAR(20) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `batch_id` BIGINT UNSIGNED NOT NULL,
  `account_name` VARCHAR(50) COLLATE utf8_general_ci NOT NULL,
  `char_guid` INT UNSIGNED NOT NULL DEFAULT 0,
  `char_name` VARCHAR(30) DEFAULT NULL,
  `ip` VARCHAR(15) DEFAULT NULL,
  `result` TINYINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_billing_cdk_log_card` (`card`, `created_at`),
  KEY `idx_billing_cdk_log_account` (`account_name`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `billing_point_order`
  MODIFY COLUMN `order_id` VARCHAR(21) COLLATE utf8_bin NOT NULL,
  MODIFY COLUMN `account_name` VARCHAR(50) COLLATE utf8_general_ci NOT NULL,
  ADD COLUMN IF NOT EXISTS `goods_type` INT UNSIGNED DEFAULT NULL AFTER `account_name`,
  ADD COLUMN IF NOT EXISTS `goods_number` INT UNSIGNED DEFAULT NULL AFTER `goods_type`,
  ADD COLUMN IF NOT EXISTS `cost_point` INT UNSIGNED DEFAULT NULL AFTER `goods_number`,
  ADD COLUMN IF NOT EXISTS `result` TINYINT UNSIGNED DEFAULT NULL AFTER `cost_point`,
  ADD COLUMN IF NOT EXISTS `balance_before` INT UNSIGNED DEFAULT NULL AFTER `result`,
  ADD COLUMN IF NOT EXISTS `balance_after` INT UNSIGNED DEFAULT NULL AFTER `balance_before`,
  ADD COLUMN IF NOT EXISTS `completed_at` TIMESTAMP NULL DEFAULT NULL AFTER `created_at`,
  ADD INDEX IF NOT EXISTS `idx_billing_point_account` (`account_name`, `created_at`);

ALTER TABLE `billing_prize_order`
  MODIFY COLUMN `serial` VARCHAR(21) COLLATE utf8_bin NOT NULL,
  MODIFY COLUMN `account_name` VARCHAR(50) COLLATE utf8_general_ci NOT NULL,
  ADD COLUMN IF NOT EXISTS `result` TINYINT UNSIGNED DEFAULT NULL AFTER `account_name`,
  ADD COLUMN IF NOT EXISTS `completed_at` TIMESTAMP NULL DEFAULT NULL AFTER `created_at`,
  ADD INDEX IF NOT EXISTS `idx_billing_prize_account` (`account_name`, `created_at`);

ALTER TABLE `account_prize`
  MODIFY COLUMN `account` VARCHAR(50) COLLATE utf8_general_ci NOT NULL;

INSERT INTO `billing_schema_version` (`version`, `description`)
VALUES (1, 'Billing 0.85 order and prize schema')
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`);

INSERT INTO `billing_schema_version` (`version`, `description`)
VALUES (3, 'Billing 0.85 one-use NewUserCard CDK schema')
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`);
