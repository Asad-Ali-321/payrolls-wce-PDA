-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 17, 2024 at 08:54 PM
-- Server version: 8.0.33
-- PHP Version: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wce_pda`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `allOfficials` ()   begin
select * from users
order by official_name asc;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Auth` (IN `_userName` VARCHAR(50), IN `_password` VARCHAR(50))   BEGIN
    -- Increment attempts
    UPDATE users
    SET attempts = attempts + 1
    WHERE email = _userName
    AND password != _password;

    -- Check if attempts exceed 6 and update status to blocked
    UPDATE users
    SET status = 'blocked'
    WHERE email = _userName
    AND attempts > 6;

    -- Remove attempts
    UPDATE users
    SET attempts = 0
    WHERE email = _userName
    AND password = _password;

    -- Select user with matching email, password, and active status
    SELECT * FROM users
    WHERE email = _userName
    AND password = _password;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDesignationWiseStaff` ()   begin
select designation, count(official_id) as count from officials group by designation
order by count(official_id) desc;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDirectorateWiseStaff` ()   begin
select directorate, count(official_id) as count from officials group by directorate
order by count(official_id) desc;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployeePayroll` (IN `_file_no` VARCHAR(25), IN `_cnic` VARCHAR(15), IN `_month` VARCHAR(25))   begin
select *,
(CASE when monthly_pay_rolls.official_id is null then officials.official_id else officials.official_id end) as official_id,
(CASE when bank_details.official_id is null then officials.official_id else officials.official_id end) as official_id,
(CASE when monthly_pay_rolls.monthly_pay is null then officials.monthly_pay else monthly_pay_rolls.monthly_pay end) as monthly_pay,
(select max(extensions_validity.validity_to)  
 from extensions_validity where official_id=officials.official_id) as valid_upto,
ROUND(CASE
            WHEN monthly_pay_rolls.income_tax IS NOT NULL THEN monthly_pay_rolls.income_tax
            ELSE 
                CASE 
                    WHEN officials.income_tax_applied = 1 THEN officials.monthly_pay * 0.013
                    ELSE 0
                END 
        END) AS income_tax
from officials
left join monthly_pay_rolls
on officials.official_id=monthly_pay_rolls.official_id

left join bank_details
on officials.official_id=bank_details.official_id

where 
(monthly_pay_rolls.month IS NULL  OR monthly_pay_rolls.month = _month)
and (officials.file_no=_file_no OR officials.cnic=_cnic);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMonthlyPayWiseStaff` ()   begin
select monthly_pay, count(official_id) as count from officials group by monthly_pay
order by count(official_id) desc;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOfficials` ()   begin
select officials.*, extensions_validity.validity_to as valid_upto,
bank_details.bank_name,
bank_details.branch_name,
bank_details.branch_code,
bank_details.account_number
from officials
left join extensions_validity
on extensions_validity.official_id=officials.official_id

left join bank_details
on bank_details.official_id=officials.official_id
order by official_name asc;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPayRolls` (IN `_month` VARCHAR(50))   begin
select *,
(CASE when monthly_pay_rolls.official_id is null then officials.official_id else officials.official_id end) as official_id,
(CASE when bank_details.official_id is null then officials.official_id else officials.official_id end) as official_id,
(CASE when monthly_pay_rolls.monthly_pay is null then officials.monthly_pay else monthly_pay_rolls.monthly_pay end) as monthly_pay,
(select max(extensions_validity.validity_to)  
 from extensions_validity where official_id=officials.official_id) as valid_upto,
ROUND(CASE
            WHEN monthly_pay_rolls.income_tax IS NOT NULL THEN monthly_pay_rolls.income_tax
            ELSE 
                CASE 
                    WHEN officials.income_tax_applied = 1 THEN officials.monthly_pay * 0.013
                    ELSE 0
                END 
        END) AS income_tax
from officials
left join monthly_pay_rolls
on officials.official_id=monthly_pay_rolls.official_id

left join bank_details
on officials.official_id=bank_details.official_id

where monthly_pay_rolls.month = _month;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUsers` ()   begin
select * from users order by user_name;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bank_details`
--

