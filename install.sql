/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE IF NOT EXISTS `wam` (
  `stash_id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'Stash ID',
  `seller_id` varchar(60) NOT NULL COMMENT 'Seller ID',
  `doc` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date Of Creation',
  `place` varchar(60) NOT NULL COMMENT 'Where is the Warehouse located?',
  `price` int(10) DEFAULT NULL COMMENT 'Price',
  `description` varchar(60) DEFAULT NULL COMMENT 'Description of the Package',
  `onSale` tinyint(2) NOT NULL DEFAULT 0 COMMENT 'Is this Warehouse on Sale?',
  PRIMARY KEY (`stash_id`),
  KEY `seller_id` (`seller_id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COMMENT='Used for What A Marketplace in order to store the Seller ID, the Date of Creation, the Warehouse ID, the Price, the Description of the Package and if the Lot is on Sale.';

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
