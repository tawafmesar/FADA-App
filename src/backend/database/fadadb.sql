-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 30, 2025 at 01:55 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fadadb`
--

-- --------------------------------------------------------

--
-- Table structure for table `allergenic_derivatives`
--

CREATE TABLE `allergenic_derivatives` (
  `id` int(11) NOT NULL,
  `allergenic_ingredient_id` int(11) NOT NULL,
  `derivative_name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `allergenic_derivatives`
--

INSERT INTO `allergenic_derivatives` (`id`, `allergenic_ingredient_id`, `derivative_name`, `description`) VALUES
(1, 1, 'Casein', 'Casein is a protein found in milk.'),
(2, 1, 'Whey', 'Whey is a milk byproduct used in various foods.'),
(3, 2, 'Egg Whites', 'Egg Whites are commonly used in baking and cooking.'),
(4, 2, 'Albumin', 'Albumin is a protein found in egg whites.'),
(5, 3, 'Peanut Butter', 'Peanut Butter is a processed form of peanuts.'),
(6, 3, 'Peanut Oil', 'Peanut Oil is extracted from peanuts and used in cooking.'),
(7, 4, 'Almonds', 'Almonds are a type of tree nut.'),
(8, 4, 'Cashews', 'Cashews are another common tree nut.'),
(9, 5, 'Salmon', 'Salmon is a popular fish allergen.'),
(10, 5, 'Tuna', 'Tuna is another fish that can cause allergies.'),
(11, 6, 'Shrimp', 'Shrimp are shellfish that can trigger allergic reactions.'),
(12, 6, 'Lobster', 'Lobster is another type of shellfish allergen.'),
(13, 7, 'Soy Sauce', 'Soy Sauce is a fermented soy product.'),
(14, 7, 'Soy Lecithin', 'Soy Lecithin is used as an emulsifier in many foods.'),
(15, 8, 'Whole Wheat', 'Whole Wheat contains gluten proteins.'),
(16, 8, 'Gluten', 'Gluten is a protein found in wheat and related grains.'),
(17, 9, 'Tahini', 'Tahini is a sesame seed paste used in various cuisines.'),
(18, 9, 'Sesame Oil', 'Sesame Oil is extracted from sesame seeds.'),
(19, 10, 'Mustard Flour', 'Mustard Flour is ground mustard seeds used in cooking.'),
(20, 10, 'Mustard Seeds', 'Mustard Seeds are used as a spice and in condiments.'),
(21, 11, 'Sodium Sulphite', 'Sodium Sulphite is a preservative used in foods and beverages.'),
(22, 11, 'Potassium Metabisulfite', 'Potassium Metabisulfite is used as a preservative and antioxidant.'),
(23, 12, 'Celery Salt', 'Celery Salt is a seasoning made from celery and salt.'),
(24, 12, 'Celery Powder', 'Celery Powder is used as a seasoning in various dishes.'),
(25, 13, 'Lupin Flour', 'Lupin Flour is made from lupin beans and used in baking.'),
(26, 13, 'Lupin Protein', 'Lupin Protein is extracted from lupin beans for use in foods.'),
(27, 14, 'Gluten Protein', 'Gluten Protein is derived from wheat and related grains.'),
(28, 15, 'Palm Kernel Oil', 'Palm Kernel Oil is extracted from the kernel of the palm fruit.'),
(29, 16, 'Monosodium Glutamate', 'Monosodium Glutamate is a flavor enhancer used in many foods.'),
(30, 16, 'MSG', 'MSG is commonly used as a seasoning in processed foods.');

-- --------------------------------------------------------

--
-- Table structure for table `allergydb`
--