CREATE TABLE `bank_details` (
  `bank_detail_id` int UNSIGNED NOT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  `branch_code` varchar(255) DEFAULT NULL,
  `account_number` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `official_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bank_details`
--

INSERT INTO `bank_details` (`bank_detail_id`, `bank_name`, `branch_name`, `branch_code`, `account_number`, `created_at`, `official_id`) VALUES
(1, 'Allied Bank Limited', '', '865', '10069562080013', '2024-03-17 19:03:30', 342),
(2, 'Allied Bank Limited', '', '865', '10079097920016', '2024-03-17 19:03:30', 330),
(3, 'Allied Bank Limited', '', '865', '10076365610014', '2024-03-17 19:03:30', 340),
(4, 'Allied Bank Limited', '', '865', '10065947150010', '2024-03-17 19:03:30', 31),
(5, 'Allied Bank Limited', '', '59', '10083001560014', '2024-03-17 19:03:30', 99),
(6, 'Allied Bank Limited', '', '865', '10088155860010', '2024-03-17 19:03:30', 203),
(7, 'Allied Bank Limited', '', '865', '10082881210012', '2024-03-17 19:03:30', 274),
(8, 'Allied Bank Limited', '', '308', '10106470090015', '2024-03-17 19:03:30', 314),
(9, 'Allied Bank Limited', '', '308', '10106468360014', '2024-03-17 19:03:30', 25),
(10, 'Allied Bank Limited', '', '320', '10108747610013', '2024-03-17 19:03:30', 325),
(11, 'Allied Bank Limited', '', '865', '10070549430017', '2024-03-17 19:03:30', 157),
(12, 'Allied Bank Limited', '', '865', '10086745130018', '2024-03-17 19:03:30', 208),
(13, 'Allied Bank Limited', '', '865', '59837040010', '2024-03-17 19:03:30', 48),
(14, 'Allied Bank Limited', '', '140865', '10049603060010', '2024-03-17 19:03:30', 75),
(15, 'Allied Bank Limited', '', '5165', '20092083480016', '2024-03-17 19:03:30', 153),
(16, 'Allied Bank Limited', '', '1181', '10050374300018', '2024-03-17 19:03:30', 120),
(17, 'Allied Bank Limited', '', '865', '10051690330017', '2024-03-17 19:03:30', 51),
(18, 'Allied Bank Limited', '', '865', '60128850010', '2024-03-17 19:03:30', 184),
(19, 'Allied Bank Limited', '', '865', '10070357450014', '2024-03-17 19:03:30', 68),
(20, 'Allied Bank Limited', '', '865', '10054803370014', '2024-03-17 19:03:30', 321),
(21, 'Allied Bank Limited', '', '321', '10051077120018', '2024-03-17 19:03:30', 222),
(22, 'Allied Bank Limited', '', '865', '1005217680019', '2024-03-17 19:03:30', 118),
(23, 'Allied Bank Limited', '', '865', '10053770700011', '2024-03-17 19:03:30', 190),
(24, 'Allied Bank Limited', '', '58', '10086337210013', '2024-03-17 19:03:30', 80),
(25, 'Allied Bank Limited', '', '304', '10081009540015', '2024-03-17 19:03:30', 228),
(26, 'Allied Bank Limited', '', '5177', '20023743630019', '2024-03-17 19:03:30', 57),
(27, 'Allied Bank Limited', '', '5165', '20121046090010', '2024-03-17 19:03:30', 104),
(28, 'Allied Bank Limited', '', '316', '10087918340015', '2024-03-17 19:03:30', 108),
(29, 'Allied Bank Limited', '', '5165', '20092334840014', '2024-03-17 19:03:30', 113),
(30, 'Allied Bank Limited', '', '307', '10057785150016', '2024-03-17 19:03:30', 278),
(31, 'Allied Bank Limited', '', '865', '10057248850016', '2024-03-17 19:03:30', 282),
(32, 'Allied Bank Limited', '', '865', '10052567050018', '2024-03-17 19:03:30', 125),
(33, 'Allied Bank Limited', '', '865', '10044188670015', '2024-03-17 19:03:30', 84),
(34, 'Allied Bank Limited', '', '865', '10100053270018', '2024-03-17 19:03:30', 213),
(35, 'Allied Bank Limited', '', '865', '10092311280014', '2024-03-17 19:03:30', 329),
(36, 'Allied Bank Limited', '', '865', '10060765990018', '2024-03-17 19:03:30', 324),
(37, 'Allied Bank Limited', '', '865', '10065227390016', '2024-03-17 19:03:30', 63),
(38, 'Allied Bank Limited', '', '865', '10065309880013', '2024-03-17 19:03:30', 15),
(39, 'Allied Bank Limited', '', '5152', '20060110690016', '2024-03-17 19:03:30', 220),
(40, 'Allied Bank Limited', '', '865', '10071362240019', '2024-03-17 19:03:30', 236),
(41, 'Allied Bank Limited', '', '59', '10059796720015', '2024-03-17 19:03:30', 245),
(42, 'Allied Bank Limited', '', '865', '10050117140013', '2024-03-17 19:03:30', 328),
(43, 'Allied Bank Limited', '', '865', '10074414460011', '2024-03-17 19:03:30', 47),
(44, 'Allied Bank Limited', '', '865', '10057552930011', '2024-03-17 19:03:30', 269),
(45, 'Allied Bank Limited', '', '865', '10108205800018', '2024-03-17 19:03:30', 306),
(46, 'Allied Bank Limited', '', '865', '10065758460010', '2024-03-17 19:03:30', 4),
(47, 'Allied Bank Limited', '', '865', '10049610000010', '2024-03-17 19:03:30', 181),
(48, 'Allied Bank Limited', '', '865', '10091213630015', '2024-03-17 19:03:30', 315),
(49, 'Allied Bank Limited', '', '864', '10067586020016', '2024-03-17 19:03:30', 200),
(50, 'Allied Bank Limited', '', '864', '10067409740011', '2024-03-17 19:03:30', 295),
(51, 'Allied Bank Limited', '', '865', '10069310230013', '2024-03-17 19:03:30', 281),
(52, 'Allied Bank Limited', '', '865', '10069329140019', '2024-03-17 19:03:30', 284),
(53, 'Allied Bank Limited', '', '865', '10069316310015', '2024-03-17 19:03:30', 241),
(54, 'Allied Bank Limited', '', '865', '10100394940017', '2024-03-17 19:03:30', 102),
(55, 'Allied Bank Limited', '', '865', '10053734900012', '2024-03-17 19:03:30', 333),
(56, 'Allied Bank Limited', '', '865', '10080254880014', '2024-03-17 19:03:30', 58),
(57, 'Allied Bank Limited', '', '0', '10087028360011', '2024-03-17 19:03:30', 56),
(58, 'Allied Bank Limited', '', '865', '10101501390012', '2024-03-17 19:03:30', 257),
(59, 'Allied Bank Limited', '', '0', '10046620050012', '2024-03-17 19:03:30', 33),
(60, 'Allied Bank Limited', '', '865', '10055549690014', '2024-03-17 19:03:30', 149),
(61, 'Allied Bank Limited', '', '865', '10061320440017', '2024-03-17 19:03:30', 304),
(62, 'Allied Bank Limited', '', '0', '0', '2024-03-17 19:03:30', 151),
(63, 'Allied Bank Limited', '', '864', '100599852770010', '2024-03-17 19:03:30', 250),
(64, 'Allied Bank Limited', '', '865', '10069449750010', '2024-03-17 19:03:30', 160),
(65, 'Allied Bank Limited', '', '865', '10069319360014', '2024-03-17 19:03:30', 197),
(66, 'Allied Bank Limited', '', '865', '10060734150010', '2024-03-17 19:03:30', 283),
(67, 'Allied Bank Limited', '', '865', '10069239740013', '2024-03-17 19:03:30', 144),
(68, 'Allied Bank Limited', '', '865', '10070061100011', '2024-03-17 19:03:30', 27),
(69, 'Allied Bank Limited', '', '865', '10069182710015', '2024-03-17 19:03:30', 285),
(70, 'Allied Bank Limited', '', '865', '10069197410018', '2024-03-17 19:03:30', 187),
(71, 'Allied Bank Limited', '', '865', '10069178940017', '2024-03-17 19:03:30', 224),
(72, 'Allied Bank Limited', '', '865', '10069565810015', '2024-03-17 19:03:30', 240),
(73, 'Allied Bank Limited', '', '865', '10069229710018', '2024-03-17 19:03:30', 150),
(74, 'Allied Bank Limited', '', '865', '10070858650014', '2024-03-17 19:03:30', 59),
(75, 'Allied Bank Limited', '', '865', '10070772770014', '2024-03-17 19:03:30', 292),
(76, 'Allied Bank Limited', '', '865', '10058942380016', '2024-03-17 19:03:30', 298),
(77, 'Allied Bank Limited', '', '865', '10038131510014', '2024-03-17 19:03:30', 140),
(78, 'Allied Bank Limited', '', '865', '10058481001', '2024-03-17 19:03:30', 300),
(79, 'Allied Bank Limited', '', '865', '10070519030011', '2024-03-17 19:03:30', 50),
(80, 'Allied Bank Limited', '', '865', '10061263050011', '2024-03-17 19:03:30', 154),
(81, 'Allied Bank Limited', '', '865', '0', '2024-03-17 19:03:30', 186),
(82, 'Allied Bank Limited', '', '865', '10069944840011', '2024-03-17 19:03:30', 249),
(83, 'Allied Bank Limited', '', '865', '10069944950013', '2024-03-17 19:03:30', 138),
(84, 'Allied Bank Limited', '', '865', '10069968140017', '2024-03-17 19:03:30', 341),
(85, 'Allied Bank Limited', '', '865', '10070280290018', '2024-03-17 19:03:30', 18),
(86, 'Allied Bank Limited', '', '100', '10049907520015', '2024-03-17 19:03:30', 252),
(87, 'Allied Bank Limited', '', '865', '10059565960018', '2024-03-17 19:03:30', 134),
(88, 'Allied Bank Limited', '', '865', '10053189200017', '2024-03-17 19:03:30', 11),
(89, 'Allied Bank Limited', '', '865', '10066616750011', '2024-03-17 19:03:30', 210),
(90, 'Allied Bank Limited', '', '865', '10077151430014', '2024-03-17 19:03:30', 247),
(91, 'Allied Bank Limited', '', '865', '10069380030015', '2024-03-17 19:03:30', 312),
(92, 'Allied Bank Limited', '', '865', '10076848100019', '2024-03-17 19:03:30', 172),
(93, 'Allied Bank Limited', '', '865', '10076956310012', '2024-03-17 19:03:30', 243),
(94, 'Allied Bank Limited', '', '865', '10076607710017', '2024-03-17 19:03:30', 239),
(95, 'Allied Bank Limited', '', '865', '10077240910017', '2024-03-17 19:03:30', 132),
(96, 'Allied Bank Limited', '', '865', '10036621290020', '2024-03-17 19:03:30', 326),
(97, 'Allied Bank Limited', '', '865', '10024056710019', '2024-03-17 19:03:30', 171),
(98, 'Allied Bank Limited', '', '865', '20077073480015', '2024-03-17 19:03:30', 152),
(99, 'Allied Bank Limited', '', '865', '10107951550014', '2024-03-17 19:03:30', 212),
(100, 'Allied Bank Limited', '', '865', '10108091640014', '2024-03-17 19:03:30', 161),
(101, 'Allied Bank Limited', '', '865', '10108418540018', '2024-03-17 19:03:30', 311),
(102, 'Allied Bank Limited', '', '865', '10053040700017', '2024-03-17 19:03:30', 5),
(103, 'Allied Bank Limited', '', '865', '0', '2024-03-17 19:03:30', 331),
(104, 'Allied Bank Limited', '', '144', '10038441800011', '2024-03-17 19:03:30', 336),
(105, 'Allied Bank Limited', '', '865', '10101390440019', '2024-03-17 19:03:30', 166),
(106, 'Allied Bank Limited', '', '865', '10099927590012', '2024-03-17 19:03:30', 81),
(107, 'Allied Bank Limited', '', '865', '100112012650016', '2024-03-17 19:03:30', 216),
(108, 'Allied Bank Limited', '', '865', '10005115320035', '2024-03-17 19:03:30', 205),
(109, 'Allied Bank Limited', '', '865', '10113004920011', '2024-03-17 19:03:30', 39),
(110, 'Allied Bank Limited', '', '0', '10038740520017', '2024-03-17 19:03:30', 36),
(111, 'Allied Bank Limited', '', '603', '10112783170012', '2024-03-17 19:03:30', 227),
(112, 'Allied Bank Limited', '', '865', '1010924720010', '2024-03-17 19:03:30', 343),
(113, 'Allied Bank Limited', '', '865', '110026153', '2024-03-17 19:03:30', 288),
(114, 'Allied Bank Limited', '', '865', '10117408150010', '2024-03-17 19:03:30', 35),
(115, 'Allied Bank Limited', '', '865', '10023708010037', '2024-03-17 19:03:30', 261),
(116, 'Allied Bank Limited', '', '865', '10074075950010', '2024-03-17 19:03:30', 305),
(117, 'Allied Bank Limited', '', '865', '10071494420010', '2024-03-17 19:03:30', 64),
(118, 'Allied Bank Limited', '', '865', '10071473790010', '2024-03-17 19:03:30', 235),
(119, 'Allied Bank Limited', '', '865', '10055283250029', '2024-03-17 19:03:30', 332),
(120, 'Allied Bank Limited', '', '865', '10071273590015', '2024-03-17 19:03:30', 130),
(121, 'Allied Bank Limited', '', '1187', '10051540400011', '2024-03-17 19:03:30', 20),
(122, 'Allied Bank Limited', '', '4516', '10007255500026', '2024-03-17 19:03:30', 244),
(123, 'Allied Bank Limited', '', '316', '10068500920011', '2024-03-17 19:03:30', 143),
(124, 'Allied Bank Limited', '', '865', '10068729200011', '2024-03-17 19:03:30', 258),
(125, 'Allied Bank Limited', '', '865', '10080858680017', '2024-03-17 19:03:30', 320),
(126, 'Allied Bank Limited', '', '865', '10080809520013', '2024-03-17 19:03:30', 272),
(127, 'Allied Bank Limited', '', '865', '10081377560011', '2024-03-17 19:03:30', 268),
(128, 'Allied Bank Limited', '', '865', '10088115380011', '2024-03-17 19:03:30', 177),
(129, 'Allied Bank Limited', '', '865', '10050156290010', '2024-03-17 19:03:30', 345),
(130, 'Allied Bank Limited', '', '865', '10074334800014', '2024-03-17 19:03:30', 126),
(131, 'Allied Bank Limited', '', '865', '10013264830012', '2024-03-17 19:03:30', 175),
(132, 'Allied Bank Limited', '', '865', '10081036500010', '2024-03-17 19:03:30', 206),
(133, 'Allied Bank Limited', '', '865', '10046362800010', '2024-03-17 19:03:30', 303),
(134, 'Allied Bank Limited', '', '865', '10107145320011', '2024-03-17 19:03:30', 82),
(135, 'Allied Bank Limited', '', '865', '10094807270011', '2024-03-17 19:03:30', 202),
(136, 'Allied Bank Limited', '', '865', '10071489740010', '2024-03-17 19:03:30', 148),
(137, 'Allied Bank Limited', '', '865', '10050759020014', '2024-03-17 19:03:30', 9),
(138, 'Allied Bank Limited', '', '865', '10051850520010', '2024-03-17 19:03:30', 266),
(139, 'Allied Bank Limited', '', '865', '10076649630014', '2024-03-17 19:03:30', 271),
(140, 'Allied Bank Limited', '', '865', '10053063480011', '2024-03-17 19:03:30', 6),
(141, 'Allied Bank Limited', '', '865', '10061279310019', '2024-03-17 19:03:30', 44),
(142, 'Allied Bank Limited', '', '865', '10023047400020', '2024-03-17 19:03:30', 2),
(143, 'Allied Bank Limited', '', '865', '10120985310010', '2024-03-17 19:03:30', 83),
(144, 'Allied Bank Limited', '', '865', '10084370060017', '2024-03-17 19:03:30', 167),
(145, 'Allied Bank Limited', '', '140865', '10058109580010', '2024-03-17 19:03:30', 40),
(146, 'Allied Bank Limited', '', '-602', '10050272760014', '2024-03-17 19:03:30', 94),
(147, 'Allied Bank Limited', '', '865', '10052860720018', '2024-03-17 19:03:30', 323),
(148, 'Allied Bank Limited', '', '865', '10038109900024', '2024-03-17 19:03:30', 30),
(149, 'Allied Bank Limited', '', '865', '10061283790013', '2024-03-17 19:03:30', 17),
(150, 'Allied Bank Limited', '', '865', '10107456720015', '2024-03-17 19:03:30', 231),
(151, 'Allied Bank Limited', '', '865', '10056954390015', '2024-03-17 19:03:30', 14),
(152, 'Allied Bank Limited', '', '316', '10108347720015', '2024-03-17 19:03:30', 185),
(153, 'Allied Bank Limited', '', '600', '10109270990010', '2024-03-17 19:03:30', 234),
(154, 'Allied Bank Limited', '', '321', '10054487070010', '2024-03-17 19:03:30', 95),
(155, 'Allied Bank Limited', '', '865', '10069347300015', '2024-03-17 19:03:30', 217),
(156, 'Allied Bank Limited', '', '114', '10059323650019', '2024-03-17 19:03:30', 322),
(157, 'Allied Bank Limited', '', '870', '10005264090020', '2024-03-17 19:03:30', 180),
(158, 'Allied Bank Limited', '', '865', '10077118340010', '2024-03-17 19:03:30', 318),
(159, 'Allied Bank Limited', '', '0', '10052657860010', '2024-03-17 19:03:30', 121),
(160, 'Allied Bank Limited', '', '0', '10066761620010', '2024-03-17 19:03:30', 16),
(161, 'Allied Bank Limited', '', '0', '10066762950010', '2024-03-17 19:03:30', 19),
(162, 'Allied Bank Limited', '', '865', '10078386900011', '2024-03-17 19:03:30', 337),
(163, 'Allied Bank Limited', '', '865', '10071374680013', '2024-03-17 19:03:30', 286),
(164, 'Allied Bank Limited', '', '865', '10112337860010', '2024-03-17 19:03:30', 310),
(165, 'Allied Bank Limited', '', '865', '10070030000010', '2024-03-17 19:03:30', 302),
(166, 'Allied Bank Limited', '', '865', '10067916700010', '2024-03-17 19:03:30', 253),
(167, 'Allied Bank Limited', '', '0', '0', '2024-03-17 19:03:30', 192),
(168, 'Al Baraka Bank (Pakistan) Limited', '', '602', '103218746010', '2024-03-17 19:03:30', 72),
(169, 'Bank Alfalah Limited', '', '5585', '5.585005000754843e15', '2024-03-17 19:03:30', 260),
(170, 'Bank Alfalah Limited', '', '0', '3171008325570', '2024-03-17 19:03:30', 133),
(171, 'Bank Alfalah Limited', '', '865', '1004196563', '2024-03-17 19:03:30', 42),
(172, 'Bank AL Habib Limited', '', '5568', '556800690007420', '2024-03-17 19:03:30', 156),
(173, 'The Bank of Khyber', '', '83', '570005', '2024-03-17 19:03:30', 60),
(174, 'The Bank of Khyber', '', '83', '600005', '2024-03-17 19:03:30', 65),
(175, 'The Bank of Khyber', '', '0', '14570006', '2024-03-17 19:03:30', 189),
(176, 'The Bank of Khyber', '', '0', '2000014766000', '2024-03-17 19:03:30', 219),
(177, 'The Bank of Khyber', '', '83', '599008', '2024-03-17 19:03:30', 28),
(178, 'The Bank of Khyber', '', '128', '0', '2024-03-17 19:03:30', 43),
(179, 'The Bank of Khyber', '', '0', '662008794122', '2024-03-17 19:03:30', 165),
(180, 'The Bank of Khyber', '', '159', '720009', '2024-03-17 19:03:30', 103),
(181, 'The Bank of Khyber', '', '159', '723003', '2024-03-17 19:03:30', 91),
(182, 'The Bank of Khyber', '', '5159', '159003002725486', '2024-03-17 19:03:30', 98),
(183, 'The Bank of Khyber', '', '168', '0', '2024-03-17 19:03:30', 41),
(184, 'The Bank of Khyber', '', '178', '0', '2024-03-17 19:03:30', 313),
(185, 'The Bank of Khyber', '', '0', '0', '2024-03-17 19:03:30', 307),
(186, 'The Bank of Khyber', '', '83', '2007659868', '2024-03-17 19:03:30', 225),
(187, 'The Bank of Khyber', '', '321', '509002', '2024-03-17 19:03:30', 218),
(188, 'The Bank of Khyber', '', '0', '225371723', '2024-03-17 19:03:30', 229),
(189, 'The Bank of Khyber', '', '92', '659003', '2024-03-17 19:03:30', 162),
(190, 'The Bank of Khyber', '', '83', '508003', '2024-03-17 19:03:30', 135),
(191, 'The Bank of Khyber', '', '128', '0', '2024-03-17 19:03:30', 199),
(192, 'The Bank of Khyber', '', '128', '0', '2024-03-17 19:03:30', 267),
(193, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 182),
(194, 'The Bank of Khyber', '', '128', '0', '2024-03-17 19:03:30', 73),
(195, 'The Bank of Khyber', '', '128', '0', '2024-03-17 19:03:30', 276),
(196, 'The Bank of Khyber', '', '128', '0', '2024-03-17 19:03:30', 344),
(197, 'The Bank of Khyber', '', '128', '0', '2024-03-17 19:03:30', 273),
(198, 'The Bank of Khyber', '', '0', '2008416648', '2024-03-17 19:03:30', 176),
(199, 'The Bank of Khyber', '', '96', '2008838097', '2024-03-17 19:03:30', 275),
(200, 'The Bank of Khyber', '', '48', '0', '2024-03-17 19:03:30', 24),
(201, 'The Bank of Khyber', '', '48', '0', '2024-03-17 19:03:30', 145),
(202, 'The Bank of Khyber', '', '48', '0', '2024-03-17 19:03:30', 299),
(203, 'The Bank of Khyber', '', '48', '0', '2024-03-17 19:03:30', 147),
(204, 'The Bank of Khyber', '', '48', '0', '2024-03-17 19:03:30', 155),
(205, 'The Bank of Khyber', '', '48', '2000753877', '2024-03-17 19:03:30', 7),
(206, 'The Bank of Khyber', '', '48', '2000716254', '2024-03-17 19:03:30', 38),
(207, 'The Bank of Khyber', '', '48', '2000760415', '2024-03-17 19:03:30', 174),
(208, 'The Bank of Khyber', '', '83', '2008105588', '2024-03-17 19:03:30', 230),
(209, 'The Bank of Khyber', '', '92', '922006059034', '2024-03-17 19:03:30', 129),
(210, 'The Bank of Khyber', '', '48', '2000711449', '2024-03-17 19:03:30', 158),
(211, 'The Bank of Khyber', '', '88', '2008511527', '2024-03-17 19:03:30', 54),
(212, 'The Bank of Khyber', '', '83', '2007769272', '2024-03-17 19:03:30', 105),
(213, 'The Bank of Khyber', '', '0', '83000001527004', '2024-03-17 19:03:30', 339),
(214, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 294),
(215, 'The Bank of Khyber', '', '2', '0', '2024-03-17 19:03:30', 122),
(216, 'The Bank of Khyber', '', '83', '403006', '2024-03-17 19:03:30', 89),
(217, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 265),
(218, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 146),
(219, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 169),
(220, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 223),
(221, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 188),
(222, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 69),
(223, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 149),
(224, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 308),
(225, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 137),
(226, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 262),
(227, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 139),
(228, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 194),
(229, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 221),
(230, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 259),
(231, 'The Bank of Khyber', '', '83', '0', '2024-03-17 19:03:30', 168),
(232, 'The Bank of Punjab', '', '705', '5.010194269000015e15', '2024-03-17 19:03:30', 277),
(233, 'Habib Bank Limited', '', '0', '4047901316403', '2024-03-17 19:03:30', 280),
(234, 'MCB Bank Limited', '', '0', '4.01036215100682e15', '2024-03-17 19:03:30', 237),
(235, 'Meezan Bank Limited', '', '706', '7060104956801', '2024-03-17 19:03:30', 297),
(236, 'Meezan Bank Limited', '', '1801', '18010107603598', '2024-03-17 19:03:30', 22),
(237, 'National Bank of Pakistan', '', '825', '3002553625', '2024-03-17 19:03:30', 37),
(238, 'Standard Chartered Bank (Pakistan) Ltd', '', '0', '1169162101', '2024-03-17 19:03:30', 248),
(239, 'Standard Chartered Bank (Pakistan) Ltd', '', '3', '1706885401', '2024-03-17 19:03:30', 290),
(240, 'United Bank Limited', '', '1486', '245812648', '2024-03-17 19:03:30', 195),
(241, 'United Bank Limited', '', '0', '251404356', '2024-03-17 19:03:30', 211),
(242, 'United Bank Limited', '', '58', '1090002514698', '2024-03-17 19:03:30', 92),
(243, 'United Bank Limited', '', '266', '246551755', '2024-03-17 19:03:30', 293),
(244, 'United Bank Limited', '', '59', '247272536', '2024-03-17 19:03:30', 52),
(245, 'United Bank Limited', '', '1269', '247116209', '2024-03-17 19:03:30', 96),
(246, 'United Bank Limited', '', '1269', '247115008', '2024-03-17 19:03:30', 114),
(247, 'United Bank Limited', '', '59', '252815553', '2024-03-17 19:03:30', 127),
(248, 'United Bank Limited', '', '59', '251257307', '2024-03-17 19:03:30', 254),
(249, 'United Bank Limited', '', '59', '252291676', '2024-03-17 19:03:30', 335),
(250, 'United Bank Limited', '', '1112', '246190808', '2024-03-17 19:03:30', 270),
(251, 'United Bank Limited', '', '59', '254583494', '2024-03-17 19:03:30', 71),
(252, 'United Bank Limited', '', '1112', '251508401', '2024-03-17 19:03:30', 289),
(253, 'United Bank Limited', '', '0', '248996583', '2024-03-17 19:03:30', 233),
(254, 'United Bank Limited', '', '385', '249478811', '2024-03-17 19:03:30', 115),
(255, 'United Bank Limited', '', '0', '249895812', '2024-03-17 19:03:30', 88),
(256, 'United Bank Limited', '', '385', '249524431', '2024-03-17 19:03:30', 117),
(257, 'United Bank Limited', '', '385', '249527843', '2024-03-17 19:03:30', 100),
(258, 'United Bank Limited', '', '385', '249560499', '2024-03-17 19:03:30', 111),
(259, 'United Bank Limited', '', '1294', '249575293', '2024-03-17 19:03:30', 116),
(260, 'United Bank Limited', '', '385', '248374862', '2024-03-17 19:03:30', 109),
(261, 'United Bank Limited', '', '385', '249531163', '2024-03-17 19:03:30', 110),
(262, 'United Bank Limited', '', '385', '250158193', '2024-03-17 19:03:30', 107),
(263, 'United Bank Limited', '', '385', '249870493', '2024-03-17 19:03:30', 97),
(264, 'United Bank Limited', '', '385', '249470046', '2024-03-17 19:03:30', 101),
(265, 'United Bank Limited', '', '0', '249654721', '2024-03-17 19:03:30', 85),
(266, 'United Bank Limited', '', '0', '249598449', '2024-03-17 19:03:30', 90),
(267, 'United Bank Limited', '', '1294', '249503519', '2024-03-17 19:03:30', 112),
(268, 'United Bank Limited', '', '0', '226229283', '2024-03-17 19:03:30', 45),
(269, 'United Bank Limited', '', '59', '246777335', '2024-03-17 19:03:30', 13),
(270, 'United Bank Limited', '', '59', '256332302', '2024-03-17 19:03:30', 46),
(271, 'United Bank Limited', '', '994', '250778603', '2024-03-17 19:03:30', 124),
(272, 'United Bank Limited', '', '59', '249129249', '2024-03-17 19:03:30', 196),
(273, 'United Bank Limited', '', '1195', '112119510016743', '2024-03-17 19:03:30', 319),
(274, 'United Bank Limited', '', '59', '246979438', '2024-03-17 19:03:30', 251),
(275, 'United Bank Limited', '', '59', '227799833', '2024-03-17 19:03:30', 264),
(276, 'United Bank Limited', '', '59', '259989271', '2024-03-17 19:03:30', 62),
(277, 'United Bank Limited', '', '0', '249827482', '2024-03-17 19:03:30', 106),
(278, 'United Bank Limited', '', '59', '257116701', '2024-03-17 19:03:30', 170),
(279, 'United Bank Limited', '', '112', '100264814874', '2024-03-17 19:03:30', 164),
(280, 'United Bank Limited', '', '59', '247604003', '2024-03-17 19:03:30', 201),
(281, 'United Bank Limited', '', '59', '248275934', '2024-03-17 19:03:30', 209),
(282, 'United Bank Limited', '', '59', '264929769', '2024-03-17 19:03:30', 207),
(283, 'United Bank Limited', '', '1112', '264821148', '2024-03-17 19:03:30', 215),
(284, 'United Bank Limited', '', '109', '247783548', '2024-03-17 19:03:30', 232),
(285, 'United Bank Limited', '', '283', '247031681', '2024-03-17 19:03:30', 163),
(286, 'United Bank Limited', '', '59', '251497006', '2024-03-17 19:03:30', 10),
(287, 'United Bank Limited', '', '59', '247196625', '2024-03-17 19:03:30', 173),
(288, 'United Bank Limited', '', '59', '0', '2024-03-17 19:03:30', 32),
(289, 'United Bank Limited', '', '109', '109000246221665', '2024-03-17 19:03:30', 136),
(290, 'United Bank Limited', '', '59', '243755701', '2024-03-17 19:03:30', 66),
(291, 'United Bank Limited', '', '32', '32261056983', '2024-03-17 19:03:30', 327),
(292, 'United Bank Limited', '', '396', '396254135093', '2024-03-17 19:03:30', 204),
(293, 'United Bank Limited', '', '396', '249616484', '2024-03-17 19:03:30', 123),
(294, 'United Bank Limited', '', '96', '396243276378', '2024-03-17 19:03:30', 301),
(295, 'United Bank Limited', '', '266', '231096478', '2024-03-17 19:03:30', 76),
(296, 'United Bank Limited', '', '109', '270224056', '2024-03-17 19:03:30', 317),
(297, 'United Bank Limited', '', '59', '247622339', '2024-03-17 19:03:30', 8),
(298, 'United Bank Limited', '', '59', '250204386', '2024-03-17 19:03:30', 309),
(299, 'United Bank Limited', '', '59', '304160109', '2024-03-17 19:03:30', 214),
(300, 'United Bank Limited', '', '59', '250705728', '2024-03-17 19:03:30', 226),
(301, 'United Bank Limited', '', '59', '247214394', '2024-03-17 19:03:30', 291);

-- --------------------------------------------------------

--
-- Table structure for table `bank_sheet`
--

CREATE TABLE `bank_sheet` (
  `cnic` varchar(100) DEFAULT NULL,
  `account_no` double DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `bank_branch_` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bank_sheet`
--

INSERT INTO `bank_sheet` (`cnic`, `account_no`, `bank_name`, `bank_branch_`) VALUES
('17101-2796634-7', 10052715740018, 'Allied Bank Limited', 865),
('372035-456951-7', 10069562080013, 'Allied Bank Limited', 865),
('21201-8920514-1', 10079097920016, 'Allied Bank Limited', 865),
('22401-4657034-7', 10076365610014, 'Allied Bank Limited', 865),
('17101-3583572-5', 10093218600024, 'Allied Bank Limited', 865),
('16101-8814390-3', 10065947150010, 'Allied Bank Limited', 865),
('21202-2977559-3', 10050039450022, 'Allied Bank Limited', 865),
('17301-061136-1', 10082881220011, 'Allied Bank Limited', 865),
('17201-4235471-7', 10083001560014, 'Allied Bank Limited', 59),
('17301-394560-5', 10087025310012, 'Allied Bank Limited', 301),
('17301-065643-3', 10087770450010, 'Allied Bank Limited', 1229),
('17301-4424632-3', 10088155860010, 'Allied Bank Limited', 865),
('17101-0649921-7', 10051210990029, 'Allied Bank Limited', 865),
('17301-7452138-3', 10082881210012, 'Allied Bank Limited', 865),
('17301-9324710-7', 10106470090015, 'Allied Bank Limited', 308),
('15702-3841114-9', 10106468360014, 'Allied Bank Limited', 308),
('17301-3541458-9', 10106468590017, 'Allied Bank Limited', 1181),
('17301-9729287-1', 10108747610013, 'Allied Bank Limited', 320),
('17301-1816625-3', 10070549430017, 'Allied Bank Limited', 865),
('17301-4568378-3', 10086745130018, 'Allied Bank Limited', 865),
('17101-0257459-9', 59837040010, 'Allied Bank Limited', 865),
('17101-8536451-7', 10049603060010, 'Allied Bank Limited', 140865),
('17301-1669367-1', 20092083480016, 'Allied Bank Limited', 5165),
('17301-0373043-1', 10050374300018, 'Allied Bank Limited', 1181),
('17101-0384331-1', 10051690330017, 'Allied Bank Limited', 865),
('17301-3120710-5', 60128850010, 'Allied Bank Limited', 865),
('17101-6691319-7', 10070357450014, 'Allied Bank Limited', 865),
('17301-9653897-9', 10054803370014, 'Allied Bank Limited', 865),
('17301-5090640-7', 10051077120018, 'Allied Bank Limited', 321),
('17301-07291222-5', 10107128010011, 'Allied Bank Limited', 865),
('17202-0392305-9', 1005217680019, 'Allied Bank Limited', 865),
('17301-3521014-1', 10053770700011, 'Allied Bank Limited', 865),
('17102-7062169-3', 10086337210013, 'Allied Bank Limited', 58),
('17301-541689-5', 10081009540015, 'Allied Bank Limited', 304),
('17101-2368756-7', 20023743630019, 'Allied Bank Limited', 5177),
('17201-7124912-3', 20121046090010, 'Allied Bank Limited', 5165),
('17201-8606422-5', 10087918340015, 'Allied Bank Limited', 316),
('17202-0348903-7', 20092334840014, 'Allied Bank Limited', 5165),
('17301-7541768-9', 10057785150016, 'Allied Bank Limited', 307),
('17301-7673659-7', 10057248850016, 'Allied Bank Limited', 865),
('17301-0604641-7', 10052567050018, 'Allied Bank Limited', 865),
('17102-8526909-8', 10044188670015, 'Allied Bank Limited', 865),
('17301-4777951-5', 10100053270018, 'Allied Bank Limited', 865),
('17601-8656273-1', 10092311280014, 'Allied Bank Limited', 865),
('17301-9693007-7', 10060765990018, 'Allied Bank Limited', 865),
('17101-4706498-5', 10065227390016, 'Allied Bank Limited', 865),
('15402-1415279-9', 10065309880013, 'Allied Bank Limited', 865),
('17301-5059352-1', 20060110690016, 'Allied Bank Limited', 5152),
('17301-5712538-7', 10071362240019, 'Allied Bank Limited', 865),
('17301-6017743-9', 10059796720015, 'Allied Bank Limited', 59),
('17301-9973001-1', 10050117140013, 'Allied Bank Limited', 865),
('16204-0409584-7', 10074414460011, 'Allied Bank Limited', 865),
('17301-7314190-1', 10057552930011, 'Allied Bank Limited', 865),
('17301-9083347-1', 10108205800018, 'Allied Bank Limited', 865),
('11201-0389226-7', 10065758460010, 'Allied Bank Limited', 865),
('17301-2960316-9', 10049610000010, 'Allied Bank Limited', 865),
('17301-9333957-3', 10091213630015, 'Allied Bank Limited', 865),
('17301-4152318-3', 10067586020016, 'Allied Bank Limited', 864),
('17301-8480617-3', 10067409740011, 'Allied Bank Limited', 864),
('17301-7614498-7', 10069310230013, 'Allied Bank Limited', 865),
('17301-884866-1', 1006983310018, 'Allied Bank Limited', 865),
('17301-7721076-5', 10069329140019, 'Allied Bank Limited', 865),
('17301-5840805-3', 10069316310015, 'Allied Bank Limited', 865),
('17201-6411644-7', 10100394940017, 'Allied Bank Limited', 865),
('17201-2795372-1', 10100396510018, 'Allied Bank Limited', 865),
('21202-2812904-1', 10053734900012, 'Allied Bank Limited', 865),
('17101-2535827-7', 10080254880014, 'Allied Bank Limited', 865),
('17301-9490210-7', 10066056920012, 'Allied Bank Limited', 865),
('17301-3044364-7', 20055732990012, 'Allied Bank Limited', 5103),
('17101-2338155-1', 10087028360011, 'Allied Bank Limited', 0),
('17301-6531008-1', 10101501390012, 'Allied Bank Limited', 865),
('16102-0719576-1', 10046620050012, 'Allied Bank Limited', 0),
('17301-1579074-3', 10055549690014, 'Allied Bank Limited', 865),
('17301-8957298-1', 10061320440017, 'Allied Bank Limited', 865),
('17301-1609451-9', 0, 'Allied Bank Limited', 0),
('17101-0412676-6', 10061918520010, 'Allied Bank Limited', 865),
('17301-6220686-7', 100599852770010, 'Allied Bank Limited', 864),
('17301-2057931-7', 10069449750010, 'Allied Bank Limited', 865),
('17301-3844451-9', 10069319360014, 'Allied Bank Limited', 865),
('17301-7687838-1', 10060734150010, 'Allied Bank Limited', 865),
('17301-1404925-9', 10069239740013, 'Allied Bank Limited', 865),
('16101-1223514-1', 10070061100011, 'Allied Bank Limited', 865),
('17301-7750694-7', 10069182710015, 'Allied Bank Limited', 865),
('17301-3277915-9', 10069197410018, 'Allied Bank Limited', 865),
('17301-5106355-7', 10069178940017, 'Allied Bank Limited', 865),
('17301-5795794-5', 10069565810015, 'Allied Bank Limited', 865),
('17301-1597731-7', 10069229710018, 'Allied Bank Limited', 865),
('17301-75441863-1', 10069368080010, 'Allied Bank Limited', 865),
('17101-2807152-9', 10070858650014, 'Allied Bank Limited', 865),
('17301-8200566-3', 10070772770014, 'Allied Bank Limited', 865),
('17301-8608711-3', 10058942380016, 'Allied Bank Limited', 865),
('17301-1314545-7', 10038131510014, 'Allied Bank Limited', 865),
('17302-1150513-3', 10075495350013, 'Allied Bank Limited', 865),
('17301-8799968-9', 10058481001, 'Allied Bank Limited', 865),
('17101-0372137-5', 10070519030011, 'Allied Bank Limited', 865),
('17301-1679082-5', 10061263050011, 'Allied Bank Limited', 865),
('17301-3190569-9', 0, 'Allied Bank Limited', 865),
('17301-6145915-5', 10069944840011, 'Allied Bank Limited', 865),
('17301-1105057-1', 10069944950013, 'Allied Bank Limited', 865),
('35404-4955923-3', 10069968140017, 'Allied Bank Limited', 865),
('15402-4656045-7', 10070280290018, 'Allied Bank Limited', 865),
('17301-6354267-1', 10049907520015, 'Allied Bank Limited', 100),
('17301-0938639-3', 10059565960018, 'Allied Bank Limited', 865),
('14301-5611312-3', 10053189200017, 'Allied Bank Limited', 865),
('17301-4640799-7', 10066616750011, 'Allied Bank Limited', 865),
('17301-6097064-5', 10077151430014, 'Allied Bank Limited', 865),
('17301-9239744-1', 10069380030015, 'Allied Bank Limited', 865),
('17301-2658781-9', 10076848100019, 'Allied Bank Limited', 865),
('17301-5922576-3', 10076956310012, 'Allied Bank Limited', 865),
('17301-5788496-9', 10076607710017, 'Allied Bank Limited', 865),
('17301-0869572-1', 10077240910017, 'Allied Bank Limited', 865),
('17301-9880846-9', 10036621290020, 'Allied Bank Limited', 865),
('17301-2561105-1', 10024056710019, 'Allied Bank Limited', 865),
('17301-1632339-5', 20077073480015, 'Allied Bank Limited', 865),
('17301-4767295-3', 10107951550014, 'Allied Bank Limited', 865),
('111101-8591153-7', 10109836680018, 'Allied Bank Limited', 865),
('17301-2080471-3', 10108091640014, 'Allied Bank Limited', 865),
('17102-3843345-6', 1007409950019, 'Allied Bank Limited', 865),
('17301-9231620-7', 10108418540018, 'Allied Bank Limited', 865),
('17201-9607621-9', 10058107500019, 'Allied Bank Limited', 865),
('11201-5391143-1', 10053040700017, 'Allied Bank Limited', 865),
('21202-1164123-1', 0, 'Allied Bank Limited', 865),
('21202-7287844-7', 10038441800011, 'Allied Bank Limited', 144),
('17301-2406684-7', 10101390440019, 'Allied Bank Limited', 865),
('17102-8286211-9', 10099927590012, 'Allied Bank Limited', 865),
('17301-4988855-9', 100112012650016, 'Allied Bank Limited', 865),
('17301-4438354-7', 10005115320035, 'Allied Bank Limited', 865),
('16202-0247309-5', 10113004920011, 'Allied Bank Limited', 865),
('16102-7941321-3', 10038740520017, 'Allied Bank Limited', 0),
('17301-5190579-5', 10112783170012, 'Allied Bank Limited', 603),
('42301-3352998-3', 1010924720010, 'Allied Bank Limited', 865),
('17301-7929871-5', 110026153, 'Allied Bank Limited', 865),
('16102-7449695-5', 10117408150010, 'Allied Bank Limited', 865),
('17301-6830833-6', 10023708010037, 'Allied Bank Limited', 865),
('17301-9076060-5', 10074075950010, 'Allied Bank Limited', 865),
('17301-77488612-5', 10071453650015, 'Allied Bank Limited', 865),
('17601-1384236-3', 10071463850019, 'Allied Bank Limited', 865),
('17101-5028109-1', 10071494420010, 'Allied Bank Limited', 865),
('17301-5696195-3', 10071473790010, 'Allied Bank Limited', 865),
('21202-1670154-7', 10055283250029, 'Allied Bank Limited', 865),
('17301-06995295-5', 10071273590015, 'Allied Bank Limited', 865),
('15402-9672579-5', 10051540400011, 'Allied Bank Limited', 1187),
('152025665435-1', 10077985810010, 'Allied Bank Limited', 865),
('17301-2897721-5', 10047949950018, 'Allied Bank Limited', 865),
('17301-5938404-9', 10007255500026, 'Allied Bank Limited', 4516),
('17301-1402333-9', 10068500920011, 'Allied Bank Limited', 316),
('17301-6546107-1', 10068729200011, 'Allied Bank Limited', 865),
('17301-9605360-9', 10080858680017, 'Allied Bank Limited', 865),
('17301-7432682-5', 10080809520013, 'Allied Bank Limited', 865),
('17301-7292209-3', 10081377560011, 'Allied Bank Limited', 865),
('17301-2879725-5', 10088115380011, 'Allied Bank Limited', 865),
('61101-5609831-9', 10050156290010, 'Allied Bank Limited', 865),
('17301-0625706-3', 10074334800014, 'Allied Bank Limited', 865),
('17301-2763900-1', 10013264830012, 'Allied Bank Limited', 865),
('17301-4484222-1', 10081036500010, 'Allied Bank Limited', 865),
('16202-4562485-9', 10112837830012, 'Allied Bank Limited', 865),
('17301-8954304-7', 10046362800010, 'Allied Bank Limited', 865),
('14201-2129820-3', 120065131, 'Allied Bank Limited', 865),
('17102-8360641-3', 10107145320011, 'Allied Bank Limited', 865),
('17301-4417844-9', 10094807270011, 'Allied Bank Limited', 865),
('17301-1567987-3', 10071489740010, 'Allied Bank Limited', 865),
('14301-2318787-7', 10050759020014, 'Allied Bank Limited', 865),
('17301-6955877-9', 10051850520010, 'Allied Bank Limited', 865),
('17301-7399541-1', 10076649630014, 'Allied Bank Limited', 865),
('11201-5963209-7', 10053063480011, 'Allied Bank Limited', 865),
('16203-0352819-1', 10061279310019, 'Allied Bank Limited', 865),
('11101-8836113-9', 10023047400020, 'Allied Bank Limited', 865),
('17102-8461469-5', 10120985310010, 'Allied Bank Limited', 865),
('17301-2429588-7', 10084370060017, 'Allied Bank Limited', 865),
('16202-2140939-7', 10058109580010, 'Allied Bank Limited', 140865),
('17201-2936771-7', 10050272760014, 'Allied Bank Limited', -602),
('17301-9678011-9', 10052860720018, 'Allied Bank Limited', 865),
('16101-8658908-7', 10038109900024, 'Allied Bank Limited', 865),
('15402-3030316-1', 10061283790013, 'Allied Bank Limited', 865),
('17301-5626845-7', 10107456720015, 'Allied Bank Limited', 865),
('15401-9686395-7', 10056954390015, 'Allied Bank Limited', 865),
('17301-3145422-7', 10108347720015, 'Allied Bank Limited', 316),
('17301-5678740-7', 10109270990010, 'Allied Bank Limited', 600),
('17201-3599516-1', 10054487070010, 'Allied Bank Limited', 321),
('17301-5012792-3', 10069347300015, 'Allied Bank Limited', 865),
('17301-9667549-3', 10059323650019, 'Allied Bank Limited', 114),
('17301-2904848-7', 10005264090020, 'Allied Bank Limited', 870),
('17301-9507047-1', 10077118340010, 'Allied Bank Limited', 865),
('17301-0412328-3', 10052657860010, 'Allied Bank Limited', 0),
('161021-613334-1', 10072844590019, 'Allied Bank Limited', 865),
('15402-2435973-3', 10066761620010, 'Allied Bank Limited', 0),
('15402-8593892-7', 10066762950010, 'Allied Bank Limited', 0),
('21202-8179701-3', 10078386900011, 'Allied Bank Limited', 865),
('17301-7870413-3', 10071374680013, 'Allied Bank Limited', 865),
('17301-9211248-5', 10112337860010, 'Allied Bank Limited', 865),
('17301-8876047-5', 10070030000010, 'Allied Bank Limited', 865),
('17301-6382282-6', 10067916700010, 'Allied Bank Limited', 865),
('17301-3633794-3', 0, 'Allied Bank Limited', 0),
('17301-3591801-5', 0, 'Allied Bank Limited', 0),
('17101-7632025-9', 103218746010, 'Al Baraka Bank (Pakistan) Limited', 602),
('17301-6822473-3', 5.585005000754843e15, 'Bank Alfalah Limited', 5585),
('17301-0926670-7', 3171008325570, 'Bank Alfalah Limited', 0),
('16202-679375-1', 1004196563, 'Bank Alfalah Limited', 865),
('17301-1786379-5', 556800690007420, 'Bank AL Habib Limited', 5568),
('17101-3283210-1', 570005, 'The Bank of Khyber', 83),
('17101-5159316-5', 600005, 'The Bank of Khyber', 83),
('17301-3353505-3', 14570006, 'The Bank of Khyber', 0),
('17301-5047211-5', 2000014766000, 'The Bank of Khyber', 0),
('16101-1844766-1', 599008, 'The Bank of Khyber', 83),
('16202-7714167-7', 0, 'The Bank of Khyber', 128),
('16102-2305288-5', 0, 'The Bank of Khyber', 83),
('17301-2403046-9', 662008794122, 'The Bank of Khyber', 0),
('17201-6868432-3', 720009, 'The Bank of Khyber', 159),
('17201-2166980-3', 723003, 'The Bank of Khyber', 159),
('17201-3994344-5', 159003002725486, 'The Bank of Khyber', 5159),
('16202-3473698-3', 0, 'The Bank of Khyber', 168),
('17301-9320934-7', 0, 'The Bank of Khyber', 178),
('17301-9085989-2', 0, 'The Bank of Khyber', 0),
('17301-5124477-1', 2007659868, 'The Bank of Khyber', 83),
('17301-5041331-5', 509002, 'The Bank of Khyber', 321),
('17301-5455208-9', 225371723, 'The Bank of Khyber', 0),
('17301-2258033-3', 659003, 'The Bank of Khyber', 92),
('17301-0954756-1', 508003, 'The Bank of Khyber', 83),
('17301-8987557-7', 2006159648, 'The Bank of Khyber', 68),
('17301-4030271-8', 0, 'The Bank of Khyber', 128),
('17301-7086135-5', 0, 'The Bank of Khyber', 128),
('17301-3029542-9', 0, 'The Bank of Khyber', 83),
('17101-7672572-3', 0, 'The Bank of Khyber', 128),
('17301-7528610-7', 0, 'The Bank of Khyber', 128),
('42301-8378023-3', 0, 'The Bank of Khyber', 128),
('17301-7446159-5', 0, 'The Bank of Khyber', 128),
('17301-2865470-7', 2008416648, 'The Bank of Khyber', 0),
('17301-4794341-7', 68000000915002, 'The Bank of Khyber', 0),
('17301-7460474-3', 2008838097, 'The Bank of Khyber', 96),
('15606-1082047-5', 0, 'The Bank of Khyber', 48),
('17301-1423266-5', 0, 'The Bank of Khyber', 48),
('17301-8609499-1', 0, 'The Bank of Khyber', 48),
('17301-1549795-7', 0, 'The Bank of Khyber', 48),
('17301-1743796-1', 0, 'The Bank of Khyber', 48),
('13302-0633845-9', 2000753877, 'The Bank of Khyber', 48),
('16201-0714000-5', 2000716254, 'The Bank of Khyber', 48),
('17301-2760122-8', 2000760415, 'The Bank of Khyber', 48),
('17301-5623100-3', 2008105588, 'The Bank of Khyber', 83),
('21202-43396164-5', 2005836142, 'The Bank of Khyber', 96),
('17301-0680812-5', 922006059034, 'The Bank of Khyber', 92),
('17301-1860835-7', 2000711449, 'The Bank of Khyber', 48),
('17101-0613951-3', 2008511527, 'The Bank of Khyber', 88),
('17201-7407567-5', 2007769272, 'The Bank of Khyber', 83),
('17101-704828-1', 486003, 'The Bank of Khyber', 83),
('21301-5436960-1', 83000001527004, 'The Bank of Khyber', 0),
('17301-8285633-7', 0, 'The Bank of Khyber', 83),
('17301-0434887-1', 0, 'The Bank of Khyber', 2),
('17201-2103499-5', 403006, 'The Bank of Khyber', 83),
('17301-6940000-7', 0, 'The Bank of Khyber', 83),
('17301-1464112-5', 0, 'The Bank of Khyber', 83),
('17301-2486057-3', 0, 'The Bank of Khyber', 83),
('17301-5161033-3', 0, 'The Bank of Khyber', 83),
('17301-5091901-9', 0, 'The Bank of Khyber', 83),
('17301-3282495-1', 0, 'The Bank of Khyber', 83),
('17101-7010515-1', 0, 'The Bank of Khyber', 83),
('17301-1579074-3', 0, 'The Bank of Khyber', 83),
('17301-9166062-9', 0, 'The Bank of Khyber', 83),
('17301-1104127-5', 0, 'The Bank of Khyber', 83),
('17301-6855641-5', 0, 'The Bank of Khyber', 83),
('17301-1151142-7', 0, 'The Bank of Khyber', 83),
('17301-3722486-7', 0, 'The Bank of Khyber', 83),
('17301-5087032-5', 0, 'The Bank of Khyber', 83),
('17301-6772978-7', 0, 'The Bank of Khyber', 83),
('17301-2477589-7', 0, 'The Bank of Khyber', 83),
('17301-7541621-5', 5.010194269000015e15, 'The Bank of Punjab', 705),
('17301-7565213-7', 4047901316403, 'Habib Bank Limited', 0),
('17301-5767629-0', 4.01036215100682e15, 'MCB Bank Limited', 0),
('17301-8504130-1', 7060104956801, 'Meezan Bank Limited', 706),
('15602-2624321-3', 18010107603598, 'Meezan Bank Limited', 1801),
('17301-5882421-1', 1.73100266559e15, 'MCB Islamic Bank', 173),
('16102-8573326-2', 3002553625, 'National Bank of Pakistan', 825),
('17301-1134911-7', 0, 'Sindh Bank Limited', 806),
('17301-6114774-5', 1169162101, 'Standard Chartered Bank (Pakistan) Ltd', 0),
('17301-8056907-3', 1706885401, 'Standard Chartered Bank (Pakistan) Ltd', 3),
('17301-3746461-9', 245812648, 'United Bank Limited', 1486),
('17301-4701853-3', 251404356, 'United Bank Limited', 0),
('17201-2205453-1', 1090002514698, 'United Bank Limited', 58),
('17301-8219461-5', 246551755, 'United Bank Limited', 266),
('17101-0402048-9', 247272536, 'United Bank Limited', 59),
('17201-3820833-5', 247116209, 'United Bank Limited', 1269),
('17202-0349763-3', 247115008, 'United Bank Limited', 1269),
('17301-0648350-3', 252815553, 'United Bank Limited', 59),
('17301-6410701-3', 251257307, 'United Bank Limited', 59),
('21202-5892295-7', 252291676, 'United Bank Limited', 59),
('17301-7330437-3', 246190808, 'United Bank Limited', 1112),
('17101-7295686-5', 254583494, 'United Bank Limited', 59),
('17301-7988564-5', 251508401, 'United Bank Limited', 1112),
('17301-5651698-1', 248996583, 'United Bank Limited', 0),
('17202-0351777-1', 249478811, 'United Bank Limited', 385),
('17201-1114971-1', 249895812, 'United Bank Limited', 0),
('17202-0365356-9', 249524431, 'United Bank Limited', 385),
('17201-5219330-5', 249527843, 'United Bank Limited', 385),
('17016-115697-9', 249656093, 'United Bank Limited', 0),
('17202-0344603-3', 249560499, 'United Bank Limited', 385),
('17202-0362254-7', 249575293, 'United Bank Limited', 1294),
('17201-9396371-5', 248374862, 'United Bank Limited', 385),
('17201-9968290-7', 249531163, 'United Bank Limited', 385),
('17201-8273990-5', 250158193, 'United Bank Limited', 385),
('17201-3892386-5', 249870493, 'United Bank Limited', 385),
('17201-2141468-7', 249403725, 'United Bank Limited', 385),
('17202-0365647-5', 249433405, 'United Bank Limited', 385),
('17201-5427003-3', 249470046, 'United Bank Limited', 385),
('17201-0354128-9', 249654721, 'United Bank Limited', 0),
('17201-2135571-7', 249598449, 'United Bank Limited', 0),
('17202-0348796-9', 249503519, 'United Bank Limited', 1294),
('17201-099313-5', 249574931, 'United Bank Limited', 385),
('16204-0371635-5', 226229283, 'United Bank Limited', 0),
('15302-8043357-7', 246777335, 'United Bank Limited', 59),
('16204-0400784-1', 256332302, 'United Bank Limited', 59),
('17301-0575504-3', 250778603, 'United Bank Limited', 994),
('17301-3829851-1', 249129249, 'United Bank Limited', 59),
('17301-9545860-1', 112119510016743, 'United Bank Limited', 1195),
('17312-2887843-5', 246270889, 'United Bank Limited', 59),
('17301-6326417-7', 246979438, 'United Bank Limited', 59),
('17301-6894789-3', 227799833, 'United Bank Limited', 59),
('17101-4059136-3', 259989271, 'United Bank Limited', 59),
('17201-8031188-3', 249827482, 'United Bank Limited', 0),
('17301-2547202-7', 257116701, 'United Bank Limited', 59),
('17301-2327562-1', 100264814874, 'United Bank Limited', 112),
('17301-4305930-3', 247604003, 'United Bank Limited', 59),
('17301-4572963-9', 248275934, 'United Bank Limited', 59),
('17301-4516638-9', 264929769, 'United Bank Limited', 59),
('17301-4915291-3', 264821148, 'United Bank Limited', 1112),
('17301-5637672-5', 247783548, 'United Bank Limited', 109),
('17301-2318585-1', 247031681, 'United Bank Limited', 283),
('14301-4001352-9', 251497006, 'United Bank Limited', 59),
('17301-2663442-9', 247196625, 'United Bank Limited', 59),
('16101-9719911-9', 0, 'United Bank Limited', 59),
('17301-1094091-9', 109000246221665, 'United Bank Limited', 109),
('17101-5360013-9', 243755701, 'United Bank Limited', 59),
('17301-9893325-3', 32261056983, 'United Bank Limited', 32),
('17301-4429680-5', 396254135093, 'United Bank Limited', 396),
('17301-0471169-1', 249616484, 'United Bank Limited', 396),
('17301-8827585-3', 396243276378, 'United Bank Limited', 96),
('17101-9895010-7', 231096478, 'United Bank Limited', 266),
('17301-9492137-3', 270224056, 'United Bank Limited', 109),
('14202-7215429-3', 247622339, 'United Bank Limited', 59),
('17301-9175062-1', 250204386, 'United Bank Limited', 59),
('17301-4910124-3', 304160109, 'United Bank Limited', 59),
('17301-5171817-1', 250705728, 'United Bank Limited', 59),
('17301-8100032-9', 247214394, 'United Bank Limited', 59);

-- --------------------------------------------------------

--
-- Table structure for table `chargeable_heads`
--

CREATE TABLE `chargeable_heads` (
  `chargeable_head_id` int UNSIGNED NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `chargeable_heads`
--

INSERT INTO `chargeable_heads` (`chargeable_head_id`, `title`, `created_at`) VALUES
(1, 'Uplift and Beautification of Peshawar', '2024-03-15 19:24:46'),
(2, 'Head Office', '2024-03-15 19:24:46'),
(3, 'Maintenance of Head Office', '2024-03-15 19:24:46'),
(4, 'Maintenance of Hort (HST)', '2024-03-15 19:24:46'),
(5, 'Peshawar Uplift Program', '2024-03-15 19:24:46'),
(6, 'Law Charges', '2024-03-15 19:24:46'),
(7, 'Internal Roads Rehabilitation in Peshawar City', '2024-03-15 19:24:46'),
(8, 'Maintenance of (Hort) N-5/ G.T Road', '2024-03-15 19:24:46'),
(9, 'Maintenance of (Machinery)', '2024-03-15 19:24:46'),
(10, 'Maintenance of (W&S) HST', '2024-03-15 19:24:46'),
(11, 'Maintenance of G.T/Jamrud Road (Self Finance/PDA Funded)', '2024-03-15 19:24:46'),
(12, 'Maintenance of Street Lights', '2024-03-15 19:24:46'),
(13, 'Maintenance of (W&S)', '2024-03-15 19:24:46'),
(14, 'Maintenance of W&S: HST', '2024-03-15 19:24:46'),
(15, 'RMT', '2024-03-15 19:24:46'),
(16, 'Maintenance of (Machinary)', '2024-03-15 19:24:46'),
(17, 'Beautification of Peshawar.', '2024-03-15 19:24:46'),
(18, 'Pir Zakori Flyover Level-II', '2024-03-15 19:24:46'),
(19, 'Recovery Cell (E.M)', '2024-03-15 19:24:46'),
(20, 'Hazar Khawani Park', '2024-03-15 19:24:46'),
(21, 'Maintenance of N-5/G.T/Jamrud Road', '2024-03-15 19:24:46'),
(22, 'Peshawar Uplift', '2024-03-15 19:24:46'),
(23, 'Maintenance of (Hort) N-5/G.T Road', '2024-03-15 19:24:46'),
(24, 'Uplift & Beautification of Nowshera', '2024-03-15 19:24:46'),
(25, 'N-5/G.T Road', '2024-03-15 19:24:46'),
(26, 'Internal Roads Peshawar', '2024-03-15 19:24:46'),
(27, 'Maintenance of Horticulture', '2024-03-15 19:24:46'),
(28, 'Repair & Maintenance of Roads (HST)', '2024-03-15 19:24:46'),
(29, 'Maintenance of (Hort:) N-5/G.T/Jamrud Road', '2024-03-15 19:24:46'),
(30, 'Maintenance of G.T/Jamrud/N-5 Road Peshawar', '2024-03-15 19:24:46'),
(31, 'Maintenance of (W&S HST)', '2024-03-15 19:24:46'),
(32, 'Water supplly', '2024-03-15 19:24:46'),
(33, 'Hazar Khwani Park', '2024-03-15 19:24:46'),
(34, 'New Peshawar Valley', '2024-03-15 19:24:46'),
(35, 'Uplift & Beautification of Nowshera (Pabbi to Jehangira)', '2024-03-15 19:24:46'),
(36, 'Recovery Cell', '2024-03-15 19:24:46'),
(37, 'Installation of LED Urban Roads Peshawar', '2024-03-15 19:24:46'),
(38, 'Maintenance of G.T/Jamrud Road', '2024-03-15 19:24:46'),
(39, 'Maint of Hort N-5 GT Road', '2024-03-15 19:24:46'),
(40, 'Maintenance of (Hort:) HST', '2024-03-15 19:24:46'),
(41, 'Maintenance of N-5/G.T/Jamrud Road (Self Finance/PDA Funded)', '2024-03-15 19:24:46'),
(42, '\"Maintenance of (Hort:)/N-5', '2024-03-15 19:24:46'),
(43, 'Maintenance of Hort: HST', '2024-03-15 19:24:46'),
(44, '', '2024-03-15 19:24:46'),
(45, 'New Peshawar Vally', '2024-03-15 19:24:46'),
(46, 'Maintenance of Building', '2024-03-15 19:24:46'),
(47, 'Maintenance of (Hort) N-5/Jamrud Roads', '2024-03-15 19:24:46'),
(48, 'Maintenance of Road RMT', '2024-03-15 19:24:46'),
(49, '\"Construction of Detour Road', '2024-03-15 19:24:46'),
(50, 'Maintenance of W&S', '2024-03-15 19:24:46'),
(51, 'Maintenance of (Hort:)hst;', '2024-03-15 19:24:46'),
(52, 'Regi Model Town', '2024-03-15 19:24:46'),
(53, 'Maint of Hort RMT', '2024-03-15 19:24:46'),
(54, 'EM RMT', '2024-03-15 19:24:46'),
(65, 'desigantion', '2024-03-16 20:39:36'),
(70, 'Head Office1', '2024-03-16 20:46:57');

-- --------------------------------------------------------

--
-- Table structure for table `designations`
--

CREATE TABLE `designations` (
  `designation_id` int UNSIGNED NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `designations`
--

INSERT INTO `designations` (`designation_id`, `title`, `created_at`) VALUES
(1, 'Supervisor', '2024-03-15 19:23:51'),
(2, 'Asst Supervisor', '2024-03-15 19:23:51'),
(3, 'TWO', '2024-03-15 19:23:51'),
(4, 'Helper', '2024-03-15 19:23:51'),
(5, 'Chowkidar', '2024-03-15 19:23:51'),
(6, 'Mate', '2024-03-15 19:23:51'),
(7, 'SLC', '2024-03-15 19:23:51'),
(8, 'Surveyor', '2024-03-15 19:23:51'),
(9, 'Assistant Supervisor', '2024-03-15 19:23:51'),
(10, 'Tractor Driver', '2024-03-15 19:23:51'),
(11, 'Electrician', '2024-03-15 19:23:51'),
(12, 'Road Gang Collie', '2024-03-15 19:23:51'),
(13, 'Mali', '2024-03-15 19:23:51'),
(14, 'Supervisor (Electrical)', '2024-03-15 19:23:51'),
(15, 'Tubewell Operator', '2024-03-15 19:23:51'),
(16, 'Asstt; Buldind Inspt;', '2024-03-15 19:23:51'),
(17, 'Pesh Imam', '2024-03-15 19:23:51'),
(18, 'Chief SLC', '2024-03-15 19:23:51'),
(19, 'Sanitary Worker', '2024-03-15 19:23:51'),
(20, 'Survey Supervisor', '2024-03-15 19:23:51'),
(21, 'Driver', '2024-03-15 19:23:51'),
(22, 'Elect Helper', '2024-03-15 19:23:51'),
(23, 'Drain Cleaner', '2024-03-15 19:23:51'),
(24, 'Forest Guard', '2024-03-15 19:23:51'),
(25, 'Cleaner', '2024-03-15 19:23:51'),
(26, 'Electrician Helper', '2024-03-15 19:23:51'),
(27, 'Survey Helper', '2024-03-15 19:23:51'),
(28, 'Sanitory Worker', '2024-03-15 19:23:51'),
(29, 'Pipe Fitter', '2024-03-15 19:23:51'),
(30, 'Supervisor Electrical', '2024-03-15 19:23:51'),
(31, 'F.G', '2024-03-15 19:23:51'),
(32, 'Asst-Super', '2024-03-15 19:23:51'),
(33, 'Consultant ', '2024-03-15 19:23:51'),
(34, 'S.L.C', '2024-03-15 19:23:51'),
(35, 'Financial Advisor', '2024-03-15 19:23:51'),
(36, 'Consultant / Advisor', '2024-03-15 19:23:51'),
(37, 'Assistant', '2024-03-15 19:23:51'),
(38, 'Naib Qasid', '2024-03-15 19:23:51'),
(39, 'Revenue Consultant ', '2024-03-15 19:23:51'),
(40, 'Suprrvisor', '2024-03-15 19:23:51'),
(41, 'SCL', '2024-03-15 19:23:51'),
(42, 'Sirvey Helper', '2024-03-15 19:23:51'),
(43, 'Electrical Supervisor', '2024-03-15 19:23:51'),
(44, 'Finance Supervisor', '2024-03-15 19:23:51'),
(45, 'Consultant Advisor', '2024-03-15 19:23:51'),
(46, 'Asstt; Supervisor', '2024-03-15 19:23:51'),
(47, 'Khadim', '2024-03-15 19:23:51'),
(48, 'Vet Doctor', '2024-03-15 19:23:51'),
(49, 'Road Gang Cooly', '2024-03-15 19:23:51'),
(50, 'Excavator Operator', '2024-03-15 19:23:51'),
(64, 'ChargeableHeads', '2024-03-16 20:41:36'),
(67, 'Supervisor1', '2024-03-16 20:43:19'),
(68, 'Supervisor1 2', '2024-03-16 20:43:23'),
(69, 'Supervisor1 22', '2024-03-16 20:43:47'),
(72, 'Supervisor12', '2024-03-16 20:44:43'),
(73, 'Supervisor123', '2024-03-16 20:44:45'),
(77, 'Supervisor1235', '2024-03-16 20:45:36'),
(78, 'designation', '2024-03-16 20:46:33'),
(80, 'designation1', '2024-03-16 20:46:38');

-- --------------------------------------------------------

--
-- Table structure for table `directorates`
--

CREATE TABLE `directorates` (
  `directorate_id` int UNSIGNED NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `directorates`
--

INSERT INTO `directorates` (`directorate_id`, `title`, `created_at`) VALUES
(1, 'ADG (Hort)', '2024-03-15 19:25:55'),
(2, 'D (Engg: Roads)', '2024-03-15 19:25:55'),
(3, 'D(W&S) 5', '2024-03-15 19:25:55'),
(4, 'DG Secretariat', '2024-03-15 19:25:55'),
(5, 'Legal Section', '2024-03-15 19:25:55'),
(6, 'D(Finance)', '2024-03-15 19:25:55'),
(7, 'D (Electrical)', '2024-03-15 19:25:55'),
(8, 'D(BCA) RMT', '2024-03-15 19:25:55'),
(9, 'D (Eng RMT)', '2024-03-15 19:25:55'),
(10, 'D(Machinery) ', '2024-03-15 19:25:55'),
(11, 'D(Admin)', '2024-03-15 19:25:55'),
(12, 'D(E.M)', '2024-03-15 19:25:55'),
(13, 'D(Coord:) PIU BRT', '2024-03-15 19:25:55'),
(33, 'new directorate', '2024-03-16 20:28:09'),
(34, 'ChargeableHeads', '2024-03-16 20:41:55');

-- --------------------------------------------------------

--
-- Table structure for table `extensions_validity`
--

CREATE TABLE `extensions_validity` (
  `extensions_validity_id` int UNSIGNED NOT NULL,
  `official_id` int DEFAULT NULL,
  `validity_from` varchar(50) DEFAULT NULL,
  `validity_to` varchar(50) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `extensions_validity`
--

INSERT INTO `extensions_validity` (`extensions_validity_id`, `official_id`, `validity_from`, `validity_to`, `user_id`, `created_at`) VALUES
(1, 1, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(2, 2, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(3, 3, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(4, 4, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(5, 5, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(6, 6, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(7, 7, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(8, 8, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(9, 9, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(10, 10, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(11, 11, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(12, 12, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(13, 13, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(14, 14, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(15, 15, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(16, 16, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(17, 17, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(18, 18, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(19, 19, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(20, 20, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(21, 21, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(22, 22, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(23, 23, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(24, 24, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(25, 25, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(26, 26, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(27, 27, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(28, 28, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(29, 29, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(30, 30, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(31, 31, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(32, 32, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(33, 33, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(34, 34, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(35, 35, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(36, 36, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(37, 37, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(38, 38, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(39, 39, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(40, 40, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(41, 41, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(42, 42, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(43, 43, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(44, 44, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(45, 45, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(46, 46, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(47, 47, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(48, 48, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(49, 49, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(50, 50, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(51, 51, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(52, 52, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(53, 53, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(54, 54, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(55, 55, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(56, 56, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(57, 57, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(58, 58, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(59, 59, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(60, 60, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(61, 62, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(62, 63, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(63, 64, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(64, 65, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(65, 66, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(66, 67, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(67, 68, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(68, 69, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(69, 70, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(70, 71, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(71, 72, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(72, 73, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(73, 74, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(74, 75, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(75, 76, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(76, 77, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(77, 79, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(78, 80, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(79, 81, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(80, 82, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(81, 83, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(82, 84, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(83, 85, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(84, 86, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(85, 87, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(86, 88, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(87, 89, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(88, 90, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(89, 91, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(90, 92, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(91, 93, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(92, 94, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(93, 95, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(94, 96, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(95, 97, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(96, 98, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(97, 99, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(98, 100, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(99, 101, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(100, 102, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(101, 103, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(102, 104, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(103, 105, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(104, 106, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(105, 107, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(106, 108, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(107, 109, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(108, 110, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(109, 111, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(110, 112, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(111, 113, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(112, 114, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(113, 115, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(114, 116, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(115, 117, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(116, 118, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(117, 119, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(118, 120, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(119, 121, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(120, 122, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(121, 123, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(122, 124, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(123, 125, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(124, 126, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(125, 127, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(126, 128, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(127, 129, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(128, 130, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(129, 131, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(130, 132, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(131, 133, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(132, 134, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(133, 135, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(134, 136, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(135, 137, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(136, 138, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(137, 139, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(138, 140, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(139, 141, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(140, 142, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(141, 143, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(142, 144, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(143, 145, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(144, 146, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(145, 147, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(146, 148, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(147, 149, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(148, 150, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(149, 151, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(150, 152, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(151, 153, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(152, 154, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(153, 155, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(154, 156, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(155, 157, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(156, 158, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(157, 159, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(158, 160, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(159, 161, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(160, 162, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(161, 163, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(162, 164, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(163, 165, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(164, 166, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(165, 167, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(166, 168, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(167, 169, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(168, 170, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(169, 171, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(170, 172, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(171, 173, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(172, 174, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(173, 175, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(174, 176, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(175, 177, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(176, 178, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(177, 179, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(178, 180, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(179, 181, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(180, 182, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(181, 183, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(182, 184, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(183, 185, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(184, 186, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(185, 187, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(186, 188, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(187, 189, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(188, 190, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(189, 191, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(190, 192, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(191, 193, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(192, 194, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(193, 195, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(194, 196, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(195, 197, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(196, 198, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(197, 199, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(198, 200, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(199, 201, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(200, 202, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(201, 203, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(202, 204, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(203, 205, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(204, 206, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(205, 207, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(206, 208, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(207, 209, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(208, 210, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(209, 211, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(210, 212, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(211, 213, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(212, 214, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(213, 215, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(214, 216, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(215, 217, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(216, 218, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(217, 219, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(218, 220, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(219, 221, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(220, 222, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(221, 223, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(222, 224, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(223, 225, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(224, 226, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(225, 227, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(226, 228, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(227, 229, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(228, 230, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(229, 231, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(230, 232, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(231, 233, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(232, 234, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(233, 235, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(234, 236, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(235, 237, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(236, 238, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(237, 239, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(238, 240, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(239, 241, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(240, 242, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(241, 243, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(242, 244, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(243, 245, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(244, 246, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(245, 247, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(246, 248, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(247, 249, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(248, 250, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(249, 251, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(250, 252, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(251, 253, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(252, 254, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(253, 255, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(254, 256, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(255, 257, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(256, 258, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(257, 259, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(258, 260, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(259, 261, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(260, 262, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(261, 263, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(262, 264, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(263, 265, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(264, 266, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(265, 267, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(266, 268, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(267, 269, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(268, 270, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(269, 271, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(270, 272, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(271, 273, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(272, 274, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(273, 275, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(274, 276, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(275, 277, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(276, 278, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(277, 279, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(278, 280, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(279, 281, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(280, 282, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(281, 283, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(282, 284, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(283, 285, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(284, 286, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(285, 287, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(286, 288, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(287, 289, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(288, 290, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(289, 291, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(290, 292, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(291, 293, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(292, 294, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(293, 295, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(294, 297, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(295, 298, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(296, 299, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(297, 300, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(298, 301, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(299, 302, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(300, 303, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(301, 304, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(302, 305, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(303, 306, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(304, 307, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(305, 308, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(306, 309, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(307, 310, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(308, 311, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(309, 312, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(310, 313, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(311, 314, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(312, 315, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(313, 316, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(314, 317, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(315, 318, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(316, 319, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(317, 320, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(318, 321, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(319, 322, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(320, 323, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(321, 324, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(322, 325, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(323, 326, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(324, 327, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(325, 328, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(326, 329, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(327, 330, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(328, 331, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(329, 332, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(330, 333, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(331, 334, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(332, 335, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(333, 336, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(334, 337, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(335, 338, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(336, 339, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(337, 340, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(338, 341, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(339, 342, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(340, 343, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(341, 344, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(342, 345, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(343, 61, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(344, 78, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54'),
(345, 296, NULL, '2024-06-30', NULL, '2024-03-17 18:59:54');

-- --------------------------------------------------------

--
-- Table structure for table `monthly_pay_rolls`
--

CREATE TABLE `monthly_pay_rolls` (
  `monthly_pay_roll_id` int UNSIGNED NOT NULL,
  `official_id` int NOT NULL DEFAULT '0',
  `month` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `monthly_pay` float NOT NULL DEFAULT '0',
  `arrears` int NOT NULL DEFAULT '0',
  `over_time` int NOT NULL DEFAULT '0',
  `income_tax` int NOT NULL DEFAULT '0',
  `union_fund` int NOT NULL DEFAULT '0',
  `recovery` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `absentees` int NOT NULL DEFAULT '0',
  `gross_pay` int NOT NULL DEFAULT '0',
  `deductions` int NOT NULL DEFAULT '0',
  `net_salary` int NOT NULL DEFAULT '0',
  `remarks` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `absentees_amount` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `officials`
--

CREATE TABLE `officials` (
  `official_id` int UNSIGNED NOT NULL,
  `file_no` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `official_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `father_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `date_of_birth` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `domicile` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cnic` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `contact` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `appointment_date` varchar(50) DEFAULT NULL,
  `designation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `directorate` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `chargeable_head` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `monthly_pay` float DEFAULT NULL,
  `income_tax_applied` tinyint NOT NULL DEFAULT '0',
  `status` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_salary_blocked` tinyint NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `officials`
--

INSERT INTO `officials` (`official_id`, `file_no`, `official_name`, `father_name`, `date_of_birth`, `domicile`, `cnic`, `address`, `contact`, `appointment_date`, `designation`, `directorate`, `chargeable_head`, `monthly_pay`, `income_tax_applied`, `status`, `is_salary_blocked`, `created_at`) VALUES
(1, '1-05-08/3312', 'Afaq Ahmad', 'Sajjad Ali', NULL, NULL, '   ', NULL, NULL, NULL, 'Supervisor', 'ADG (Hort)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(2, '1-05-08/3571', 'Abdullah', 'Shamsher Mehmood', NULL, NULL, '11101-8836113-9', NULL, NULL, NULL, 'Asst Supervisor', 'D (Engg: Roads)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(3, '1-05-08/3574', 'Amjid Nawaz', 'Noor Nawaz', NULL, NULL, '111101-8591135-7', NULL, NULL, NULL, 'TWO', 'D(W&S)', 'Maintenance of Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(4, '1-05-08/3278', 'Samar Gul', 'Gul Zaman', NULL, NULL, '11201-0389226-7', NULL, NULL, NULL, 'Helper', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(5, '1-05-08/2309', 'Habib ur Rehman', 'Hasti Khan', NULL, NULL, '11201-5391143-1', NULL, NULL, NULL, 'Chowkidar', 'DG Secretariat', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(6, '1-05-08/3180', 'Zakir Ullah', 'Aziz Ullah Khan', NULL, NULL, '11201-5963209-7', NULL, NULL, NULL, 'Mate', 'D (Engg: Roads)', 'Peshawar Uplift Program', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(7, '', 'Ali Sher Khan', '', NULL, NULL, '13302-0633845-9', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 52213, 0, NULL, 0, '2024-03-17 18:58:30'),
(8, '1-05-08/2302', 'Muhammad Ishaq', 'Pir Badshah', NULL, NULL, '14202-7215429-3', NULL, NULL, NULL, 'Surveyor', 'D (Engg: Roads)', 'Internal Roads Rehabilitation in Peshawar City', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(9, '1-05-08/1939', 'Muhammad Afan', 'Khalid Khan', NULL, NULL, '14301-2318787-7', NULL, NULL, NULL, 'Assistant Supervisor', 'D(Finance)', 'Maintenance of (Hort) N-5/ G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(10, '1-05-08/3095', 'Badshah Mir ', 'Janab Shah', NULL, NULL, '14301-4001352-9', NULL, NULL, NULL, 'Tractor Driver', 'D(W&S)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(11, '1-05-08/3065', 'Shakir Ullah ', 'Salah Ud Din', NULL, NULL, '14301-5611312-3', NULL, NULL, NULL, 'Electrician', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(12, '1-05-08/3476', 'Afzal Khan', 'Zanuyar Khan', NULL, NULL, '15202-5665435-1', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of G.T/Jamrud Road (Self Finance/PDA Funded)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(13, '1-05-08/2255', 'Hazir Mohammad', 'Inzar Gul', NULL, NULL, '15302-8043357-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(14, '1-05-08/3221', 'Usman Khan', 'Bahdar Said', NULL, NULL, '15401-9686395-7', NULL, NULL, NULL, 'Supervisor (Electrical)', 'D (Electrical)', 'Maintenance of Street Lights', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(15, '1-05-08/3274', 'Shabir Ahmad', 'Muhammad Ibrahim', NULL, NULL, '15402-1415279-9', NULL, NULL, NULL, 'Supervisor', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(16, '1-05-08/3338', 'Faisal Nabi', 'Fazal Nabi', NULL, NULL, '15402-2435973-3', NULL, NULL, NULL, 'Supervisor', 'D (Engg: Roads)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(17, '1-05-08/3203', 'Sameer Hadi ', 'Fazal Hadi Sabir', NULL, NULL, '15402-3030316-1', NULL, NULL, NULL, 'Supervisor (Electrical)', 'D (Electrical)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(18, '1-05-08/3250', 'Asghar Khan', 'Fazal Rahman', NULL, NULL, '15402-4656045-7', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(19, '1-05-08/3339', 'Farhan Ullah', 'Fazal Ullah', NULL, NULL, '15402-8593892-7', NULL, NULL, NULL, 'Supervisor', 'D (Engg: Roads)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(20, '1-05-08/3153', 'Aizaz Babar', 'Fazle Ghafar', NULL, NULL, '15402-9672579-5', NULL, NULL, NULL, 'Supervisor', 'D (Engg: Roads)', 'Maintenance of (W&S)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(21, '1-05-08/3578', 'Ghulam Muhmmad ', 'Fazal Ahad', NULL, NULL, '15601-8435526-3', NULL, NULL, NULL, 'Asstt; Buldind Inspt;', 'D(BCA) RMT', 'Maintenance of W&S: HST', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(22, '', 'Asad Ullah Yousafzai', 'Shoukat Ali', NULL, NULL, '15602-2624321-3', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 35600, 0, NULL, 0, '2024-03-17 18:58:30'),
(23, '1-05-08/3331', 'Sardar Ali', 'Jahan Bar', NULL, NULL, '15602-7174259-3', NULL, NULL, NULL, 'Pesh Imam', 'D (Eng RMT)', 'RMT', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(24, '', 'Barrister Waqar Ali Khan', 'Farzand Ali', NULL, NULL, '15606-1082047-5', NULL, NULL, NULL, 'Chief SLC', 'Legal Section', 'Law Charges', 356000, 0, NULL, 0, '2024-03-17 18:58:30'),
(25, '1-05-08/3600', 'Fazal Amin', 'Rooh ul Amin', NULL, NULL, '15702-3841114-9', NULL, NULL, NULL, 'Assistant Supervisor', 'ADG (Hort)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(26, '1-05-08/3573', 'Tayyab', 'Habib Ur Rehman ', NULL, NULL, '16101-1120291-1', NULL, NULL, NULL, 'Asst Supervisor', 'D(BCA) RMT', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(27, '1-05-08/3365', 'Sharafat Ullah', 'Niamat Ullah', NULL, NULL, '16101-1223514-1', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(28, '1-05-08/3130', 'Yasir Ali Shah', 'Aleem Shah', NULL, NULL, '16101-1844766-1', NULL, NULL, NULL, 'Tractor Driver', 'D(Machinery) ', 'Maintenance of (Machinary)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(29, '1-05-08/3420', 'Haider Khan', 'Gul Dad Khan', NULL, NULL, '16101-4562485-9', NULL, NULL, NULL, 'Chowkidar', 'D(Admin)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(30, '1-05-08/3298', 'Fawad Akbar', 'Ghulam Akbar', NULL, NULL, '16101-8658908-7', NULL, NULL, NULL, 'Supervisor', 'D(E.M)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(31, '1-05-08/2277', 'Jehangir Khan', 'Said Afzal', NULL, NULL, '16101-8814390-3', NULL, NULL, NULL, 'Tractor Driver', 'D(Machinery) ', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(32, '1-05-08/2048', 'Muhammad Shabir', 'Sazan Khan', NULL, NULL, '16101-9719911-9', NULL, NULL, NULL, 'Supervisor', 'D(Coord:) PIU BRT', 'Beautification of Peshawar.', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(33, '1-05-08/2058', 'Ali Akbar', 'Akbar Khan', NULL, NULL, '16102-0719576-1', NULL, NULL, NULL, 'Supervisor', 'D(Reach-II BRT)', 'Pir Zakori Flyover Level-II', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(34, '1-05-08/3071', 'Farman Ullah', 'Hameed Ullah', NULL, NULL, '16102-1613334-1', NULL, NULL, NULL, 'Tractor Driver', 'D (Engg: Roads)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(35, '', 'Muhamad Faheem Anwar', 'Muhamad Fayaz Anwar', NULL, NULL, '16102-7449695-5', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 31150, 0, NULL, 0, '2024-03-17 18:58:30'),
(36, '', 'Haris Iqbal', 'Muhammad Iqbal', NULL, NULL, '16102-7941321-3', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 53400, 0, NULL, 0, '2024-03-17 18:58:30'),
(37, '', 'Miss Anila Faryal', 'Tila Muhammad', NULL, NULL, '16102-8573326-2', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 35600, 0, NULL, 0, '2024-03-17 18:58:30'),
(38, '', 'Rab Nawaz Khan', 'Ayub Khan', NULL, NULL, '16201-0714000-5', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 71200, 0, NULL, 0, '2024-03-17 18:58:30'),
(39, '', 'Fazli Mehmood', 'Haji Muhammad Khan', NULL, NULL, '16202-0247309-5', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 66453, 0, NULL, 0, '2024-03-17 18:58:30'),
(40, '1-05-08/3187', 'Syed Kamran Mukhtiar', 'Mukhtiar Ali', NULL, NULL, '16202-2140939-7', NULL, NULL, NULL, 'Supervisor', 'D(E.M)', 'Recovery Cell (E.M)', 30000, 0, NULL, 0, '2024-03-17 18:58:30'),
(41, '1-05-08/', 'Muhammad Saeed', 'Sher Afsar', NULL, NULL, '16202-3473698-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Hazar Khawani Park', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(42, '1-05-08/', 'Amad Ali', 'Shoukat Ali', NULL, NULL, '16202-679375-1', NULL, NULL, NULL, 'Survey Supervisor', 'ADG (Hort)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(43, '1-05-08/1977', 'Iftikhar Khan', 'Haider Khan', NULL, NULL, '16202-7714167-7', NULL, NULL, NULL, 'Driver', 'D(Machinery) ', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(44, '1-05-08/3440', 'Muhammad Aamir', 'Amjad Ali', NULL, NULL, '16203-0352819-1', NULL, NULL, NULL, 'Supervisor', 'D (Engg: Roads)', 'Maintenance of N-5/G.T/Jamrud Road', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(45, '1-05-08/3025', 'Farooq Khan', 'Khan Muhammad', NULL, NULL, '16204-0371635-5', NULL, NULL, NULL, 'Driver', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(46, '1-05-08/3193', 'Tariq Aslam', 'Noor Zaman', NULL, NULL, '16204-0400784-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(47, '1-05-08/', 'Muhammad Arif', 'Ghareeb Khan', NULL, NULL, '16204-0409584-7', NULL, NULL, NULL, 'Elect Helper', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(48, '1-05-08/3198', 'Ali Akbar', 'Samar Gul', NULL, NULL, '17101-0257459-9', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(49, '1-05-08/', 'Khalil Ullah', 'Muazzam Khan', NULL, NULL, '17101-0349921-7', NULL, NULL, NULL, 'Helper', 'ADG (Hort)', 'Peshawar Uplift', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(50, '1-05-08/2274', 'Arshad Ayub', 'Muhammad Ayub', NULL, NULL, '17101-0372137-5', NULL, NULL, NULL, 'Tractor Driver', 'D(W&S)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(51, '1-05-08/2984', 'Amir Khan', 'Noor Muh: Shah', NULL, NULL, '17101-0384331-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(52, '1-05-08/2293', 'Khan Sher', 'Mehruban Shah', NULL, NULL, '17101-0402048-9', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(53, '1-05-08/3282', 'Jehangir Khan', 'Karim Shah', NULL, NULL, '17101-0412676-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(54, '1-05-08/3587', 'Asim Hussain', 'Hussain Shah', NULL, NULL, '17101-0613951-3', NULL, NULL, NULL, 'Supervisor', 'D(Vigilance)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(55, '1-05-08/3219', 'Wajid Ali', 'Niaz Ali', NULL, NULL, '17101-1134911-7', NULL, NULL, NULL, 'Drain Cleaner', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(56, '1-05-08/', 'Muhammad Usman', 'Badshah Gul', NULL, NULL, '17101-2338155-1', NULL, NULL, NULL, 'Forest Guard', 'ADG (Hort)', 'Peshawar Uplift', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(57, '1-05-08/3205', 'Muhammad Mustafa', 'Muhammad Zahir', NULL, NULL, '17101-2368756-7', NULL, NULL, NULL, 'Supervisor', 'ADG (Hort)', 'Uplift & Beautification of Nowshera', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(58, '1-05-08/3478', 'Gul Muhammad', 'Niaz Muhammad', NULL, NULL, '17101-2535827-7', NULL, NULL, NULL, 'Assistant Supervisor', 'ADG (Hort)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(59, '1-05-08/3370', 'Waheed Ullah', 'Zakir Ullah', NULL, NULL, '17101-2807152-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(60, '1-05-08/3010', 'Qayas Khan', 'Mafad Khan', NULL, NULL, '17101-3283210-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'N-5/G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(61, '1-05-08/', 'Qiyas Khan', 'Mafad Khan', NULL, NULL, 'null-wrong-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/ G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(62, '1-05-08/3260', 'Shah Faisal', 'Tawas Khan', NULL, NULL, '17101-4059136-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/ G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(63, '1-05-08/3306', 'Fawad Ali', 'Fazli Rabi', NULL, NULL, '17101-4706498-5', NULL, NULL, NULL, 'Assistant Supervisor', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(64, '1-05-08/3414', 'Mujahid', 'Misal Khan', NULL, NULL, '17101-5028109-1', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of G.T/Jamrud Road (Self Finance/PDA Funded)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(65, '1-05-08/3093', 'Asad Ullah', 'Maaz Ullah', NULL, NULL, '17101-5159316-5', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(66, '1-05-08/2260', 'Dawood Khan', 'Mir Zaman', NULL, NULL, '17101-5360013-9', NULL, NULL, NULL, 'Mate', 'D(NPV)', 'Internal Roads Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(67, '1-05-08/', 'Shakeel Riaz', 'Mahmood Khan', NULL, NULL, '17101-6115697-9', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(68, '1-05-08/3101', 'Farman Ullah', 'Asmat Ullah Khan', NULL, NULL, '17101-6691319-7', NULL, NULL, NULL, 'Cleaner', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(69, '1-05-08/3254', 'Hasnain Khan', 'Muhammad Jamil', NULL, NULL, '17101-7010515-1', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(70, '1-05-08/2531', 'Syed Ahmad Javed', 'Syed Agha Gul', NULL, NULL, '17101-7048281-1', NULL, NULL, NULL, 'Chowkidar', 'D (Buildings)', 'Repair & Maintenance of Roads (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(71, '1-05-08/3169', 'Zahid Shah', 'Hidayat Shah', NULL, NULL, '17101-7295686-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort:) N-5/G.T/Jamrud Road', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(72, '1-05-08/3045', 'Maqsood Ullah', 'Sharif Gul', NULL, NULL, '17101-7632025-9', NULL, NULL, NULL, 'Asst Supervisor', 'D(Finance)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(73, '1-05-08/3151', 'Sher Muhammad ', 'Mir Adam Khan', NULL, NULL, '17101-7672572-3', NULL, NULL, NULL, 'Electrician Helper', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(74, '1-05-08/3417', 'Aurangzaib', 'Musammar Shah', NULL, NULL, '17101-7748861-5', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of G.T/Jamrud Road (Self Finance/PDA Funded)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(75, '1-05-08/3244', 'Siraj Gul', 'Nifa Gul', NULL, NULL, '17101-8536451-7', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinary)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(76, '1-05-08/1257', 'Sana Ullah Karim', 'Hazrat Karim', NULL, NULL, '17101-9895010-7', NULL, NULL, NULL, 'Survey Helper', 'D (Engg: Roads)', 'Maintenance of G.T/Jamrud/N-5 Road Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(77, '1-05-08/3161', 'Asmat Jan', 'Saif ur Rehman', NULL, NULL, '17102-1150513-3', NULL, NULL, NULL, 'Sanitory Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(78, '1-05-08/3405', 'Ihsan Ullah', 'Rehmat Said', NULL, NULL, 'null-wrong-2', NULL, NULL, NULL, 'Pipe Fitter', 'D(Vigilance)', 'Maintenance of (W&S HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(79, '1-05-08/3405', 'Ihsan Ullah', 'Rehmat Said', NULL, NULL, '17102-3843345-5', NULL, NULL, NULL, 'Pipe Fitter', 'D(W&S)', 'Water supplly', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(80, '1-05-08/3480', 'Haseen Ullah', 'Aziz Ullah', NULL, NULL, '17102-7062169-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Hazar Khwani Park', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(81, '1-05-08/', 'Asfandyar Wali Khan', 'Wali Muhammad', NULL, NULL, '17102-8286211-9', NULL, NULL, NULL, 'Supervisor', 'D(NPV)', 'New Peshawar Valley', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(82, '1-05-08/', 'Abdul Ahad', 'Muhammad Shafi', NULL, NULL, '17102-8360641-3', NULL, NULL, NULL, 'Assistant Supervisor', 'D(Admin)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(83, '1-05-08/3090', 'Imran Khan', 'Umar Said', NULL, NULL, '17102-8461469-5', NULL, NULL, NULL, 'Tractor Driver', 'D(Vigilance)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(84, '1-05-08/2219', 'Abida Bibi', 'W/o Ali Gul', NULL, NULL, '17102-8526909-8', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(85, '1-05-08/', 'Sartaj', 'Sher Ali Khan', NULL, NULL, '17201-0354128-9', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(86, '1-05-08/', 'Muhammad Naseem', 'Fazle Habib', NULL, NULL, '17201-0365647-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(87, '1-05-08/', 'Lateef Ullah', 'Shamas', NULL, NULL, '17201-0993135-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Uplift & Beautification of Nowshera (Pabbi to Jehangira)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(88, '1-05-08/', 'Munsif Khan', 'Mian Khan', NULL, NULL, '17201-1114971-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(89, '1-05-08/2256', 'Riaz ud Din', 'Usman ud Din', NULL, NULL, '17201-2103499-5', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(90, '1-05-08/', 'Izat Khan', 'Wali Khan', NULL, NULL, '17201-2135571-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Uplift & Beautification of Nowshera (Pabbi to Jehangira)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(91, '1-05-08/1815', 'Imran', 'Jehangir Khan', NULL, NULL, '17201-2166980-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/ G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(92, '1-05-08/3087', 'Atta Ullah', 'Momen Khan', NULL, NULL, '17201-2205453-1', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:30'),
(93, '1-05-08/3529', 'Sajid ullah', 'Khista gul', NULL, NULL, '17201-2795732-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Uplift & Beautification of Nowshera (Pabbi to Jehangira)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(94, '1-05-08/2282', 'Mazhar Ullah', 'Zafar Ullah', NULL, NULL, '17201-2936771-7', NULL, NULL, NULL, 'Helper', 'D(E.M)', 'Recovery Cell', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(95, '1-05-08/3310', 'Muhammad Ibrahim Khattak', 'Farooq khattaq', NULL, NULL, '17201-3599516-1', NULL, NULL, NULL, 'Supervisor Electrical', 'D (Electrical)', 'Installation of LED Urban Roads Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(96, '1-05-08/2158', 'Mumtaz Khan', 'Lakhkar Khan', NULL, NULL, '17201-3820833-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of G.T/Jamrud Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(97, '1-05-08/', 'Nasir Khan', 'Shah Afzal', NULL, NULL, '17201-3892386-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(98, '1-05-08/', 'Atta Ullah', 'Ameen Ullah', NULL, NULL, '17201-3994344-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(99, '1-05-08/3489', 'Atif Raza ', 'Gohar Ali', NULL, NULL, '17201-4235471-7', NULL, NULL, NULL, 'Supervisor', 'ADG (Hort)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(100, '1-05-08/', 'Wakeel Nawaz', 'Muhammad Ayub', NULL, NULL, '17201-5219330-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(101, '1-05-08/', 'Khan Zeb', 'Sufaid Gul', NULL, NULL, '17201-5427003-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(102, '1-05-08/', 'Taif Shah', 'Ihsan Ullah', NULL, NULL, '17201-6411644-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maint of Hort N-5 GT Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(103, '1-05-08/1814', 'Fawad', 'Jehanzaib Khan', NULL, NULL, '17201-6868432-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/ G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(104, '1-05-08/', 'Fazli Malik', 'Fazle Habib', NULL, NULL, '17201-7124912-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Uplift & Beautification of Nowshera', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(105, '1-05-08/2257', 'Ibraheem Gul', 'Anar Gul', NULL, NULL, '17201-7407567-5', NULL, NULL, NULL, 'Helper', 'D(E.M)', 'Recovery Cell', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(106, '1-05-08/', 'Saeed Khan', 'Ghulam Sadeeq', NULL, NULL, '17201-8031188-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maint of Hort N-5 GT Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(107, '1-05-08/', 'Rab Nawaz', 'Khaliq Dad', NULL, NULL, '17201-8273990-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(108, '1-05-08/', 'Hazrat Ali', 'Sardar Ali', NULL, NULL, '17201-8606422-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(109, '1-05-08/', 'Fayaz Ali Khan', 'Abdul Satar', NULL, NULL, '17201-9396371-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(110, '1-05-08/', 'Umar Daraz', 'Umar Farooq', NULL, NULL, '17201-9968290-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(111, '1-05-08/', 'Jalal Ahmad', 'Ghulam Nabi', NULL, NULL, '17202-0344603-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(112, '1-05-08/', 'Touseef Jehan', 'Nabi Gul', NULL, NULL, '17202-0348796-9', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(113, '1-05-08/', 'Muhammad Tahir', 'Sher Muhammad ', NULL, NULL, '17202-0348903-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(114, '1-05-08/2161', 'Muhammad Kamran', 'Ali Akbar', NULL, NULL, '17202-0349763-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/ G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(115, '1-05-08/', 'Abdul Saeed', 'Abdul Salam', NULL, NULL, '17202-0351777-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(116, '1-05-08/', 'Waqas Khan', 'Gul Khan', NULL, NULL, '17202-0362254-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(117, '1-05-08/', 'Sadat Khan', 'Bakhtiar Ullah', NULL, NULL, '17202-0365356-9', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Horticulture', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(118, '1-05-08/2996', 'Faiz Ullah', 'Rooh Ullah', NULL, NULL, '17202-0392305-9', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(119, '1-05-08/3508', 'Arshad', 'Abdul Habib', NULL, NULL, '17301-0161136-1', NULL, NULL, NULL, 'F.G', 'ADG (Hort)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(120, '1-05-08/2294', 'Mohammad Kamran Khan', 'Khial Gul', NULL, NULL, '17301-0373043-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(121, '1-05-08/3012', 'Mujeeb ur Rehman', 'Said Rehman', NULL, NULL, '17301-0412328-3', NULL, NULL, NULL, 'Chowkidar', 'D (Buildings)', 'Maintenance of (Hort:) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(122, '1-05-08/3292', 'Saif ur Rehman', 'Mir Ali', NULL, NULL, '17301-0434887-1', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(123, '', 'Ansab Abdullah', 'Muhammad Faheem', NULL, NULL, '17301-0471169-1', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 35600, 0, NULL, 0, '2024-03-17 18:58:31'),
(124, '1-05-08/3267', 'Adnan Khan', 'Sher Akber', NULL, NULL, '17301-0575504-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(125, '1-05-08/3018', 'Irfan Khan', 'Abdul Said', NULL, NULL, '17301-0604641-7', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(126, '1-05-08/3404', 'Muhammad Imran Khan', 'Ashraf Khan', NULL, NULL, '17301-0625706-3', NULL, NULL, NULL, 'Pesh Imam', 'D(Admin)', 'Maintenance of G.T/Jamrud Road (Self Finance/PDA Funded)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(127, '1-05-08/3144', 'Saleem ', 'Sabir Khan', NULL, NULL, '17301-0648350-3', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(128, '1-05-08/3521', 'Muhammad Imran', 'Mumtaz Hussain', NULL, NULL, '17301-0665643-3', NULL, NULL, NULL, 'Forest Guard', 'ADG (Hort)', 'Peshawar Uplift', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(129, '1-05-08/', 'Sajawal Sajjad', 'Sajjad Ahmad', NULL, NULL, '17301-0680812-5', NULL, NULL, NULL, 'Assistant Supervisor', 'D(Admin)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(130, '1-05-08/', 'Shah Rukh Khan', 'M Naeem Khan', NULL, NULL, '17301-06995295-5', NULL, NULL, NULL, 'Asst-Super', 'D (Engg: Roads)', 'Maintenance of N-5/G.T/Jamrud Road (Self Finance/PDA Funded)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(131, '1-05-08/2034', 'Muhammad Shahid', 'Sher Dad Khan', NULL, NULL, '17301-0729222-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/ G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(132, '1-05-08/3466', 'Ahsan Ayaz', 'Banat Gul', NULL, NULL, '17301-0869572-1', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(133, '1-05-08/3601', 'Naeem Khan', 'Amin Khan', NULL, NULL, '17301-0926670-7', NULL, NULL, NULL, 'TWO', 'ADG (Hort)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(134, '1-05-08/3273', 'Sajjad Ahmad', 'Pervez Ahmad', NULL, NULL, '17301-0938639-3', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(135, '1-05-08/', 'Sajjad Ullah', 'Janas Khan', NULL, NULL, '17301-0954756-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', '\"Maintenance of (Hort:)/N-5', 0, 0, NULL, 0, '2024-03-17 18:58:31'),
(136, '1-05-08/3222', 'Imran Khan', 'Usman Khan', NULL, NULL, '17301-1094091-9', NULL, NULL, NULL, 'Driver', 'D(NPV)', 'Maintenance of (Machinary)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(137, '1-05-08/3366', 'Nouman', 'Salah Ud Din', NULL, NULL, '17301-1104127-5', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(138, '1-05-08/3394', 'Saran Javed', 'Javed Masih', NULL, NULL, '17301-1105057-1', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(139, '1-05-08/3353', 'Haider Ali', 'Misri Khan', NULL, NULL, '17301-1151142-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(140, '1-05-08/3368', 'Abdul Wahab', 'Sardar Ali', NULL, NULL, '17301-1314545-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(141, '1-05-08/3411', 'Malik Ismail Shahid', 'Malik Fazal Qadir', NULL, NULL, '17301-1384236-3', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of N-5/G.T/Jamrud Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(142, '1-05-08/', 'Tahira Yasmeen', 'Abdul Karim Hashmi', NULL, NULL, '17301-139425-8', NULL, NULL, NULL, 'Consultant ', 'D(Admin)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(143, '1-05-08/3389', 'Intikhab Khan ', 'Mustafa Khan', NULL, NULL, '17301-1402333-9', NULL, NULL, NULL, 'Supervisor', 'D (Engg: Roads)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(144, '1-05-08/3359', 'Aftab Alam', 'Sher Alam', NULL, NULL, '17301-1404925-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(145, '', 'Muhammad Tariq Javed', 'M. Sadiq javed', NULL, NULL, '17301-1423266-5', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 89000, 0, NULL, 0, '2024-03-17 18:58:31'),
(146, '1-05-08/3283', 'Yasir Khan', 'Ajmal Khan', NULL, NULL, '17301-1464112-5', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(147, '', 'Muhammad Intikhab Khan', 'Iftikhar ud Din Khan', NULL, NULL, '17301-1549795-7', NULL, NULL, NULL, 'S.L.C', 'Legal Section', 'Law Charges', 35600, 0, NULL, 0, '2024-03-17 18:58:31'),
(148, '1-05-08/3388', 'Hafiz Murad Ali', 'Said Farosh Khan', NULL, NULL, '17301-1567987-3', NULL, NULL, NULL, 'Tractor Driver', 'D(Admin)', 'Maintenance of (Machinary)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(149, '1-05-08/3255', 'Alamzaib Khan', 'Jehanzaib Khan', NULL, NULL, '17301-1579074-3', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(150, '1-05-08/3357', 'Malik Wajid Khan', 'Malik Haya Khan', NULL, NULL, '17301-1597731-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(151, '1-05-08/2465', 'Inayat ullah ', 'Rokhan', NULL, NULL, '17301-1609451-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(152, '1-05-08/3459', 'Said Muhammad', 'Muhammad Khan', NULL, NULL, '17301-1632339-5', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(153, '1-05-08/3097', 'Gul Taj Khan', 'Gul Dast', NULL, NULL, '17301-1669367-1', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(154, '1-05-08/3289', 'Rehmatullah', 'Taza Gul', NULL, NULL, '17301-1679082-5', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(155, '', 'Saif Ullah Momand', 'Awal Khan', NULL, NULL, '17301-1743796-1', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 17799, 0, NULL, 0, '2024-03-17 18:58:31'),
(156, '1-05-08/', 'Muhammad Faheem', 'Muhammad Rafiq', NULL, NULL, '17301-1786379-5', NULL, NULL, NULL, 'Financial Advisor', 'D(Admin)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(157, '1-05-08/2645', 'Umar Farooq', 'Fazal Subhan', NULL, NULL, '17301-1816625-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(158, '1-05-08/', 'Bakhtair Ali', 'Shahzada', NULL, NULL, '17301-1860835-7', NULL, NULL, NULL, 'Consultant / Advisor', 'D(Admin)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(159, '1-05-08/2343', 'Sadiq Hussain', 'Wahid Gul', NULL, NULL, '17301-1884866-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(160, '1-05-08/3362', 'Shah Faisal', 'Niaz Ali Khan', NULL, NULL, '17301-2057931-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(161, '1-05-08/3496', 'Abid Ali', 'Akhtar Ali', NULL, NULL, '17301-2080471-3', NULL, NULL, NULL, 'TWO', 'D(W&S)', 'Maintenance of Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(162, '1-05-08/3321', 'Shakeel Khan', 'Ayaz Khan', NULL, NULL, '17301-2258033-3', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Maintenance of Hort: HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(163, '1-05-08/2278', 'Ezat Khan', 'Noor Ul Husain', NULL, NULL, '17301-2318585-1', NULL, NULL, NULL, 'Tractor Driver', 'D(W&S)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(164, '1-05-08/3358', 'Ghufran Khan', 'Ameer Zada', NULL, NULL, '17301-2327562-1', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(165, '1-05-08/3604', 'Naveed Khan', 'Zahid Khan', NULL, NULL, '17301-2403046-9', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(166, '1-05-08/', 'Zohaib Hassan ', 'Darwaish Khan', NULL, NULL, '17301-2406684-7', NULL, NULL, NULL, 'Driver', 'D(NPV)', '', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(167, '1-05-08/3475', 'Rafi Shah', 'Ashraf Ud Din', NULL, NULL, '17301-2429588-7', NULL, NULL, NULL, 'Forest Guard', 'D(Vigilance)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(168, '1-05-08/3158', 'Muhammad Amir Khan ', 'Muhammad Qayyum ', NULL, NULL, '17301-2477589-7', NULL, NULL, NULL, 'Electrician Helper', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(169, '1-05-08/3281', 'Gul Rasool', 'Noor Zada', NULL, NULL, '17301-2486057-3', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(170, '1-05-08/3256', 'Haji Gul', 'Abdur Rauf', NULL, NULL, '17301-2547202-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(171, '1-05-08/3463', 'Jamil Ahmad', 'Qlandar Khan', NULL, NULL, '17301-2561105-1', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(172, '1-05-08/3464', 'Muhammad Ajmal Khan', 'Muhammad Javed Khalil', NULL, NULL, '17301-2658781-9', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(173, '1-05-08/2279', 'Gul Afzal', 'Sher Afzal', NULL, NULL, '17301-2663442-9', NULL, NULL, NULL, 'Tractor Driver', 'D(W&S)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(174, '', 'Miss Rabia Gul', 'Sher Akbar', NULL, NULL, '17301-2760122-8', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 44500, 0, NULL, 0, '2024-03-17 18:58:31'),
(175, '1-05-08/3396', 'Pir Muhammad Saddam', 'Pir Fida Muhammad', NULL, NULL, '17301-2763900-1', NULL, NULL, NULL, 'Assistant', 'D(Admin)', 'Head Office', 40000, 0, NULL, 0, '2024-03-17 18:58:31'),
(176, '1-05-08/3605', 'Musa Khan', 'Nawab Khan', NULL, NULL, '17301-2865470-7', NULL, NULL, NULL, 'Naib Qasid', 'D(I.T)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(177, '1-05-08/2208', 'Shafiq Hussain', 'Shoukat Hussain', NULL, NULL, '17301-2879725-5', NULL, NULL, NULL, 'Supervisor', 'D(Admin)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(178, '1-05-08/2221', 'Rooh Ul Amin', 'Liaqat Ali', NULL, NULL, '17301-2887843-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(179, '1-05-08/2078', 'Muhammad Haris', 'Nisar Muhammad ', NULL, NULL, '17301-2893721-5', NULL, NULL, NULL, 'Supervisor', 'D (Engg: Roads)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(180, '1-05-08/2520', 'Zeeshan Mumraiz', 'Mumriaz Khan', NULL, NULL, '17301-2904848-7', NULL, NULL, NULL, 'Supervisor', 'D (Buildings)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(181, '1-05-08/', 'Shakir Khan', 'Israyeel ', NULL, NULL, '17301-2960316-9', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort:) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(182, '1-5-8/3284', 'Haroon akram', 'Akram Gulzar', NULL, NULL, '17301-3029542-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(183, '1-05-08/3391', 'Hilal Haider', 'Muhammad Yousaf', NULL, NULL, '17301-3044364-1', NULL, NULL, NULL, 'Assistant Supervisor', 'ADG (Hort)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(184, '1-05-08/3277', 'Salah Ud Din', 'Ghulam Mohi Uddin', NULL, NULL, '17301-3120710-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(185, '1-05-08/', 'Azam Khan', 'Akbar Khan', NULL, NULL, '17301-3145422-7', NULL, NULL, NULL, 'Asst Supervisor', 'D (Electrical)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(186, '1-05-08/3111', 'Arshad Masih', 'Niamat Masih', NULL, NULL, '17301-3190569-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(187, '1-05-08/3354', 'Kashif Ullah', 'Fareed Ullah', NULL, NULL, '17301-3277915-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(188, '1-05-08/3252', 'Anwar Ali', 'Daulat Khan', NULL, NULL, '17301-3282495-1', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(189, '1-05-08/2328', 'Syed Awais Ali Shah', 'Syed Qabil Shah', NULL, NULL, '17301-3353505-3', NULL, NULL, NULL, 'Mali', 'D(Machinery)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(190, '1-05-08/3112', 'Din Muhammad', 'Ziwar Din', NULL, NULL, '17301-3521014-1', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(191, '1-05-08/3603', 'Syed Maseed us Salam', 'Abdul Satar Shah', NULL, NULL, '17301-35414589', NULL, NULL, NULL, 'Naib Qasid', 'ADG (Hort)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(192, '1-05-08/3208', 'Abdullah Javed', 'Javed Hayat', NULL, NULL, '17301-3591801-5', NULL, NULL, NULL, 'Supervisor', 'ADG (Hort)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(193, '1-05-08/', 'Inam Ullah', 'Bostan Ali', NULL, NULL, '17301-3633794-1', NULL, NULL, NULL, 'Survey Helper', 'D(Admin)', 'Head office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(194, '1-05-08/3294', 'Ahmad Khan', 'Shamshad', NULL, NULL, '17301-3722486-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(195, '1-05-08/2212', 'Farman Ullah', 'Saif ur Rehman', NULL, NULL, '17301-3746461-9', NULL, NULL, NULL, 'Tractor Driver', 'D(Machinery) ', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(196, '1-05-08/2997', 'Ihsan ullah', 'Mah Munir', NULL, NULL, '17301-3829851-1', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(197, '1-05-08/3350', 'Aurangzaib', 'Rehman Gul', NULL, NULL, '17301-3844451-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(198, '1-05-08/3513', 'Shoukat Ali', 'Gulab Sher', NULL, NULL, '17301-3904560-5', NULL, NULL, NULL, 'Forest Guard', 'ADG (Hort)', 'Peshawar Uplift', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(199, '1-05-08/3253', 'Uzma Bibi', 'Shah Nawaz', NULL, NULL, '17301-4030271-8', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(200, '1-05-08/3324', 'Muhammad Amir', 'Fazal Manan', NULL, NULL, '17301-4152318-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort: HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(201, '1-05-08/3220', 'Naveed ullah', 'Alam Khan', NULL, NULL, '17301-4305930-3', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(202, '1-05-08/', 'Muhammad Hamza', 'Imam Shah', NULL, NULL, '17301-4417844-9', NULL, NULL, NULL, 'Helper', 'D(Admin)', 'New Peshawar Valley', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(203, '1-05-08/3519', 'Imran Khan', 'Abdullah Khan', NULL, NULL, '17301-4424632-3', NULL, NULL, NULL, 'Forest Guard', 'ADG (Hort)', 'Peshawar Uplift', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(204, '', 'Muhammad Arif', 'Firdus Gul', NULL, NULL, '17301-4429680-5', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 40050, 0, NULL, 0, '2024-03-17 18:58:31'),
(205, '1-05-08/', 'Muhammad Zaman', 'Khan Badshah', NULL, NULL, '17301-4438354-7', NULL, NULL, NULL, 'Revenue Consultant ', 'LAC', 'New Peshawar Vally', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(206, '1-05-08/3485', 'Abdul Haseeb', 'Ashfaq Nadeem', NULL, NULL, '17301-4484222-1', NULL, NULL, NULL, 'Helper', 'D(Admin)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(207, '1-05-08/3361', 'Hameed Ullah', 'Kiramat Ullah Khan', NULL, NULL, '17301-4516638-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(208, '1-05-08/2190', 'Muhammad Jawad', 'Jamshed Parvez', NULL, NULL, '17301-4568378-3', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(209, '1-05-08/3217', 'Noor ullah', 'Jahanzeb Khan', NULL, NULL, '17301-4572963-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(210, '1-05-08/3316', 'Asif Khan', 'Shehzada Khan', NULL, NULL, '17301-4640799-7', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(211, '1-05-08/3100', 'Tariq Khan', 'Shareen Khan', NULL, NULL, '17301-4701853-3', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(212, '1-05-08/3597', 'Saqib Khan', 'Abdul Hamid Khan', NULL, NULL, '17301-4767295-3', NULL, NULL, NULL, 'TWO', 'D(W&S)', 'Maintenance of Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(213, '1-05-08/3268', 'Shayan Masih', 'Waryam Masih', NULL, NULL, '17301-4777951-5', NULL, NULL, NULL, 'Sanitary Worker', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(214, '1-05-08/2995', 'Faraz Ali', 'Ghulam Hussain', NULL, NULL, '17301-4910124-3', NULL, NULL, NULL, 'Suprrvisor', 'D(Finance)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(215, '1-05-08/3352', 'Muhammad Ibraheem', 'Afsar Jan', NULL, NULL, '17301-4915291-3', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(216, '1-05-08/3234', 'Asghar Khan', 'Umer Khan', NULL, NULL, '17301-4988855-9', NULL, NULL, NULL, 'Driver', 'D(NPV)', 'Beautification of Peshawar.', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(217, '1-05-08/3341', 'Bilal', 'Riaz Khan', NULL, NULL, '17301-5012792-3', NULL, NULL, NULL, 'Sanitary Worker', 'D (Buildings)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(218, '1-05-08/2985', 'Amir Shahab', 'Shah Zameer', NULL, NULL, '17301-5041331-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'N-5/G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(219, '1-05-08/2325', 'Jabir Ali', 'Sabir Ali', NULL, NULL, '17301-5047211-5', NULL, NULL, NULL, 'Mali', 'D(Machinery)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(220, '1-05-08/3300', 'Muhammad Bilal', 'Nisar Ali', NULL, NULL, '17301-5059352-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(221, '1-05-08/3288', 'Adnan ', 'Ijaz Khan', NULL, NULL, '17301-5087032-5', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(222, '1-05-08/2327', 'Ayub Khan', 'Ali Dad ', NULL, NULL, '17301-5090640-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(223, '1-05-08/3280', 'Imtiaz Khan', 'Abdul Khaliq', NULL, NULL, '17301-5091901-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(224, '1-05-08/3364', 'Daulat Khan', 'Waris Khan', NULL, NULL, '17301-5106355-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(225, '1-05-08/2291', 'Abdul Rehman', 'Hazrat Khan', NULL, NULL, '17301-5124477-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(226, '1-05-08/2533', 'Sagar Iftikhar', 'Iftikhar Masih', NULL, NULL, '17301-5171817-1', NULL, NULL, NULL, 'Sanitary Worker', 'D (Buildings)', 'Maintenance of Building', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(227, '', 'Syed Murtaza Zahid Gillani', 'Syed Yahya Zahid Gillani', NULL, NULL, '17301-5190579-5', NULL, NULL, NULL, 'SCL', 'Legal Section', 'Law Charges', 44500, 0, NULL, 0, '2024-03-17 18:58:31'),
(228, '1-05-08/3484', 'Manzoor Elahi', 'Sifat Elahi', NULL, NULL, '17301-541689-5', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(229, '1-05-08/3200', 'Malang Jan', 'Ghulam Wali', NULL, NULL, '17301-5455208-9', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort:) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(230, '', 'Kamran Khan', 'Naeem Khan', NULL, NULL, '17301-5623100-3', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 26700, 0, NULL, 0, '2024-03-17 18:58:31'),
(231, '1-05-08/3593', 'Muhammad Imran', 'Muhammad Khurshid', NULL, NULL, '17301-5626845-7', NULL, NULL, NULL, 'Naib Qasid', 'D (Electrical)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(232, '1-05-08/3218', 'Adil Khan', 'Zarnush Khan', NULL, NULL, '17301-5637672-5', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(233, '1-05-08/2473', 'Yaseen', 'Jahangir Khan', NULL, NULL, '17301-5651698-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(234, '1-05-08/3572', 'Fahad ', 'Fareed ullah Shah', NULL, NULL, '17301-5678740-7', NULL, NULL, NULL, 'Asst Supervisor', 'D (Electrical)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(235, '1-05-08/3412', 'Akhtar Bilal Khan', 'Shoukat Ali', NULL, NULL, '17301-5696195-3', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of N-5/G.T/Jamrud Road', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(236, '1-05-08/3264', 'Shakeel Ahmad', 'Rehman ud Din', NULL, NULL, '17301-5712538-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(237, '', 'Miss Madeeha Pervaiz', 'Pervaz Akhtar', NULL, NULL, '17301-5767629-0', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 35600, 0, NULL, 0, '2024-03-17 18:58:31'),
(238, '1-05-08/', 'Muhammad Muaz', 'Faiz Ul Hassan', NULL, NULL, '17301-5782164-3', NULL, NULL, NULL, 'Pesh Imam', 'D (Eng RMT)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(239, '1-05-08/3462', 'Afaq Khan', 'Ijaz Hussain', NULL, NULL, '17301-5788496-9', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(240, '1-05-08/3363', 'Fazal Muhammad', 'Noor Muhammad', NULL, NULL, '17301-5795794-5', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(241, '1-05-08/3330', 'Nasir Khan', 'Saleem Khan', NULL, NULL, '17301-5840805-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort: HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(242, '1-05-08/3207', 'Bilal Javed', 'Javed Hayat', NULL, NULL, '17301-5882421-9', NULL, NULL, NULL, 'Supervisor', 'D(W&S)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(243, '1-05-08/3460', 'Irfan Ullah', 'Javed Akhtar', NULL, NULL, '17301-5922576-3', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(244, '1-05-08/', 'Waleed ', 'Abdul Ghafar', NULL, NULL, '17301-5938404-9', NULL, NULL, NULL, 'Asst-Super', 'D (Engg: Roads)', 'Peshawar uplift Program', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(245, '1-05-08/3266', 'Ihsan Ullah', 'Zaman khan', NULL, NULL, '17301-6017743-9', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(246, '1-05-08/3409', 'Muhammad Ayaz', 'Shafiq', NULL, NULL, '17301-6072172-7', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of G.T/Jamrud Road (Self Finance/PDA Funded)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(247, '1-05-08/3159', 'Khaista Rehman ', 'Habib Ur Rehman ', NULL, NULL, '17301-6097064-5', NULL, NULL, NULL, 'Electrician Helper', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(248, '', 'Yasir Ali', 'Qaisar Ali', NULL, NULL, '17301-6114774-5', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 44500, 0, NULL, 0, '2024-03-17 18:58:31'),
(249, '1-05-08/3346', 'Kashif Masih', 'Yousaf Shareef Masih', NULL, NULL, '17301-6145915-5', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(250, '1-05-08/3257', 'Mumrez Khan', 'Gul Khan', NULL, NULL, '17301-6220686-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(251, '1-05-08/3192-A', 'Muhammad Tufail', 'Shehzada', NULL, NULL, '17301-6326417-7', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinary)', 32000, 0, NULL, 0, '2024-03-17 18:58:31');
INSERT INTO `officials` (`official_id`, `file_no`, `official_name`, `father_name`, `date_of_birth`, `domicile`, `cnic`, `address`, `contact`, `appointment_date`, `designation`, `directorate`, `chargeable_head`, `monthly_pay`, `income_tax_applied`, `status`, `is_salary_blocked`, `created_at`) VALUES
(252, '1-05-08/2316', 'Muhammad Amir Hamza', 'Nasim Iqbal', NULL, NULL, '17301-6354267-1', NULL, NULL, NULL, 'Supervisor', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(253, '1-05-08/3325', 'Naila Yousaf', 'Yousaf Masih', NULL, NULL, '17301-6382282-6', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(254, '1-05-08/3084', 'Amir Khan', 'Hameed Ullah Jan', NULL, NULL, '17301-6410701-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/Jamrud Roads', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(255, '1-05-08/3334', 'Syed Wajahat Shah', 'Syed Hikmat Shah', NULL, NULL, '17301-6443377-7', NULL, NULL, NULL, 'Pesh Imam', 'D (Eng RMT)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(256, '1-05-08/3286a', 'Wasif Ullah', 'Muhammad Zaman', NULL, NULL, '17301-6456640-5', NULL, NULL, NULL, 'Sirvey Helper', 'D (Eng RMT)', 'Maintenance of Road RMT', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(257, '1-05-08/', 'Afaq Khan Afridi', 'Muhammad shah', NULL, NULL, '17301-6531008-1', NULL, NULL, NULL, 'Supervisor', 'ADG (Hort)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(258, '1-05-08/3422', 'Dilshad Nabi', 'Zahir Jan', NULL, NULL, '17301-6546107-1', NULL, NULL, NULL, 'Assistant Supervisor', 'D (Engg: Roads)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(259, '1-05-08/3227', 'Kashif Jan', 'Williaum Jan', NULL, NULL, '17301-6772978-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(260, '1-05-08/3002', 'Muhammad Israr Ul Haq', 'Haq Nawaz', NULL, NULL, '17301-6822473-3', NULL, NULL, NULL, 'Electrical Supervisor', 'D (Electrical)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(261, '', 'Mst Palwasha Khan', 'Murtaza Khan', NULL, NULL, '17301-6830833-6', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 35600, 0, NULL, 0, '2024-03-17 18:58:31'),
(262, '1-05-08/3367', 'Musanif Shah', 'Rehmat Ullah', NULL, NULL, '17301-6855641-5', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(263, '1-05-08/3258', 'Zaheer ud Din Babar', 'Aleem ud Din', NULL, NULL, '17301-6891244-5', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(264, '1-05-08/2275', 'Umar Farooq', 'Abdul Manan', NULL, NULL, '17301-6894789-3', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(265, '1-05-08/3291', 'Naveed ', 'Imdad Khan', NULL, NULL, '17301-6940000-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(266, '1-05-08/3044', 'Muhammad Faizan Chuhdri', 'Abdul Fayyaz', NULL, NULL, '17301-6955877-9', NULL, NULL, NULL, 'Finance Supervisor', 'D(Finance)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(267, '1-05-08/3293', 'Nadeem Khan', 'Babo Khan', NULL, NULL, '17301-7086135-5', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(268, '1-05-08/3499', 'Musharaf Khan', 'Sheran Gul', NULL, NULL, '17301-7292209-3', NULL, NULL, NULL, 'Assistant Supervisor', 'D (Engg: Roads)', '\"Construction of Detour Road', 0, 0, NULL, 0, '2024-03-17 18:58:31'),
(269, '1-05-08/3231', 'Murad Hussain', 'Imdad Hussain', NULL, NULL, '17301-7314190-1', NULL, NULL, NULL, 'Tubewell Operator', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(270, '1-05-08/3243', 'Bakhtiar Ali', 'Zarwali Khan', NULL, NULL, '17301-7330437-3', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinary)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(271, '1-05-08/3443', 'Kifayat Ullah', 'Fazal Raziq', NULL, NULL, '17301-7399541-1', NULL, NULL, NULL, 'Road Gang Collie', 'D(Finance)', 'Peshawar Uplift', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(272, '1-05-08/3496', 'Shakir Ullah', 'Lal Madar', NULL, NULL, '17301-7432682-5', NULL, NULL, NULL, 'Assistant Supervisor', 'D (Engg: Roads)', '\"Construction of Detour Road', 0, 0, NULL, 0, '2024-03-17 18:58:31'),
(273, '1-05-08/3157', 'Muhammad Waqar', 'Muhammad Irshad Khan', NULL, NULL, '17301-7446159-5', NULL, NULL, NULL, 'Electrician Helper', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(274, '1-05-08/3507', 'Irfan Ullah', 'Mumtaz Khan', NULL, NULL, '17301-7452138-3', NULL, NULL, NULL, 'Forest Guard', 'ADG (Hort)', 'Peshawar Uplift', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(275, '1-05-08/3340', 'Asif Khan', 'Muhammad Yousaf', NULL, NULL, '17301-7460474-3', NULL, NULL, NULL, 'Sanitary Worker', 'DG Secretariat', 'Head office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(276, '1-05-08/3156', 'Abid', 'Khadi Khan', NULL, NULL, '17301-7528610-7', NULL, NULL, NULL, 'Electrician Helper', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(277, '', 'Muhammad Saad Wazir', 'Musa Wazir', NULL, NULL, '17301-7541621-5', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 35600, 0, NULL, 0, '2024-03-17 18:58:31'),
(278, '1-05-08/3182', 'Jan Muhammad ', 'Jamdad Khan', NULL, NULL, '17301-7541768-9', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(279, '1-05-08/3349', 'Ali Khan', 'Atta Muhammad', NULL, NULL, '17301-7541863-1', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(280, '1-05-08/', 'Muhammad Amjad Khan', 'Shamshad ', NULL, NULL, '17301-7565213-7', NULL, NULL, NULL, 'Consultant Advisor', 'D(Admin)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(281, '1-05-08/3336', 'Daud Shabir', 'Tariq Shabir', NULL, NULL, '17301-7614498-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort: HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(282, '1-05-08/3230', 'Sohail ', 'Kifayat Ullah', NULL, NULL, '17301-7673659-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(283, '1-05-08/3355', 'Adnan Ali', 'Gohar Ali', NULL, NULL, '17301-7687838-1', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:31'),
(284, '1-05-08/3335', 'Adil Khan', 'Toti Gul', NULL, NULL, '17301-7721076-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort: HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(285, '1-05-08/3351', 'Malik Sadam Hussain', 'Mehruban Shah', NULL, NULL, '17301-7750694-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(286, '1-05-08/3415', 'Musa Khan', 'Jabir Khan', NULL, NULL, '17301-7870413-3', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of N-5/G.T/Jamrud Road', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(287, '1-05-08/3098', 'Sabir Ali', 'Zar Ahmad', NULL, NULL, '17301-7886387-7', NULL, NULL, NULL, 'Tractor Driver', 'D(Machinery) ', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(288, '', 'Sabah ud Din Khattak', 'Ghias ud Din', NULL, NULL, '17301-7929871-5', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 133500, 0, NULL, 0, '2024-03-17 18:58:32'),
(289, '1-05-08/3094', 'Murad Khan', 'Hukam Khan', NULL, NULL, '17301-7988564-5', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(290, '', 'Salaar Khattak', 'Zahid Ullah Khan', NULL, NULL, '17301-8056907-3', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 40050, 0, NULL, 0, '2024-03-17 18:58:32'),
(291, '1-05-08/3033', 'Zeeshan Ahmad', 'Ameer Rehman', NULL, NULL, '17301-8100032-9', NULL, NULL, NULL, 'Tractor Driver', 'D (Engg: Roads)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(292, '1-05-08/3373', 'Hussain Ali', 'Ghulam Ali', NULL, NULL, '17301-8200566-3', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(293, '1-05-08/2283', 'Bashir Muhammad', 'Yar Muhammad', NULL, NULL, '17301-8219461-5', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort) N-5/G.T Road', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(294, '1-05-08/3290', 'Ulas Khan', 'Taus Khan', NULL, NULL, '17301-8285633-7', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(295, '1-05-08/3322', 'Waseem Khan', 'Niaz Hussain', NULL, NULL, '17301-8480617-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(296, '1-05-08/3323', 'Shahid Khan', 'Misri Khan', NULL, NULL, 'null-wrong-3', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of W&S', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(297, '1-05-08/', 'Muhammad Rashid Khan', 'Muhammad Arif Khan', NULL, NULL, '17301-8504130-1', NULL, NULL, NULL, 'Supervisor', 'ADG (Hort)', 'Uplift and Beautification of Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(298, '1-05-08/3372', 'Wakeel Khan', 'Hazrat Khan', NULL, NULL, '17301-8608711-3', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(299, '', 'Muhammad Furqan Yousafzai', 'Inayat Ullah', NULL, NULL, '17301-8609499-1', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 59333, 0, NULL, 0, '2024-03-17 18:58:32'),
(300, '1-05-08/3371', 'Muhammad Ismail', 'Riaz Khan', NULL, NULL, '17301-8799968-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(Vigilance)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(301, '', 'Abdul Wasay', 'Irshad Ahmad', NULL, NULL, '17301-8827585-3', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 44500, 0, NULL, 0, '2024-03-17 18:58:32'),
(302, '1-05-08/3470', 'Muhammad Iftikhar', 'Ashraf Khan', NULL, NULL, '17301-8876047-5', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of N-5/G.T/Jamrud Road', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(303, '1-05-08/1837', 'Omair Afridi', 'Muhammad Waris', NULL, NULL, '17301-8954304-7', NULL, NULL, NULL, 'Finance Supervisor', 'D(Admin)', 'Head Office', 40000, 0, NULL, 0, '2024-03-17 18:58:32'),
(304, '1-05-08/3295', 'Mubarak Shah', 'Abdul Qadir', NULL, NULL, '17301-8957298-1', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(305, '1-05-08/3408', 'Irfan Ullah', 'Gulfam Khan', NULL, NULL, '17301-9076060-5', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of G.T/Jamrud Road (Self Finance/PDA Funded)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(306, '1-05-08/3588', 'Abdul Wahab', 'Khaista Gul', NULL, NULL, '17301-9083347-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of (Hort:)hst;', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(307, '1-05-08/3192', 'Sumaira', 'Irfan Anthany', NULL, NULL, '17301-9085989-2', NULL, NULL, NULL, 'Sanitary Worker', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(308, '1-05-08/3224', 'Gul Nawaz', 'Nawaz Khan', NULL, NULL, '17301-9166062-9', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(309, '1-05-08/3154', 'Muhammad Sohail Ahmad', 'Habib Ullah', NULL, NULL, '17301-9175062-1', NULL, NULL, NULL, 'Assistant Supervisor', 'D(Finance)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(310, '1-05-08/3488', 'Waseem Ullah', 'Rizwan Ullah', NULL, NULL, '17301-9211248-5', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of N-5/G.T/Jamrud Road', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(311, '1-05-08/3590', 'Bilal Khan', 'Feroz Khan', NULL, NULL, '17301-9231620-7', NULL, NULL, NULL, 'Asstt; Supervisor', 'D(W&S)', 'Maintenance of Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(312, '1-05-08/3337', 'Mehboob Ur Rehman', 'Ghani Ur Rehman', NULL, NULL, '17301-9239744-1', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(313, '1-05-08/3082', 'Tariq Aziz', 'Waheed ullah', NULL, NULL, '17301-9320934-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(314, '1-05-08/', 'Amjad Khan', 'Ahmad Zeb', NULL, NULL, '17301-9324710-7', NULL, NULL, NULL, 'TWO', 'ADG (Hort)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(315, '1-05-08/3092', 'Muhammad Hussain', 'Rahdad khan', NULL, NULL, '17301-9333957-3', NULL, NULL, NULL, 'Tractor Driver', 'ADG (Hort)', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(316, '1-05-08/3465', 'Akhtar Zaman', 'Akhtar Hussain', NULL, NULL, '17301-9403055-9', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(317, '1-05-08/3407', 'Yasir Ghafoor Khan', 'Abdul Ghafoor Khan', NULL, NULL, '17301-9492137-3', NULL, NULL, NULL, 'Supervisor', 'D (Engg: Roads)', 'Maintenance of G.T/Jamrud Road (Self Finance/PDA Funded)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(318, '1-05-08/3458', 'Atif Qamar', 'Qamar Zaman', NULL, NULL, '17301-9507047-1', NULL, NULL, NULL, 'Khadim', 'D (Buildings)', 'Regi Model Town', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(319, '1-05-08/', 'Muhammad Israr Qureshi', 'Sayed Nawaz Shah', NULL, NULL, '17301-9545860-1', NULL, NULL, NULL, 'Vet Doctor', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(320, '1-05-08/3497', 'Hayat Sher', 'Shamsher Khan', NULL, NULL, '17301-9605360-9', NULL, NULL, NULL, 'Assistant Supervisor', 'D (Engg: Roads)', '\"Construction of Detour Road', 0, 0, NULL, 0, '2024-03-17 18:58:32'),
(321, '1-05-08/3145', 'Muhammad Yaseen', 'Gul Zameer', NULL, NULL, '17301-9653897-9', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(322, '1-05-08/3318', 'Sheraz Javed', 'Muhammad Javed', NULL, NULL, '17301-9667549-3', NULL, NULL, NULL, 'Assistant Supervisor', 'D (Buildings)', 'RMT', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(323, '1-05-08/3019', 'Shehzad ul Khaliq', 'Ihsan ul Khaliq', NULL, NULL, '17301-9678011-9', NULL, NULL, NULL, 'Supervisor', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(324, '1-05-08/3265', 'Habib Ullah', 'Awaldar', NULL, NULL, '17301-9693007-7', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(325, '1-05-08/3585', 'Rahmat Ullah', 'Fazle Mula', NULL, NULL, '17301-9729287-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(326, '1-05-08/3467', 'Awais Niaz', 'Syed Falak Niaz', NULL, NULL, '17301-9880846-9', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(327, '', 'Muhammad Nasar Durrani', 'Sajid Ahmad', NULL, NULL, '17301-9893325-3', NULL, NULL, NULL, 'S.L.C', 'Legal Section', 'Law Charges', 26106, 0, NULL, 0, '2024-03-17 18:58:32'),
(328, '1-05-08/2238', 'Saqib ', 'Rooh ul Amin', NULL, NULL, '17301-9973001-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(329, '1-05-08/3262', 'Yahya', 'Abdur Rauf', NULL, NULL, '17601-8656273-1', NULL, NULL, NULL, 'Mali', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(330, '1-05-08/3088', 'Noor Hakeem ', 'Ashraf Khan', NULL, NULL, '21201-8920514-1', NULL, NULL, NULL, 'Tractor Driver', 'D(Machinery) ', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(331, '1-05-08/3424', 'Muhammad Arif', 'Janan', NULL, NULL, '21202-1164123-1', NULL, NULL, NULL, 'Chowkidar', 'DG Secretariat', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(332, '1-05-08/3469', 'Muhammad Wasim Afridi', 'Riaz Hussain Afridi', NULL, NULL, '21202-1670154-7', NULL, NULL, NULL, 'Assistant Supervisor', 'D (Engg: Roads)', 'Maintenance of N-5/G.T/Jamrud Road', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(333, '1-05-08/', 'Wajid Gul', 'Mumtaz Khan', NULL, NULL, '21202-2812904-1', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Maint of Hort RMT', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(334, '1-05-08/3416', 'Abdullah Khan', 'Mirza Khan', NULL, NULL, '21202-4339164-5', NULL, NULL, NULL, 'Road Gang Collie', 'D(Admin)', 'Maintenance of G.T/Jamrud/N-5 Road Peshawar', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(335, '1-05-08/3081', 'Niamat Khan', 'Juma Khan', NULL, NULL, '21202-5892295-7', NULL, NULL, NULL, 'Chowkidar', 'ADG (Hort)', 'Maintenance of Hort (HST)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(336, '1-05-08/3423', 'Qismat Khan', 'Sher Dast Khan', NULL, NULL, '21202-7287844-7', NULL, NULL, NULL, 'Chowkidar', 'DG Secretariat', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(337, '1-05-08/3468', 'Gul Shad', 'Banaras', NULL, NULL, '21202-8179701-3', NULL, NULL, NULL, 'Road Gang Collie', 'D (Engg: Roads)', 'Maintenance of G.T/Jamrud Road', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(338, '1-05-08/3589', 'Bezwar Khan', 'Sherzada', NULL, NULL, '21202-8691973-5', NULL, NULL, NULL, 'Naib Qasid', 'D(E.M)', 'EM RMT', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(339, '1-05-08/3374', 'Muhammad Sadeeq', 'Muhammad Khan', NULL, NULL, '21301-5436960-1', NULL, NULL, NULL, 'Road Gang Cooly', 'D (Engg: Roads)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(340, '1-05-08/3096', 'Umar Khan', 'Daud Khan', NULL, NULL, '22401-4657034-7', NULL, NULL, NULL, 'Tractor Driver', 'D(Machinery) ', 'Maintenance of (Machinery)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(341, '1-05-08/3393', 'Irshad Masih', 'Lal Masih', NULL, NULL, '35404-4955923-3', NULL, NULL, NULL, 'Sanitary Worker', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(342, '1-05-08/3328', 'Hamid Ullah Khan', 'Sher Khan', NULL, NULL, '372035-456951-7', NULL, NULL, NULL, 'Excavator Operator', 'D(Machinery) ', 'Maintenance of (Machinary)', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(343, '', 'Barrister Saad Ali Shah', 'Syed akhtar Ali Shah', NULL, NULL, '42301-3352998-3', NULL, NULL, NULL, 'SLC', 'Legal Section', 'Law Charges', 62300, 0, NULL, 0, '2024-03-17 18:58:32'),
(344, '1-05-08/3223', 'Nigar Khan', 'Rustam Khan', NULL, NULL, '42301-8378023-3', NULL, NULL, NULL, 'Tubewell Operator', 'D(W&S)', 'Maintenance of (W&S) HST', 32000, 0, NULL, 0, '2024-03-17 18:58:32'),
(345, '1-05-08/2157', 'Samar Gul', 'Mir Alam', NULL, NULL, '61101-5609831-9', NULL, NULL, NULL, 'Assistant Supervisor', 'D(Admin)', 'Head Office', 32000, 0, NULL, 0, '2024-03-17 18:58:32');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int UNSIGNED NOT NULL,
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL COMMENT 'operator,director,super-admin',
  `status` varchar(50) DEFAULT NULL COMMENT 'active,blocked',
  `attempts` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `email`, `password`, `role`, `status`, `attempts`, `created_at`) VALUES
(1, 'Asad ullahhh hh', 'asad@gmail.com', '123', 'operator', 'active', 0, '2024-03-13 20:10:17'),
(2, '11222', 'test@gmail.com', '111', NULL, NULL, NULL, '2024-03-13 22:54:19'),
(6, 'asd', '$this->db->error()', 'asd', NULL, NULL, NULL, '2024-03-13 22:59:24'),
(11, 'asd', 'asd@gmail.com', 'asd', NULL, NULL, NULL, '2024-03-13 23:03:42'),
(12, 'asd', 'asdasds@gmail.comasd', 'asd', NULL, NULL, NULL, '2024-03-13 23:04:41'),
(15, '$this->db->error()', 'tesssst@gmail.com', 'test@gmail.com', 'null', 'null', 0, '2024-03-13 23:06:49'),
(17, 'asd', 'assssd@gmail.com', 'asd@gmail.com', NULL, NULL, NULL, '2024-03-13 23:08:47');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bank_details`
--
ALTER TABLE `bank_details`
  ADD PRIMARY KEY (`bank_detail_id`);

--
-- Indexes for table `chargeable_heads`
--
ALTER TABLE `chargeable_heads`
  ADD PRIMARY KEY (`chargeable_head_id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `designations`
--
ALTER TABLE `designations`
  ADD PRIMARY KEY (`designation_id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `directorates`
--
ALTER TABLE `directorates`
  ADD PRIMARY KEY (`directorate_id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `extensions_validity`
--
ALTER TABLE `extensions_validity`
  ADD PRIMARY KEY (`extensions_validity_id`);

--
-- Indexes for table `monthly_pay_rolls`
--
ALTER TABLE `monthly_pay_rolls`
  ADD PRIMARY KEY (`monthly_pay_roll_id`);

--
-- Indexes for table `officials`
--
ALTER TABLE `officials`
  ADD PRIMARY KEY (`official_id`),
  ADD UNIQUE KEY `cnic` (`cnic`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `constraint_name` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bank_details`
--
ALTER TABLE `bank_details`
  MODIFY `bank_detail_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=512;

--
-- AUTO_INCREMENT for table `chargeable_heads`
--
ALTER TABLE `chargeable_heads`
  MODIFY `chargeable_head_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `designations`
--
ALTER TABLE `designations`
  MODIFY `designation_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `directorates`
--
ALTER TABLE `directorates`
  MODIFY `directorate_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `extensions_validity`
--
ALTER TABLE `extensions_validity`
  MODIFY `extensions_validity_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=512;

--
-- AUTO_INCREMENT for table `monthly_pay_rolls`
--
ALTER TABLE `monthly_pay_rolls`
  MODIFY `monthly_pay_roll_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `officials`
--
ALTER TABLE `officials`
  MODIFY `official_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=346;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
