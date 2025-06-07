

-- Tạo bảng Divisions
CREATE TABLE Divisions (
    id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);

-- Tạo bảng Users
CREATE TABLE Users (
    id INT IDENTITY PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    manager_id INT NULL,
    division_id INT NOT NULL,
    FOREIGN KEY (manager_id) REFERENCES Users(id),
    FOREIGN KEY (division_id) REFERENCES Divisions(id)
);

-- Tạo bảng Roles
CREATE TABLE Roles (
    id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
);

-- Tạo bảng UserRole
CREATE TABLE UserRole (
    user_id INT,
    role_id INT,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

-- Tạo bảng Features
CREATE TABLE Features (
    id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    path NVARCHAR(200) NOT NULL
);

-- Tạo bảng RoleFeature
CREATE TABLE RoleFeature (
    role_id INT,
    feature_id INT,
    PRIMARY KEY (role_id, feature_id),
    FOREIGN KEY (role_id) REFERENCES Roles(id),
    FOREIGN KEY (feature_id) REFERENCES Features(id)
);

-- Tạo bảng Requests
CREATE TABLE Requests (
    id INT IDENTITY PRIMARY KEY,
    title NVARCHAR(100) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    reason NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(20) NOT NULL CHECK (status IN ('Inprogress', 'Approved', 'Rejected')) DEFAULT 'Inprogress',
    created_by INT NOT NULL,
    processed_by INT NULL,
    processed_note NVARCHAR(MAX),
    FOREIGN KEY (created_by) REFERENCES Users(id),
    FOREIGN KEY (processed_by) REFERENCES Users(id)
);
