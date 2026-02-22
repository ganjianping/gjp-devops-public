-- Create the sample database
CREATE DATABASE IF NOT EXISTS sample_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sample_db;

-- Drop the table if it already exists
DROP TABLE IF EXISTS all_types_demo;

-- Create a table covering all major MySQL field types
CREATE TABLE all_types_demo (
    -- Numeric Types
    id INT AUTO_INCREMENT PRIMARY KEY,
    tiny_int_col TINYINT,
    small_int_col SMALLINT,
    medium_int_col MEDIUMINT,
    int_col INT,
    big_int_col BIGINT,
    decimal_col DECIMAL(10, 2),
    float_col FLOAT,
    double_col DOUBLE,
    bit_col BIT(8),

    -- Date and Time Types
    date_col DATE,
    time_col TIME,
    datetime_col DATETIME,
    timestamp_col TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    year_col YEAR,

    -- String Types
    char_col CHAR(10),
    varchar_col VARCHAR(255),
    tinytext_col TINYTEXT,
    text_col TEXT,
    mediumtext_col MEDIUMTEXT,
    longtext_col LONGTEXT,

    -- Binary Types
    binary_col BINARY(10),
    varbinary_col VARBINARY(255),
    blob_col BLOB,

    -- Enum and Set Types
    enum_col ENUM('small', 'medium', 'large'),
    set_col SET('a', 'b', 'c', 'd'),

    -- JSON Type
    json_col JSON,

    -- Spatial Types (Geometry)
    point_col POINT,
    polygon_col POLYGON
);

-- Insert demo rows
INSERT INTO all_types_demo (
    tiny_int_col, small_int_col, medium_int_col, int_col, big_int_col,
    decimal_col, float_col, double_col, bit_col,
    date_col, time_col, datetime_col, year_col,
    char_col, varchar_col, tinytext_col, text_col, mediumtext_col, longtext_col,
    binary_col, varbinary_col, blob_col,
    enum_col, set_col,
    json_col,
    point_col, polygon_col
) VALUES 
(
    127, 32767, 8388607, 2147483647, 9223372036854775807,
    99999999.99, 3.14159, 2.718281828459, b'10101010',
    '2026-02-22', '14:30:00', '2026-02-22 14:30:00', 2026,
    'FixedChar', 'Variable length string demo', 'Short text', 'Standard text content', 'Medium length text content', 'Very long text content goes here...',
    CAST('BinaryData' AS BINARY), CAST('VarBinaryData' AS BINARY), CAST('BlobDataContent' AS BINARY),
    'medium', 'a,c',
    '{"key1": "value1", "key2": 42, "nested": {"flag": true}}',
    ST_GeomFromText('POINT(1 1)'), ST_GeomFromText('POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))')
),
(
    -128, -32768, -8388608, -2147483648, -9223372036854775808,
    -1234.56, -1.23, -9.87654321, b'01010101',
    '2020-01-01', '08:00:00', '2020-01-01 08:00:00', 2020,
    'Char2', 'Another varchar example', 'Tiny text 2', 'Text 2', 'Medium text 2', 'Long text 2',
    CAST('Bin2' AS BINARY), CAST('VarBin2' AS BINARY), CAST('Blob2' AS BINARY),
    'large', 'b,d',
    '["array_item1", "array_item2", 3]',
    ST_GeomFromText('POINT(-5 -5)'), ST_GeomFromText('POLYGON((1 1, 5 1, 5 5, 1 5, 1 1))')
);
