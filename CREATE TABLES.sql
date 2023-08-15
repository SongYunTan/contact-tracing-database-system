CREATE TABLE Person (
	user_id int NOT NULL,
	email VARCHAR(60),
	name VARCHAR(60) NOT NULL,
	sex CHAR(1) NOT NULL,
	birthday DATE,
	hometown VARCHAR(60),
	phone_number CHAR(8),
	company_id int,
	is_contact_person BIT,
	is_admin BIT,
	PRIMARY KEY (user_id),
	UNIQUE(user_id, phone_number),
    UNIQUE(user_id, email)
);

CREATE TABLE Company (
    company_id int NOT NULL,
    mailing_address VARCHAR(255),
    contact_email VARCHAR(255) NOT NULL,
    PRIMARY KEY (company_id),
    UNIQUE(company_id, contact_email)
);

CREATE TABLE Location (
	location_id int NOT NULL,
	address VARCHAR(255),
	name VARCHAR(255),
	description VARCHAR(255),
	X_coordinate Decimal NOT NULL,
	Y_coordinate Decimal NOT NULL,
	PRIMARY KEY (location_id),
	UNIQUE(location_id, address, X_coordinate, Y_coordinate),
);

CREATE TABLE Message ( 
    msg_id int NOT NULL PRIMARY KEY, 
    msg_user_id int NOT NULL,
    msg_timestamp DATETIME NOT NULL,
    msg_text VARCHAR(255),
    location_id int,
    -- NO ACTION for LOCATION. Keep old messages for deleted locations.
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (msg_user_id) REFERENCES Person(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE Comment ( 
    msg_id int NOT NULL, 
    cmt_user_id int NOT NULL,
    cmt_timestamp DATETIME NOT NULL,
    cmt_text VARCHAR(255),
    CONSTRAINT PK_Comment PRIMARY KEY (msg_id, cmt_user_id, cmt_timestamp),
    -- if a message is deleted, all comments will be deleted as well 
    FOREIGN KEY(msg_id) REFERENCES Message(msg_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    -- if user is deleted, their comments still remain 
    FOREIGN KEY (cmt_user_id) REFERENCES Person(user_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);


CREATE TABLE be_family ( 
    user1_id int NOT NULL, 
    user2_id int NOT NULL,
    relationship VARCHAR(255),
    CONSTRAINT PK_be_family PRIMARY KEY (user1_id, user2_id),
    -- user1 is the person initiating the relationship. family relationship will be deleted if user1 stops existing
    FOREIGN KEY(user1_id) REFERENCES Person(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    -- user2 cannot be deleted if person1 still exists and relationship still exists
    FOREIGN KEY(user2_id) REFERENCES Person(user_id)
);



CREATE TABLE Coordinate ( 
    time_stamp DATETIME NOT NULL,
    x float NOT NULL,
    y float NOT NULL,
    user_id int NOT NULL FOREIGN KEY REFERENCES Person(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT PK_Coordinate PRIMARY KEY (time_stamp, user_id), 
);

CREATE TABLE Schedule ( 
	user_id int NOT NULL,
    time_stamp DATETIME NOT NULL,
    clinic_location VARCHAR(255) NOT NULL, 
    test_result VARCHAR(255),
    CONSTRAINT PK_Schedule PRIMARY KEY (user_id, time_stamp), 
    FOREIGN KEY(user_id) REFERENCES Person(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE, 
);

CREATE TABLE Category (
    category_name VARCHAR(255) PRIMARY KEY
);

CREATE TABLE hasCategory ( 
    location_id int NOT NULL,
    category_name VARCHAR(255) NOT NULL, 
    CONSTRAINT PK_hasCategory PRIMARY KEY (location_id, category_name), 
    -- if location is deleted, no need to keep record anymore 
    FOREIGN KEY(location_id) REFERENCES Location(location_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    -- if location still exists, category should not be deleted or changed
    FOREIGN KEY(category_name) REFERENCES Category(category_name)
);

CREATE TABLE Contain ( 
    childCat VARCHAR(255) NOT NULL,
    parentCat VARCHAR(255) NOT NULL, 
    CONSTRAINT PK_Contain PRIMARY KEY (childCat, parentCat),
    -- child category initiates the relationship. if childCat is deleted, deleted the record
    FOREIGN KEY(childCat) REFERENCES Category(category_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    -- if childCat still exits, parent category parentCat cannot be deleted from the category table 
    FOREIGN KEY(parentCat) REFERENCES Category(category_name)
);

CREATE TABLE Associate (
    company_id int NOT NULL,
    location_id int NOT NULL,
    CONSTRAINT PK_Associate PRIMARY KEY (company_id, location_id),
    -- a location can have no company but a company cannot have no location
    -- if a company is deleted, the relationship to a location is automatically removed
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    -- if company still exsists and relationship is stil valid, location cannot be deleted
    FOREIGN KEY (location_id) REFERENCES Location(location_id)

);

CREATE TABLE Temperature ( 
    user_id int NOT NULL, 
    timestamp DATETIME NOT NULL,
    temperature float,
    CONSTRAINT PK_Temperature PRIMARY KEY (user_id, timestamp),
    FOREIGN KEY(user_id) REFERENCES Person(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
);

CREATE TABLE Check_in_out ( 
    user_id int NOT NULL,
    location_id int NOT NULL,
    check_in_time DATETIME NOT NULL, 
    check_out_time DATETIME, 
    CONSTRAINT PK_Check_in_out PRIMARY KEY (user_id, location_id, check_in_time), 
    FOREIGN KEY (user_id) REFERENCES Person(user_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    -- keep a history of locations a person visits, even if location no longer exists
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
        ON DELETE NO ACTION 
        ON UPDATE NO ACTION,
);

CREATE TABLE Rating ( 
    user_id int NOT NULL,
    check_in_time DATETIME NOT NULL,
    location_id int NOT NULL, 
    rate int NOT NULL, 
    review VARCHAR(255),
    CONSTRAINT PK_Rating PRIMARY KEY (user_id, check_in_time), 
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
);



