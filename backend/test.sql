-- Create Database and User
CREATE DATABASE IF NOT EXISTS react_node_app;

-- Select the database to use before creating tables

USE react_node_app;

-- Create Tables
CREATE TABLE IF NOT EXISTS `author` ( 
  `id` int NOT NULL AUTO_INCREMENT, 
  `name` varchar(255) NOT NULL, 
  `birthday` date NOT NULL, 
  `bio` text NOT NULL, 
  `createdAt` date NOT NULL, 
  `updatedAt` date NOT NULL, 
  PRIMARY KEY (`id`) 
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci; 

CREATE TABLE IF NOT EXISTS `book` ( 
  `id` int NOT NULL AUTO_INCREMENT, 
  `title` varchar(255) NOT NULL, 
  `releaseDate` date NOT NULL, 
  `description` text NOT NULL, 
  `pages` int NOT NULL, 
  `createdAt` date NOT NULL, 
  `updatedAt` date NOT NULL, 
  `authorId` int DEFAULT NULL, 
  PRIMARY KEY (`id`), 
  KEY `FK_66a4f0f47943a0d99c16ecf90b2` (`authorId`), 
  CONSTRAINT `FK_66a4f0f47943a0d99c16ecf90b2` FOREIGN KEY (`authorId`) REFERENCES `author` (`id`) 
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert Authors
INSERT INTO `author` (`id`, `name`, `birthday`, `bio`, `createdAt`, `updatedAt`) VALUES
(1, 'veera', '1990-02-10', 'I’m pleased to introduce our trainer, a highly experienced Cloud and DevOps expert with over 10+ years of industry experience. With a deep and practical understanding of cloud platforms like AWS, Azure, and GCP, as well as modern DevOps practices, they have successfully led and mentored teams in designing, automating, and optimizing infrastructure and deployment pipelines at scale.', '2025-06-30', '2025-06-30'),
(2, 'nareshit', '2003-05-08', 'Course Offerings\nA broad range of IT and software development courses: Java, .NET, Python, Data Science, AWS, DevOps, Digital Marketing, Testing, Oracle, and more.\nOffers classroom, online, weekend, and corporate training, as well as internships and placement assistance.', '2025-06-30', '2025-06-30');

-- Insert Books
INSERT INTO `book` (`id`, `title`, `releaseDate`, `description`, `pages`, `createdAt`, `updatedAt`, `authorId`) VALUES
(1, 'AWS', '2025-07-10', 'This AWS training program is designed to provide a comprehensive understanding of Amazon Web Services (AWS), covering both core cloud concepts and advanced DevOps practices. The course begins with foundational topics such as cloud computing principles, AWS global infrastructure, and Identity and Access Management (IAM). Learners will gain hands-on experience with key AWS services including EC2 for compute, S3 and EBS for storage, and RDS and DynamoDB for databases. The syllabus includes detailed coverage of networking with VPC, security best practices, and monitoring with CloudWatch and CloudTrail.', 300, '2025-06-30', '2025-06-30', 1),
(2, 'Multicloud', '2025-07-16', 'This Multicloud training program is tailored for IT professionals seeking expertise in managing and deploying applications across multiple cloud platforms such as AWS, Microsoft Azure, and Google Cloud Platform (GCP).', 400, '2025-06-30', '2025-06-30', 1),
(3, 'Devops', '2025-07-16', 'This DevOps training program is designed to equip professionals with the skills and tools required to bridge the gap between software development and IT operations. The course begins with an introduction to DevOps principles, focusing on collaboration, automation, continuous integration, and continuous delivery (CI/CD). Participants will learn essential tools including Git for version control, Jenkins for automation, Docker for containerization, and Kubernetes for orchestration. The syllabus also covers configuration management using Ansible along with Infrastructure as Code (IaC) practices using Terraform.', 500, '2025-06-30', '2025-06-30', 1),
(4, 'Full Stack Development', '2025-07-20',
'This Full Stack Development course offered by Naresh IT is structured to provide comprehensive training in both front-end and back-end technologies. It includes hands-on learning of HTML, CSS, JavaScript, React.js for UI development, and Node.js, Express, and MongoDB for server-side and database skills. The course also covers deployment strategies and DevOps basics, making learners job-ready for modern web application development.',
300, '2025-06-30', '2025-06-30', 2);
