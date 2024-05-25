#CREATE DATABASE PWB;

USE PWB;

CREATE TABLE User (
  user_id INT PRIMARY KEY,
  username VARCHAR(255),
  email VARCHAR(255),
  password VARCHAR(255),
  user_type ENUM('Administrator', 'ProjectManager', 'Developer', 'Customer')
);

CREATE TABLE Project (
  project_id INT PRIMARY KEY,
  name VARCHAR(255),
  description TEXT,
  start_date DATE,
  end_date DATE
);

CREATE TABLE UserProject (
  user_id INT,
  project_id INT,
  role VARCHAR(255),
  PRIMARY KEY (user_id, project_id),
  FOREIGN KEY (user_id) REFERENCES User(user_id),
  FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

CREATE TABLE Task (
  task_id INT PRIMARY KEY,
  project_id INT,
  developer_id INT,
  issue_id INT,
  title VARCHAR(255),
  description TEXT,
  priority INT,
  due_date DATE,
  status VARCHAR(255),
  FOREIGN KEY (project_id) REFERENCES Project(project_id),
  FOREIGN KEY (developer_id) REFERENCES User(user_id),
  FOREIGN KEY (issue_id) REFERENCES Issue(issue_id)
);

CREATE TABLE Issue (
  issue_id INT PRIMARY KEY,
  project_id INT,
  reporter_id INT,
  workflow_id INT,
  sprint_id INT,
  issue_type VARCHAR(255),
  summary VARCHAR(255),
  description TEXT,
  assignee_id INT,
  status VARCHAR(255),
  priority INT,
  completion_date DATE,
  FOREIGN KEY (project_id) REFERENCES Project(project_id),
  FOREIGN KEY (reporter_id) REFERENCES User(user_id),
  FOREIGN KEY (workflow_id) REFERENCES Workflow(workflow_id),
  FOREIGN KEY (sprint_id) REFERENCES Sprint(sprint_id),
  FOREIGN KEY (assignee_id) REFERENCES User(user_id)
);

CREATE TABLE Version (
  version_id INT PRIMARY KEY,
  project_id INT,
  name VARCHAR(255),
  release_date DATE,
  FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

CREATE TABLE Sprint (
  sprint_id INT PRIMARY KEY,
  project_id INT,
  name VARCHAR(255),
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

CREATE TABLE Workflow (
  workflow_id INT PRIMARY KEY,
  name VARCHAR(255),
  description TEXT
);

CREATE TABLE Comment (
  comment_id INT PRIMARY KEY,
  issue_id INT,
  user_id INT,
  content TEXT,
  timestamp TIMESTAMP,
  FOREIGN KEY (issue_id) REFERENCES Issue(issue_id),
  FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Attachment (
  attachment_id INT PRIMARY KEY,
  issue_id INT,
  file_name VARCHAR(255),
  file_type VARCHAR(255),
  file_size INT,
  upload_date DATE,
  FOREIGN KEY (issue_id) REFERENCES Issue(issue_id)
);

#insertion

-- Inserting values into the User table
INSERT INTO User (user_id, username, email, password, user_type)
VALUES (1, 'admin', 'admin@example.com', 'admin123', 'Administrator'),
       (2, 'pm', 'pm@example.com', 'pm123', 'ProjectManager'),
       (3, 'dev', 'dev@example.com', 'dev123', 'Developer'),
       (4, 'customer', 'customer@example.com', 'customer123', 'Customer');

-- Inserting values into the Project table
INSERT INTO Project (project_id, name, description, start_date, end_date)
VALUES (1, 'Project A', 'Sample project A description', '2023-01-01', '2023-12-31'),
       (2, 'Project B', 'Sample project B description', '2023-02-01', '2023-11-30');

-- Inserting values into the UserProject table
INSERT INTO UserProject (user_id, project_id, role)
VALUES (1, 1, 'Administrator'),
       (2, 1, 'ProjectManager'),
       (3, 1, 'Developer'),
       (4, 2, 'Customer');

-- Inserting values into the Task table
INSERT INTO Task (task_id, project_id, developer_id, issue_id, title, description, priority, due_date, status)
VALUES (1, 1, 3, 1, 'Task 1', 'Sample task 1 description', 1, '2023-02-15', 'In Progress'),
       (2, 1, 3, 2, 'Task 2', 'Sample task 2 description', 2, '2023-03-15', 'Not Started');

-- Inserting  values into the Issue table
INSERT INTO Issue (issue_id, project_id, reporter_id, workflow_id, sprint_id, issue_type, summary, description, assignee_id, status, priority, completion_date)
VALUES (1, 1, 2, 1, 1, 'Bug', 'Sample issue 1 summary', 'Sample issue 1 description', 3, 'Open', 1, NULL),
       (2, 1, 2, 1, 1, 'Feature', 'Sample issue 2 summary', 'Sample issue 2 description', 3, 'Open', 2, NULL);

-- Inserting  values into the Version table
INSERT INTO Version (version_id, project_id, name, release_date)
VALUES (1, 1, 'Version 1.0', '2023-06-30'),
       (2, 1, 'Version 2.0', '2023-09-30');

-- Inserting  values into the Sprint table
INSERT INTO Sprint (sprint_id, project_id, name, start_date, end_date)
VALUES (1, 1, 'Sprint 1', '2023-01-01', '2023-01-14'),
       (2, 1, 'Sprint 2', '2023-01-15', '2023-01-28');

-- Inserting values into the Workflow table
INSERT INTO Workflow (workflow_id, name, description)
VALUES (1, 'Workflow 1', 'Sample workflow 1 description'),
       (2, 'Workflow 2', 'Sample workflow 2 description');

-- Inserting  values into the Comment table
INSERT INTO Comment (comment_id, issue_id, user_id, content, timestamp)
VALUES (1, 1, 3, 'Sample comment 1', CURRENT_TIMESTAMP),
       (2, 2, 3, 'Sample comment 2', CURRENT_TIMESTAMP);

-- Inserting  values into the Attachment table
INSERT INTO Attachment (attachment_id, issue_id, file_name, file_type, file_size, upload_date)
VALUES (1, 1, 'attachment1.jpg', 'image/jpeg', 1024, '2023-05-01'),
       (2, 2, 'attachment2.pdf', 'application/pdf', 2048, '2023-05-02');
