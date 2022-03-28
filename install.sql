/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE IF NOT EXISTS `wat` (
  `seller_id` varchar(60) NOT NULL COMMENT 'Seller ID',
  `doc` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date Of Creation',
  `stash_id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'Stash ID',
  `price` int(10) NOT NULL COMMENT 'Price',
  `description` varchar(60) NOT NULL COMMENT 'Description of the Package',
  PRIMARY KEY (`stash_id`),
  KEY `seller_id` (`seller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Used for What A Marketplace in order to store the Seller ID, the Date of Creation, the Warehouse ID, the Price and the Description of the Package.';

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
