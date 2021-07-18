CREATE TABLE `user_mdt` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`char_id` int(11) DEFAULT NULL,
	`notes` varchar(255) DEFAULT NULL,
	`mugshot_url` varchar(255) DEFAULT NULL,
	`bail` bit DEFAULT NULL,

	PRIMARY KEY (`id`)
);

CREATE TABLE `vehicle_mdt` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`plate` varchar(255) DEFAULT NULL,
	`stolen` bit DEFAULT 0,
	`notes` varchar(255) DEFAULT NULL,

	PRIMARY KEY (`id`)
);

CREATE TABLE `user_convictions` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`char_id` int(11) DEFAULT NULL,
	`offense` varchar(255) DEFAULT NULL,
	`count` int(11) DEFAULT NULL,
	
	PRIMARY KEY (`id`)
);

CREATE TABLE `mdt_reports` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`char_id` int(11) DEFAULT NULL,
	`title` varchar(255) DEFAULT NULL,
	`incident` longtext DEFAULT NULL,
    `charges` longtext DEFAULT NULL,
    `author` varchar(255) DEFAULT NULL,
	`name` varchar(255) DEFAULT NULL,
    `date` varchar(255) DEFAULT NULL,

	PRIMARY KEY (`id`)
);

CREATE TABLE `mdt_warrants` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(255) DEFAULT NULL,
	`char_id` int(11) DEFAULT NULL,
	`report_id` int(11) DEFAULT NULL,
	`report_title` varchar(255) DEFAULT NULL,
	`charges` longtext DEFAULT NULL,
	`date` varchar(255) DEFAULT NULL,
	`expire` varchar(255) DEFAULT NULL,
	`notes` varchar(255) DEFAULT NULL,
	`author` varchar(255) DEFAULT NULL,

	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `fine_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(50) DEFAULT NULL,
  `amount` int DEFAULT NULL,
  `category` int DEFAULT NULL,
  `jailtime` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4;

INSERT INTO `fine_types` (`id`, `label`, `amount`, `category`, `jailtime`) VALUES
(1, 'Assassination', 15000, 3, 99),
(2, 'Racketeering/RICO', 15000, 3, 99),
(3, 'Treason', 15000, 3, 99),
(4, 'Terrorism', 15000, 3, 99),
(5, 'Murder of a Government Official', 10000, 3, 80),
(6, 'Attempted Murder of a Government Official', 4000, 3, 60),
(7, 'Assault on a Government Official', 3000, 3, 40),
(8, 'Impersonation of a Government Official', 2500, 3, 45),
(9, 'Possession of Government Property', 2000, 3, 40),
(10, 'Aggravated Armed Robbery', 6000, 3, 60),
(11, 'Armed Robbery', 5000, 3, 45),
(12, 'Felony Murder', 10000, 3, 80),
(13, 'Attempted Murder', 5000, 3, 45),
(14, 'Torture', 1500, 3, 15),
(15, 'Manslaughter', 750, 0, 30),
(16, 'Kidnapping', 2500, 3, 20),
(17, 'Attempted Kidnapping', 500, 3, 15),
(18, 'Assault Agrravated (weapon)', 1500, 3, 20),
(19, 'Attempted/Unarmed Robbery', 2000, 3, 10),
(20, 'Grand Theft Auto', 2500, 3, 45),
(21, 'Theft of a Motor Vehicle', 1500, 2, 10),
(22, 'Hit and Run w/ Injuries', 1500, 3, 15),
(23, 'Felony Evading/Eluding an LEO', 2500, 3, 25),
(24, 'Felony Speeding/Reckless Driving', 1500, 3, 15),
(25, 'Harboring a Fugitive', 1200, 2, 10),
(26, 'Escaping Police Custody', 2000, 3, 30),
(27, 'Criminal Threats', 200, 2, 10),
(28, 'Arson', 2500, 3, 45),
(29, 'Weapons Stockpiling/Trafficking/Sales', 5000, 3, 35),
(30, 'Possession of Burglary Tools', 1000, 2, 5),
(31, 'Possession of a Class III Weapon', 7000, 3, 45),
(32, 'Possession of a Class II Weapon', 5000, 3, 10),
(33, 'Criminal Possession of a Class I Firearm', 3000, 3, 25),
(34, 'Possession of illegal gun modifications', 2500, 3, 25),
(35, 'Possession of Dirty Money', 500, 2, 10),
(36, 'Drug Cultivation/Manufacturing', 2500, 3, 5),
(37, 'Poss. of a CDS Schedule I w/ Intent to Sell', 1500, 3, 10),
(38, 'Poss. of a CDS Schedule II w/ Intent to Sell', 2000, 3, 15),
(39, 'Poss. of a CDS Schedule III w/ Intent to Sell', 2500, 3, 20),
(40, 'Stalking', 500, 2, 10),
(41, 'Perjury', 500, 2, 10),
(42, 'Fraud', 2500, 2, 15),
(43, 'Extortion', 1500, 2, 10),
(44, 'Bribery', 500, 2, 5),
(45, 'Felonious Trespassing', 1500, 2, 10),
(46, 'Burglary', 2500, 1, 15),
(47, 'Brandishing a Firearm', 500, 2, 5),
(48, 'Negligent Discharge  of a Firearm', 800, 2, 5),
(49, 'Failure to Inform LEO', 250, 1, 0),
(50, 'Failure to Identify', 250, 1, 0),
(51, 'Reckless Endangerment', 1000, 2, 10),
(52, 'Assault Simple', 1000, 2, 5),
(53, 'Criminal Threats', 200, 1, 0),
(54, 'Contempt of Court', 500, 0, 0),
(55, 'Obstruction of Justice', 500, 1, 0),
(56, 'Vandalism/Destruction of Property', 250, 1, 0),
(57, 'Public Intoxication', 250, 1, 0),
(58, 'Resisting Arrest', 200, 1, 0),
(59, 'Disorderly Conduct/Disturbing the Peace', 500, 1, 0),
(60, 'Harassment', 250, 1, 0),
(61, 'Defmation/Slander', 150, 1, 0),
(62, 'Loitering', 50, 0, 0),
(63, 'Jay Walking', 50, 0, 0),
(64, 'Reckless Driving', 350, 1, 0),
(65, 'Attempted Grand Theft Auto', 1500, 2, 10),
(66, 'Driving While Intoxicated', 1250, 2, 10),
(67, 'Driving w/ out a License', 500, 1, 0),
(68, 'Participation in a non sanction street race', 2000, 2, 15),
(69, 'Joyriding', 1000, 2, 10),
(70, 'Illegal Vehicle Modifications', 1000, 1, 0),
(71, 'Evading Arrest ( Foot )', 500, 2, 5),
(72, 'Money Laundering', 5000, 3, 20),
(73, 'Illegal Gambling', 1500, 2, 5),
(74, 'False Identification', 1250, 2, 10),
(75, 'Failure to Comply with a Court Order', 1000, 1, 0),
(76, 'Failure to Obey a Lawful Order', 1000, 1, 0),
(77, 'Misuse/Abuse of 911', 100, 1, 0),
(78, 'False Statements ', 1000, 1, 10),
(79, 'Breaking and Entering', 2500, 2, 15),
(80, 'Trespassing', 500, 1, 0),
(81, 'Poss. Illegal Contraband', 1200, 2, 10),
(82, 'Conspiracy to Commit a Misdemeanor', 1150, 2, 10),
(83, 'Indecent Exposure', 500, 2, 5),
(84, 'Act of Sexual Intercourse in Public', 500, 2, 5),
(85, 'Failure to Stop', 250, 1, 0),
(86, 'General Speeding', 250, 1, 0),
(87, 'Speeding 15 MPH Over', 500, 1, 0),
(88, 'Speeding 30 MPH Over', 1500, 1, 0),
(89, 'Unroadworthy Vehicle', 250, 0, 0),
(90, 'Careless Driving', 750, 1, 0),
(91, 'Illegal U-Turn', 150, 1, 0),
(92, 'Illegal Window TInt', 300, 1, 0),
(93, 'Failure to Yield to Emergency Services', 300, 1, 0),
(94, 'Failure to Give Right of Way', 250, 1, 0),
(95, 'Light Law Violation', 300, 1, 0),
(96, 'Parking Violation', 200, 1, 0),
(97, 'Improper/Unsafe Turn', 150, 1, 0),
(98, 'Improper/Missing Plate', 200, 1, 0),
(99, 'Wrong Way of Travel', 500, 1, 0),
(100, 'Improper/Illegal Passing', 200, 1, 0),
(101, 'Failure to Maintain Lane', 200, 1, 0),
(102, 'Illegal Use of Sirens/ELS', 300, 0, 0),
(103, 'Obstructing/Impeding', 2500, 2, 10),
(104, 'Possession of Stolen Property', 5000, 2, 10);
(105, 'Assault(NO weapon)', 2000, 2, 10),

ALTER TABLE `fine_types`
  ADD PRIMARY KEY (`id`);