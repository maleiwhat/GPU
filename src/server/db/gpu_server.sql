-- phpMyAdmin SQL Dump
-- version 3.5.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 01, 2013 at 11:53 AM
-- Server version: 5.5.25a
-- PHP Version: 5.4.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `gpu_server`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `PLANAR_DISTANCE`(lat1 DOUBLE, lon1 DOUBLE, lat2 DOUBLE,  lon2 DOUBLE) RETURNS double
    DETERMINISTIC
BEGIN
     DECLARE dist DOUBLE;
     SET dist = SQRT((lat1-lat2)*(lat1-lat2)+(lon1-lon2)*(lon1-lon2));
     RETURN dist;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbchannel`
--

CREATE TABLE IF NOT EXISTS `tbchannel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nodeid` varchar(42) NOT NULL,
  `nodename` varchar(32) NOT NULL,
  `user` varchar(32) NOT NULL,
  `channame` varchar(32) NOT NULL,
  `chantype` varchar(32) NOT NULL,
  `content` varchar(1024) NOT NULL,
  `ip` varchar(32) DEFAULT NULL,
  `usertime_dt` datetime DEFAULT NULL,
  `create_dt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nodeid_2` (`nodeid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `tbchannel`
--

INSERT INTO `tbchannel` (`id`, `nodeid`, `nodename`, `user`, `channame`, `chantype`, `content`, `ip`, `usertime_dt`, `create_dt`) VALUES
(1, '1', 'andromeda', 'dangermouse', 'Altos', 'CHAT', 'Hello World', '127.0.0.1', '2013-02-18 00:00:00', '2013-02-18 00:00:00'),
(2, '2', 'virgibuntu', 'virus', 'Altos', 'CHAT', 'hey Tiz', NULL, NULL, '0000-00-00 00:00:00'),
(3, '1', 'andromeda', 'dangermouse', 'Plaza', 'CHAT', 'another chat entry in another channel', NULL, NULL, '0000-00-00 00:00:00'),
(4, '2', 'virgibuntu', 'virginia', 'Altos', 'CHAT', 'test', '127.0.0.1', NULL, '2013-02-19 16:26:15'),
(6, '2', 'virgibuntu', 'virginia', 'Altos', 'CHAT', 'test', '127.0.0.1', NULL, '2013-02-21 11:37:59'),
(7, '2', 'virgibuntu', 'virginia', 'Altos', 'CHAT', 'test', '127.0.0.1', NULL, '2013-02-21 11:38:53'),
(8, '2', 'virgibuntu', 'virginia', 'Altos', 'CHAT', 'test', '127.0.0.1', NULL, '2013-02-21 11:38:56');

-- --------------------------------------------------------

--
-- Table structure for table `tbclient`
--

