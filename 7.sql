CREATE DATABASE My_database_2;
USE My_database_2;

CREATE TABLE reference_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ref_name VARCHAR(255) UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE main_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2),
    blob_data BLOB,
    ref_id INT,
    INDEX idx_created_at (created_at),
    FOREIGN KEY (ref_id) REFERENCES reference_table(id)
        ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE child_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    main_id INT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (main_id) REFERENCES main_table(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_created_at (created_at)
);

INSERT INTO reference_table (ref_name) VALUES
('Item 1'),
('Item 2'),
('Item 3'),
('Item 4'),
('Item 5'),
('Item 6'),
('Item 7');

INSERT INTO main_table (name, amount, ref_id) VALUES
('Item 1', 10.00, 1),
('Item 2', 15.50, 2),
('Item 3', 20.00, 3),
('Item 4', 5.25, 4),
('Item 5', 12.10, 5),
('Item 6', 8.50, 6),
('Item 7', 30.00, 7),
('Item 7', 50.00, 7);

INSERT INTO child_table (main_id, description) VALUES
(1, 'Description for Item 1'),
(1, 'Another Description for Item 1'),
(2, 'Description for Item 2'),
(3, 'Description for Item 3'),
(3, 'Another Description for Item 3'),
(5, 'Description for Item 5'),
(5, 'Another description for Item 5'),
(6, 'Description for Item 6'),
(6, 'Another description for Item 6'),
(6, 'Third description for Item 6'),
(7, 'Description for Item 7'),
(7, 'Another description for Item 7'),
(7, 'Third escription for Item 7'),
(7, 'And another description for Item 7'),
(7, 'And another one bites the dust');

CREATE VIEW main_child_view AS
SELECT mt.id, mt.name, ct.description
FROM main_table mt
JOIN child_table ct ON mt.id = ct.main_id;

CREATE FUNCTION format_date(input_date DATETIME) 
RETURNS VARCHAR(255) 
DETERMINISTIC 
RETURN DATE_FORMAT(input_date, '%Y-%m-%d %H:%i:%s');

CREATE PROCEDURE get_average_amount()
SELECT AVG(amount) FROM main_table;

DELIMITER //

CREATE TRIGGER trg_prevent_insert
BEFORE INSERT ON main_table
FOR EACH ROW
BEGIN
    DECLARE ref_count INT; 
    SELECT COUNT(*) INTO ref_count FROM reference_table WHERE ref_name = NEW.name; 

    IF ref_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot insert, reference not found.';  
    END IF;
END; //

DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_cascade_delete
AFTER DELETE ON reference_table
FOR EACH ROW
BEGIN
    DELETE FROM child_table WHERE main_id IN (SELECT id FROM main_table WHERE name = OLD.ref_name);
    DELETE FROM main_table WHERE name = OLD.ref_name;
END; //

DELIMITER ;

SELECT * FROM main_table;
SELECT * FROM main_child_view;
SELECT format_date(NOW());

UPDATE main_table SET name = 'Item A' WHERE id = 1;
DELETE FROM main_table WHERE id = 1;

ALTER TABLE main_table MODIFY blob_data MEDIUMBLOB;
UPDATE main_table SET blob_data = LOAD_FILE('C:\\DB\\Pictures\\unknown.jpg') WHERE id = 5;

INSERT INTO main_table (name, amount) VALUES ('New Item', 25.00);
DELETE FROM reference_table WHERE id = 1;

CALL get_average_amount();
