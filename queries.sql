DROP TABLE user_table;
DROP TABLE DownloadMovie;
DROP TABLE SalesData;

-- Creating a User_Table;
CREATE TABLE user_table
(
 userid VARCHAR(50) PRIMARY KEY,
 name VARCHAR2(50) NOT NULL,
 emailaddress VARCHAR(255) UNIQUE NOT NULL
);

-- Insert table rows into User Table;

INSERT ALL
    INTO user_table VALUES ('simon3','Simon, S','simon3@hotmail.co.uk')
    INTO user_table VALUES ('talia11','Talia, J','talia11@ntl.co.uk')
    INTO user_table VALUES ('toby05','Toby, T','toby05@freeserve.co.uk')
    INTO user_table VALUES ('margot9','Margot, C','margot9@msn.co.uk')
    INTO user_table VALUES ('ethan77','Ethan, R','ethan77@hotmail.co.uk')
    INTO user_table VALUES ('nancy91','Nancy, L','nancy91@tesco.co.uk')
SELECT * from dual;

select * from user_table;

-- Creating table Movie

CREATE TABLE movie
(
movieid VARCHAR(50) PRIMARY KEY,
title VARCHAR(250),
categoryCode VARCHAR(50),
costPerDownload DECIMAL(10,2),
FOREIGN KEY (categoryCode) REFERENCES movie_category(categoryCode)
)

-- Insert records to Movie table.

INSERT ALL
    INTO movie VALUES('M001','The Imitation Game','MO13',0.99)
    INTO movie VALUES('M002','The Duchess','MO13',1.99)
    INTO movie VALUES('M003','Trainspotting','MO11',1.49)
    INTO movie VALUES('M004','The Dig','MO11',1.79)
    INTO movie VALUES('M005','Elizabeth','MO13',1.50)
    INTO movie VALUES('M006','Sherlock Holmes','MO12',1.10)
    INTO movie VALUES('M007','Moon','MO12',0.89)
SELECT * from dual;

SELECT * from movie;

-- Create table DownloadMovie;

CREATE TABLE DownloadMovie
(
    userid VARCHAR2(50),
    movieid VARCHAR(50),
    downloadDate DATE,
    FOREIGN KEY (userid) REFERENCES user_table(userid),
    FOREIGN KEY (movieid) REFERENCES movie(movieid)
);

INSERT ALL
    INTO DownloadMovie VALUES('simon3','M002',TO_DATE('03-May-2021','DD-Mon-YYYY'))
    INTO DownloadMovie VALUES('margot9','M005',TO_DATE('01-May-2022','DD-Mon-YYYY'))
    INTO DownloadMovie VALUES('talia11','M002',TO_DATE('06-May-2021','DD-Mon-YYYY'))
    INTO DownloadMovie VALUES('margot9','M001',TO_DATE('06-May-2022','DD-Mon-YYYY'))
    INTO DownloadMovie VALUES('simon3','M003',TO_DATE('01-Aug-2022','DD-Mon-YYYY'))
    INTO DownloadMovie VALUES('ethan77','M004',TO_DATE('02-Aug-2022','DD-Mon-YYYY'))
    INTO DownloadMovie VALUES('nancy91','M007',TO_DATE('05-Sep-2021','DD-Mon-YYYY'))
SELECT * from dual;

SELECT * from DownloadMovie;


-- Create Category Table

CREATE TABLE movie_category
(
categoryCode VARCHAR2(10) PRIMARY KEY,
title VARCHAR2(20) NOT NULL
);

INSERT ALL
    INTO movie_category VALUES('MO11','Drama')
    INTO movie_category VALUES('MO12','Fiction')
    INTO movie_category VALUES('MO13','Biopic')
SELECT * from dual;

SELECT * FROM movie_category;


--  The movie id, the title and the categoryCode of all the movie in the database, ordered by title.;
SELECT movieid, title, categoryCode FROM movie
ORDER BY title;


-- Insert a category named "Pop-Rock" in movie_category table;
INSERT INTO movie_category (categoryCode, title)
VALUES ('PR01', 'Pop-Rock');

-- Insert record into movie table;
INSERT INTO movie (movieid, title, categoryCode, costPerDownload)
VALUES ('M008', 'Bohemian Rhapsody', 'PR01', 2.49);

-- Insert three DownloadMovie table
INSERT INTO DownloadMovie (userid, movieid, downloadDate)
VALUES ('ethan77', 'M008', TO_DATE('10-Aug-2021','DD-Mon-YYYY'));
INSERT INTO DownloadMovie (userid, movieid, downloadDate)
VALUES ('talia11', 'M008', TO_DATE('19-May-2021','DD-Mon-YYYY'));
INSERT INTO DownloadMovie (userid, movieid, downloadDate)
VALUES ('simon3', 'M008', TO_DATE('14-Jun-2021','DD-Mon-YYYY'));

--The number of users who downloaded ‘Pop-Rock’ category of movie. ;
SELECT COUNT(DISTINCT dom.userid) AS num_users_pop
FROM DownloadMovie dom
JOIN movie mo ON dom.movieid = mo.movieid
JOIN movie_category moc ON mo.categoryCode = moc.categoryCode
WHERE moc.title = 'Pop-Rock';


-- The number of movie downloads for each of the categories. The result listing should 
-- include the titles of the categories and the number of movie downloads for each category 
-- title

SELECT moc.title, COUNT(dom.movieid) AS num_downloads_cat
FROM movie_category moc
LEFT JOIN movie mo ON moc.categoryCode = mo.categoryCode
JOIN DownloadMovie dom ON mo.movieid = dom.movieid
GROUP BY moc.title;


-- The titles of the categories for which movie was downloaded more than once.
SELECT moc.title
FROM movie_category moc
JOIN movie mo ON moc.categoryCode = mo.categoryCode
JOIN DownloadMovie dom ON mo.movieid = dom.movieid
GROUP BY moc.title
HAVING COUNT(dom.movieid) > 1;




-- Assuming that the data is stored in a relational database produce, with justification, the SQL
-- code to determine, for each product, the number of products which were sold in each month
-- of each year.

CREATE TABLE SalesData (
    OrderNo INT,
    ProductNo INT,
    Price FLOAT,
    Quantity INT,
    Sales FLOAT,
    QtrId INT CHECK (QtrId BETWEEN 1 AND 4),
    MonthId INT CHECK (MonthId BETWEEN 1 AND 12),
    YearId INT
);


INSERT ALL
    INTO SalesData VALUES(10107, 2, 85.7, 30, 2587, 1, 2, 2003)
    INTO SalesData VALUES(10107, 5, 95.8, 39, 3879.49, 1, 2, 2003)
    INTO SalesData VALUES(10121, 5, 71.5, 34, 2700, 1, 2, 2003)
    INTO SalesData VALUES(10134, 2, 94.74, 41, 3884.34, 3, 7, 2004)
    INTO SalesData VALUES(10134, 5, 100, 27, 3307.77, 3, 7, 2004)
    INTO SalesData VALUES(10159, 14, 100, 49, 5205.27, 4, 10, 2005)
    INTO SalesData VALUES(10168, 1, 96.66, 36, 3479.66, 4, 10, 2006)
    INTO SalesData VALUES(10180, 12, 100, 42, 4695.6, 4, 11, 2006)
SELECT * from dual;

SELECT * FROM SalesData;

SELECT
    ProductNo,
    YearID,
    MonthId,
    SUM(Quantity) AS QuantitySold
FROM
    SalesData 
GROUP BY
    ProductNo,
    YearID,
    MonthId
ORDER BY
    YearID,
    MonthId;