CREATE TABLE IF NOT EXISTS `tbclient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nodeid` varchar(42) NOT NULL,
  `nodename` varchar(32) NOT NULL,
  `country` varchar(32) NOT NULL,
  `region` varchar(32) DEFAULT NULL,
  `city` varchar(32) DEFAULT NULL,
  `zip` varchar(32) DEFAULT NULL,
  `ip` varchar(32) DEFAULT NULL,
  `port` varchar(32) DEFAULT NULL,
  `localip` varchar(32) DEFAULT NULL,
  `os` varchar(32) NOT NULL,
  `version` double NOT NULL,
  `acceptincoming` int(11) NOT NULL DEFAULT '0',
  `gigaflops` int(11) NOT NULL,
  `ram` int(11) NOT NULL,
  `mhz` int(11) NOT NULL,
  `nbcpus` int(11) NOT NULL,
  `bits` int(11) NOT NULL,
  `isscreensaver` int(11) NOT NULL DEFAULT '0',
  `uptime` double NOT NULL,
  `totaluptime` double NOT NULL,
  `longitude` double NOT NULL,
  `latitude` double NOT NULL,
  `pos` point NOT NULL,
  `userid` varchar(32) NOT NULL,
  `team` varchar(64) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `cputype` varchar(64) DEFAULT NULL,
  `create_dt` datetime NOT NULL,
  `update_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nodeid` (`nodeid`),
  KEY `nodeid_2` (`nodeid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `tbclient`
--

INSERT INTO `tbclient` (`id`, `nodeid`, `nodename`, `country`, `region`, `city`, `zip`, `ip`, `port`, `localip`, `os`, `version`, `acceptincoming`, `gigaflops`, `ram`, `mhz`, `nbcpus`, `bits`, `isscreensaver`, `uptime`, `totaluptime`, `longitude`, `latitude`, `pos`, `userid`, `team`, `description`, `cputype`, `create_dt`, `update_dt`) VALUES
(1, '1', 'andromeda', 'Switzerland', NULL, NULL, NULL, NULL, NULL, NULL, 'Win7', 0.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 46.5, 0x00000000010100000000000000000000000000000000000000, '', '', NULL, NULL, '0000-00-00 00:00:00', NULL),
(2, '2', 'virgibuntu', 'Switzerland', NULL, NULL, NULL, NULL, NULL, NULL, 'WinXP', 1.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 47, 0x00000000010100000000000000000000000000000000000000, '', '', NULL, NULL, '0000-00-00 00:00:00', NULL),
(6, '4', 'blabla', '', '', '', '', '127.0.0.1', '', '', '', 0, 0, 0, 0, 0, 0, 32, 0, 0, 9, 13.5, 14.3, 0x0000000001010000000000000000002b409a99999999992c40, '', '', '', '', '2013-02-28 14:31:41', '2013-02-28 14:32:34');

-- --------------------------------------------------------

--
-- Table structure for table `tbjobdefinition`
--

CREATE TABLE IF NOT EXISTS `tbjobdefinition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobdefinitionid` varchar(42) NOT NULL,
  `job` varchar(1024) NOT NULL,
  `jobtype` varchar(16) NOT NULL,
  `requireack` tinyint(1) NOT NULL DEFAULT '0',
  `nodename` varchar(32) NOT NULL,
  `nodeid` varchar(42) NOT NULL,
  `ip` varchar(32) DEFAULT NULL,
  `create_dt` datetime NOT NULL,
  `update_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `jobdefinitionid` (`jobdefinitionid`),
  KEY `jobdefinitionid_2` (`jobdefinitionid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Dumping data for table `tbjobdefinition`
--

INSERT INTO `tbjobdefinition` (`id`, `jobdefinitionid`, `job`, `jobtype`, `requireack`, `nodename`, `nodeid`, `ip`, `create_dt`, `update_dt`) VALUES
(11, 'ae', '9,2,add', 'GPU_Engine', 0, 'andromeda', '1', '127.0.0.1', '2013-02-28 09:08:22', '2013-02-28 09:08:22'),
(12, 'aeb', '3,2,add', 'GPU_Engine', 0, 'andromeda', '1', '127.0.0.1', '2013-02-28 09:08:51', '2013-02-28 09:08:51'),
(13, 'aeqb', '3,2,add', 'GPU_Engine', 0, 'andromeda', '1', '127.0.0.1', '2013-02-28 11:22:51', '2013-02-28 11:22:51'),
(14, '23', '3,2,add', 'GPU_Engine', 0, 'andromeda', '1', '127.0.0.1', '2013-03-01 10:03:35', '2013-03-01 10:03:35'),
(15, '24', '3,2,add', 'GPU_Engine', 0, 'andromeda', '1', '127.0.0.1', '2013-03-01 10:12:53', '2013-03-01 10:12:53'),
(16, '25', '3,2,add', 'GPU_Engine', 0, 'andromeda', '1', '127.0.0.1', '2013-03-01 10:14:09', '2013-03-01 10:14:09'),
(17, '26', '3,2,add', 'GPU_Engine', 0, 'andromeda', '1', '127.0.0.1', '2013-03-01 10:14:48', '2013-03-01 10:14:48'),
(18, 'arb', '0,0,add', 'GPU_Engine', 0, 'andromeda', '1', '127.0.0.1', '2013-03-01 11:52:35', '2013-03-01 11:52:35');

-- --------------------------------------------------------

--
-- Table structure for table `tbjobqueue`
--

CREATE TABLE IF NOT EXISTS `tbjobqueue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobdefinitionid` varchar(42) NOT NULL,
  `jobqueueid` varchar(42) NOT NULL,
  `workunitjob` varchar(64) DEFAULT NULL,
  `workunitresult` varchar(64) DEFAULT NULL,
  `nodeid` varchar(42) NOT NULL,
  `nodename` varchar(32) DEFAULT NULL,
  `requireack` tinyint(1) NOT NULL,
  `acknodeid` varchar(42) DEFAULT NULL,
  `acknodename` varchar(32) DEFAULT NULL,
  `create_dt` datetime NOT NULL,
  `transmission_dt` datetime DEFAULT NULL,
  `transmissionid` varchar(42) DEFAULT NULL,
  `ack_dt` datetime DEFAULT NULL,
  `reception_dt` datetime DEFAULT NULL,
  `ip` varchar(42) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `jobqueueid` (`jobqueueid`),
  KEY `jobqueueid_2` (`jobqueueid`),
  KEY `transmissionid` (`transmissionid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=69 ;

--
-- Dumping data for table `tbjobqueue`
--

INSERT INTO `tbjobqueue` (`id`, `jobdefinitionid`, `jobqueueid`, `workunitjob`, `workunitresult`, `nodeid`, `nodename`, `requireack`, `acknodeid`, `acknodename`, `create_dt`, `transmission_dt`, `transmissionid`, `ack_dt`, `reception_dt`, `ip`) VALUES
(37, 'ae', '1', '', '', '1', 'andromeda', 1, '1', 'andromeda', '2013-02-28 09:08:22', '2013-02-28 15:46:56', '9ca77f0d9349bf9b05ee3b4bf34d983e', '2013-02-28 10:04:20', NULL, '127.0.0.1'),
(38, 'ae', 'a5ff54c89409e531a5c17db42d042bf8', '', '', '1', 'andromeda', 1, NULL, NULL, '2013-02-28 09:08:22', '2013-02-28 15:46:56', '9ca77f0d9349bf9b05ee3b4bf34d983e', NULL, NULL, '127.0.0.1'),
(39, 'ae', '386ab115e8b712010150234cd30a2d8a', '', '', '1', 'andromeda', 1, NULL, NULL, '2013-02-28 09:08:22', '2013-02-28 15:46:56', '9ca77f0d9349bf9b05ee3b4bf34d983e', NULL, NULL, '127.0.0.1'),
(40, 'ae', 'b83bece49df09724ab375740dbe14847', '', '', '1', 'andromeda', 1, NULL, NULL, '2013-02-28 09:08:22', '2013-02-28 15:48:57', '8b5b3960c320a7c1ddd77215d1d96843', NULL, NULL, '127.0.0.1'),
(41, 'aeb', '885209a2c1c1bd4d3be3e9a1d60847a9', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-02-28 09:08:51', '2013-02-28 15:48:57', '8b5b3960c320a7c1ddd77215d1d96843', NULL, NULL, '127.0.0.1'),
(42, 'aeb', '581e795543f3496da91c2a03e0f84d4a', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-02-28 09:08:51', '2013-02-28 15:48:57', '8b5b3960c320a7c1ddd77215d1d96843', NULL, NULL, '127.0.0.1'),
(43, 'aeb', '9405beefee59a405c826ab04273a5a95', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-02-28 09:08:51', '2013-02-28 15:49:02', '0e0af3f6ce8aab98e776adf6fae52b80', NULL, NULL, '127.0.0.1'),
(44, 'aeb', '33183e593ad27f3224e754080b8f1c11', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-02-28 09:08:51', '2013-02-28 15:49:02', '0e0af3f6ce8aab98e776adf6fae52b80', NULL, NULL, '127.0.0.1'),
(45, 'aeqb', '3d107ba023dc3a98502cda09eeef19bb', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-02-28 11:22:51', '2013-02-28 15:49:02', '0e0af3f6ce8aab98e776adf6fae52b80', NULL, NULL, '127.0.0.1'),
(46, 'aeqb', '38f81038011aa487b43a11e0b2d17e97', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-02-28 11:22:51', '2013-02-28 15:49:12', '715a42e97ab4f2d4ff75bc712c152954', NULL, NULL, '127.0.0.1'),
(47, 'aeqb', 'a7c73d77185d550c96c5b800eefdafea', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-02-28 11:22:51', '2013-02-28 15:49:12', '715a42e97ab4f2d4ff75bc712c152954', NULL, NULL, '127.0.0.1'),
(48, 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-02-28 11:22:51', '2013-02-28 15:49:12', '715a42e97ab4f2d4ff75bc712c152954', NULL, '2013-02-28 18:04:57', '127.0.0.1'),
(49, '23', 'aa11057a12c466000829d9132240654f', '0', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:03:35', NULL, NULL, NULL, NULL, '127.0.0.1'),
(50, '23', '6226feda971b206220cb656f0bff980a', '1', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:03:35', NULL, NULL, NULL, NULL, '127.0.0.1'),
(51, '23', 'fdf2877f276716232a14f6db36fbc62b', '2', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:03:35', NULL, NULL, NULL, NULL, '127.0.0.1'),
(52, '23', '20e39c93eb6d3de0b9fdf9753bc9d9d5', '3', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:03:35', NULL, NULL, NULL, NULL, '127.0.0.1'),
(53, '24', 'd8fa37cb3d374d3ef3f6f985b1e84641', '0', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:12:53', NULL, NULL, NULL, NULL, '127.0.0.1'),
(54, '24', 'f4c722f51128a6f7f8197d6fa82a2363', '1', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:12:53', NULL, NULL, NULL, NULL, '127.0.0.1'),
(55, '24', 'ef56bc64f9e50a55831cabb13fc7533e', '2', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:12:53', NULL, NULL, NULL, NULL, '127.0.0.1'),
(56, '24', '72b51557fbf5df8de649f9264d16838b', '3', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:12:53', NULL, NULL, NULL, NULL, '127.0.0.1'),
(57, '25', '8aa221fe9783a45d0369aafd21f292d1', '_0', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:14:09', NULL, NULL, NULL, NULL, '127.0.0.1'),
(58, '25', '017900e2984e3a014692e124cc13546c', '_1', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:14:09', NULL, NULL, NULL, NULL, '127.0.0.1'),
(59, '25', 'b24a33174ade8ea95681eacae1992ea0', '_2', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:14:09', NULL, NULL, NULL, NULL, '127.0.0.1'),
(60, '25', 'dedc3be27333aaa2e3660e6be88fe0bd', '_3', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:14:09', NULL, NULL, NULL, NULL, '127.0.0.1'),
(61, '26', 'd3228e7226fdb3469960e66eff7480ea', '', '_0', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:14:48', NULL, NULL, NULL, NULL, '127.0.0.1'),
(62, '26', '05358b01367d685acec388eedafd0f69', '', '_1', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:14:48', NULL, NULL, NULL, NULL, '127.0.0.1'),
(63, '26', '61a5a5e45a5f3f2f1f30cf773717c4f8', '', '_2', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:14:48', NULL, NULL, NULL, NULL, '127.0.0.1'),
(64, '26', '5f0cb471737931493475e28d655403ec', '', '_3', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 10:14:48', NULL, NULL, NULL, NULL, '127.0.0.1'),
(65, 'arb', '2b5b931f7d2ec098d72fddcb3560dc0d', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 11:52:35', NULL, NULL, NULL, NULL, '127.0.0.1'),
(66, 'arb', '1c336aa1ceeb3691abcf5281300139c8', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 11:52:35', NULL, NULL, NULL, NULL, '127.0.0.1'),
(67, 'arb', 'e5247a5d71f33e0b23a0b2cea4327d46', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 11:52:35', NULL, NULL, NULL, NULL, '127.0.0.1'),
(68, 'arb', '63c44568b05ee6975cfa7d1fa070a971', '', '', '1', 'andromeda', 0, NULL, NULL, '2013-03-01 11:52:35', NULL, NULL, NULL, NULL, '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `tbjobresult`
--

CREATE TABLE IF NOT EXISTS `tbjobresult` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobresultid` varchar(42) NOT NULL,
  `jobdefinitionid` varchar(42) NOT NULL,
  `jobqueueid` varchar(42) NOT NULL,
  `jobresult` varchar(1024) NOT NULL,
  `workunitresult` varchar(64) NOT NULL,
  `iserroneous` int(11) NOT NULL DEFAULT '0',
  `errorid` int(11) NOT NULL DEFAULT '0',
  `errorarg` varchar(32) NOT NULL,
  `errormsg` varchar(32) NOT NULL,
  `nodename` varchar(32) NOT NULL,
  `nodeid` varchar(42) NOT NULL,
  `ip` varchar(32) DEFAULT NULL,
  `create_dt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobresultid` (`jobresultid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `tbjobresult`
--

INSERT INTO `tbjobresult` (`id`, `jobresultid`, `jobdefinitionid`, `jobqueueid`, `jobresult`, `workunitresult`, `iserroneous`, `errorid`, `errorarg`, `errormsg`, `nodename`, `nodeid`, `ip`, `create_dt`) VALUES
(2, 'bee522a89d23719339c66e57d2e13943', 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '5', '', 0, 0, '', '', 'andromeda', '1', '127.0.0.1', '2013-02-28 15:04:36'),
(3, '00e653c122baab92e345df40e7855f5d', 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '5', '', 0, 0, '', '', 'andromeda', '1', '127.0.0.1', '2013-02-28 17:05:44'),
(4, '4d4e633f26b5ce785d56a2aedb6ec59a', 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '5', '', 0, 0, '', '', 'andromeda', '1', '127.0.0.1', '2013-02-28 18:00:02'),
(5, '4b24dda8b7667385e0e7ab6f537911e9', 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '5', '', 0, 0, '', '', 'andromeda', '1', '127.0.0.1', '2013-02-28 18:00:38'),
(6, '505d2622b9c8913cc298c81272173d7a', 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '5', '', 0, 0, '', '', 'andromeda', '1', '127.0.0.1', '2013-02-28 18:00:44'),
(7, '48a957bd18ee23fdd12a4e286e0a376b', 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '5', '', 0, 0, '', '', 'andromeda', '1', '127.0.0.1', '2013-02-28 18:01:28'),
(8, '02189942e5f3f30256b4c34246bac34b', 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '5', '', 0, 0, '', '', 'andromeda', '1', '127.0.0.1', '2013-02-28 18:01:33'),
(9, 'd0e76947dd5a394f7b9c730b6ad82b12', 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '5', '', 0, 0, '', '', 'andromeda', '1', '127.0.0.1', '2013-02-28 18:01:48'),
(10, 'e1a0c75c9617b8a6fdd2a051d86668ab', 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '5', '', 0, 0, '', '', 'andromeda', '1', '127.0.0.1', '2013-02-28 18:03:53'),
(11, '69fc8587f7834c7b91790e1f99f251de', 'aeqb', '909dfb369fbba5fc24628b6d2e3bbc1f', '5', '', 0, 0, '', '', 'andromeda', '1', '127.0.0.1', '2013-02-28 18:04:57');

-- --------------------------------------------------------

--
-- Table structure for table `tbparameter`
--

CREATE TABLE IF NOT EXISTS `tbparameter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `paramtype` varchar(20) COLLATE latin1_general_ci NOT NULL,
  `paramname` varchar(32) COLLATE latin1_general_ci NOT NULL,
  `paramvalue` varchar(255) COLLATE latin1_general_ci NOT NULL,
  `create_dt` datetime DEFAULT NULL,
  `update_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `paramtype` (`paramtype`,`paramname`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci AUTO_INCREMENT=14 ;

--
-- Dumping data for table `tbparameter`
--

INSERT INTO `tbparameter` (`id`, `paramtype`, `paramname`, `paramvalue`, `create_dt`, `update_dt`) VALUES
(1, 'TEST', 'DB_CONNECTION', 'OK', NULL, '2013-02-25 16:13:37'),
(9, 'TIME', 'UPTIME', '81042', '2013-02-25 11:55:44', '2013-02-28 14:32:36'),
(8, 'CONFIGURATION', 'SERVER_ID', 'fb4bc9a27a2be5e0b7ce08dc2bf09618', '2013-02-25 11:55:44', '2013-02-25 11:55:44'),
(11, 'SECURITY', 'PWD_HASH_SALT', 'caacafd10c3a5837a9f98e21991e4d22', '2013-02-25 11:55:44', '2013-02-25 11:55:44'),
(13, 'TIME', 'LAST_SUPERSERVER_CALL', '1362058355', '2013-02-25 16:13:37', '2013-02-28 14:32:36');

-- --------------------------------------------------------

--
-- Table structure for table `tbserver`
--

CREATE TABLE IF NOT EXISTS `tbserver` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serverid` varchar(42) NOT NULL,
  `servername` varchar(32) NOT NULL,
  `serverurl` varchar(256) NOT NULL,
  `chatchannel` varchar(32) DEFAULT NULL,
  `version` double NOT NULL,
  `superserver` tinyint(1) NOT NULL,
  `ip` varchar(32) DEFAULT NULL,
  `uptime` double NOT NULL,
  `longitude` double NOT NULL,
  `latitude` double NOT NULL,
  `pos` point NOT NULL,
  `activenodes` int(11) NOT NULL,
  `jobinqueue` int(11) NOT NULL,
  `create_dt` datetime NOT NULL,
  `update_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `serverid` (`serverid`),
  KEY `serverid_2` (`serverid`),
  SPATIAL KEY `pos` (`pos`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `tbserver`
--

INSERT INTO `tbserver` (`id`, `serverid`, `servername`, `serverurl`, `chatchannel`, `version`, `superserver`, `ip`, `uptime`, `longitude`, `latitude`, `pos`, `activenodes`, `jobinqueue`, `create_dt`, `update_dt`) VALUES
(9, 'fb4bc9a27a2be5e0b7ce08dc2bf09618', 'Altos', '127.0.0.1:8090/gpu_freedom/src/server', 'altos', 0.1, 0, 'localhost', 81042, 14, 10, 0x0000000001010000000000000000002c400000000000002440, 3, 12, '2013-02-25 16:27:29', '2013-02-28 14:32:39'),
(11, '6e771f4936a0d24bf2448e0d187725a4', 'Orion', '127.0.0.1:8090/server', 'orion', 0.1, 1, '', 1693, 14, 10, 0x0000000001010000000000000000002c400000000000002440, 0, 0, '2013-02-26 14:35:36', '2013-02-28 14:32:44'),
(12, 'paripara', 'Algol', 'http://127.0.0.1:8090/algol', 'algol', 0.05, 0, '', 99, 90, 90, 0x00000000010100000000000000008056400000000000805640, 13, 2, '2013-02-26 14:39:33', '2013-02-28 14:32:45'),
(13, '3', 'Aldebaran', '', '', 0, 0, '127.0.0.1', 0, 18, 18, 0x00000000010100000000000000000032400000000000003240, 0, 0, '2013-02-28 11:21:54', '2013-02-28 13:36:46');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