CREATE TABLE `allergydb` (
  `id` int(11) NOT NULL,
  `ingredient_name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `created_by_user_id` int(11) DEFAULT NULL,
  `is_system` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `allergydb`
--

INSERT INTO `allergydb` (`id`, `ingredient_name`, `description`, `created_by_user_id`, `is_system`) VALUES
(1, 'Milk', 'Contains milk proteins like casein and whey.', NULL, 1),
(2, 'Eggs', 'Egg-related allergies including egg whites and albumin.', NULL, 1),
(3, 'Peanuts', 'Peanut allergies, common derivatives include peanut butter and oil.', NULL, 1),
(4, 'Tree Nuts', 'Tree nuts such as almonds and cashews.', NULL, 1),
(5, 'Fish', 'Fish allergens like salmon and tuna.', NULL, 1),
(6, 'Shellfish', 'Shellfish allergens including shrimp and lobster.', NULL, 1),
(7, 'Soy', 'Soy products like soy sauce and soy lecithin.', NULL, 1),
(8, 'Wheat', 'Wheat-related allergens including whole wheat and gluten.', NULL, 1),
(9, 'Sesame', 'Sesame derivatives such as tahini and sesame oil.', NULL, 1),
(10, 'Mustard', 'Mustard products like mustard flour and seeds.', NULL, 1),
(11, 'Sulphites', 'Sulphite compounds including sodium sulphite.', NULL, 1),
(12, 'Celery', 'Celery derivatives like celery salt and powder.', NULL, 1),
(13, 'Lupin', 'Lupin-based products such as lupin flour.', NULL, 1),
(14, 'Gluten', 'Gluten proteins and related compounds.', NULL, 1),
(15, 'Palm Oil', 'Palm oil derivatives like palm kernel oil.', NULL, 1),
(16, 'Glutamate', 'Monosodium glutamate and related additives.', NULL, 1),
(21, 'sassasa', 'sadasdas', 1, 0),
(23, 'dfsfsfdsas', '121212', NULL, 0),
(24, 'asaas', '', 1, 0),
(25, 'the', '', NULL, 0),
(26, 'the', '', 11, 0);

-- --------------------------------------------------------

--
-- Table structure for table `userallergen`
--

CREATE TABLE `userallergen` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `allergy_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `userallergen`
--

INSERT INTO `userallergen` (`id`, `user_id`, `allergy_id`, `created_at`) VALUES
(1, 1, 1, '2025-01-27 03:57:50'),
(2, 1, 3, '2025-01-27 03:57:50'),
(21, 1, 6, '2025-01-29 16:59:30'),
(22, 1, 2, '2025-01-29 16:59:34'),
(24, 11, 3, '2025-01-29 23:45:09'),
(28, 11, 4, '2025-01-29 23:51:49'),
(30, 11, 5, '2025-01-29 23:51:59'),
(31, 11, 7, '2025-01-29 23:52:02');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `users_id` int(11) NOT NULL,
  `users_name` varchar(100) NOT NULL,
  `users_password` varchar(255) NOT NULL,
  `users_email` varchar(100) NOT NULL,
  `users_verfiycode` int(11) NOT NULL,
  `users_approve` tinyint(4) NOT NULL DEFAULT 0,
  `users_role` int(11) NOT NULL,
  `users_create` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`users_id`, `users_name`, `users_password`, `users_email`, `users_verfiycode`, `users_approve`, `users_role`, `users_create`) VALUES
(1, 'Hayat Ali', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'hayatali@gmail.com', 95820, 1, 1, '2024-12-19 22:15:27'),
(2, 'Admin', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'admin@gmail.com', 91120, 1, 2, '2024-12-19 22:15:27'),
(6, 'adda', 'dasasd', 'asdasd', 12321, 0, 1, '2025-01-05 00:18:01'),
(11, 'Tawaf Mesar', '20eabe5d64b0e216796e834f52d61fd0b70332fc', 'tawafmesar@gmail.com', 23281, 1, 1, '2025-01-29 21:17:11');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `allergenic_derivatives`
--
ALTER TABLE `allergenic_derivatives`
  ADD PRIMARY KEY (`id`),
  ADD KEY `allergenic_ingredient_id` (`allergenic_ingredient_id`);

--
-- Indexes for table `allergydb`
--
ALTER TABLE `allergydb`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by_user_id` (`created_by_user_id`);

--
-- Indexes for table `userallergen`
--
ALTER TABLE `userallergen`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_allergy_unique` (`user_id`,`allergy_id`),
  ADD KEY `fk_userallergen_allergy` (`allergy_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`users_id`),
  ADD UNIQUE KEY `users_email` (`users_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `allergenic_derivatives`
--
ALTER TABLE `allergenic_derivatives`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `allergydb`
--
ALTER TABLE `allergydb`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `userallergen`
--
ALTER TABLE `userallergen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `users_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `allergenic_derivatives`
--
ALTER TABLE `allergenic_derivatives`
  ADD CONSTRAINT `allergenic_derivatives_ibfk_1` FOREIGN KEY (`allergenic_ingredient_id`) REFERENCES `allergydb` (`id`);

--
-- Constraints for table `allergydb`
--
ALTER TABLE `allergydb`
  ADD CONSTRAINT `allergydb_ibfk_1` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`users_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `userallergen`
--
ALTER TABLE `userallergen`
  ADD CONSTRAINT `fk_userallergen_allergy` FOREIGN KEY (`allergy_id`) REFERENCES `allergydb` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_userallergen_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`users_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
