-- Create sample database
-- Note: If running via a script that doesn't support CREATE DATABASE in the same transaction,
-- you may need to create the database first and then connect to it.
-- CREATE DATABASE sample_db;

-- Connect to the database (psql specific command, uncomment if running via psql)
-- \c sample_db;

-- Create a sample schema
CREATE SCHEMA IF NOT EXISTS sample_schema;

-- Set the search path to the new schema
SET search_path TO sample_schema;

-- Create an ENUM type for demonstration
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'mood') THEN
        CREATE TYPE mood AS ENUM ('sad', 'ok', 'happy');
    END IF;
END
$$;

-- Create a composite type for demonstration
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'address') THEN
        CREATE TYPE address AS (
            city VARCHAR(90),
            street VARCHAR(90)
        );
    END IF;
END
$$;

-- Create the all_types_demo table
CREATE TABLE IF NOT EXISTS all_types_demo (
    -- 1. Numeric Types
    id SERIAL PRIMARY KEY,
    small_int_col SMALLINT,
    integer_col INTEGER,
    big_int_col BIGINT,
    decimal_col DECIMAL(10, 2),
    numeric_col NUMERIC(10, 2),
    real_col REAL,
    double_precision_col DOUBLE PRECISION,
    small_serial_col SMALLSERIAL,
    big_serial_col BIGSERIAL,

    -- 2. Monetary Types
    money_col MONEY,

    -- 3. Character Types
    varchar_col VARCHAR(255),
    char_col CHAR(10),
    text_col TEXT,

    -- 4. Binary Data Types
    bytea_col BYTEA,

    -- 5. Date/Time Types
    timestamp_col TIMESTAMP,
    timestamp_tz_col TIMESTAMP WITH TIME ZONE,
    date_col DATE,
    time_col TIME,
    time_tz_col TIME WITH TIME ZONE,
    interval_col INTERVAL,

    -- 6. Boolean Type
    boolean_col BOOLEAN,

    -- 7. Enumerated Types
    enum_col mood,

    -- 8. Geometric Types
    point_col POINT,
    line_col LINE,
    lseg_col LSEG,
    box_col BOX,
    path_col PATH,
    polygon_col POLYGON,
    circle_col CIRCLE,

    -- 9. Network Address Types
    cidr_col CIDR,
    inet_col INET,
    macaddr_col MACADDR,
    macaddr8_col MACADDR8,

    -- 10. Bit String Types
    bit_col BIT(3),
    bit_varying_col BIT VARYING(5),

    -- 11. Text Search Types
    tsvector_col TSVECTOR,
    tsquery_col TSQUERY,

    -- 12. UUID Type
    uuid_col UUID,

    -- 13. XML Type
    xml_col XML,

    -- 14. JSON Types
    json_col JSON,
    jsonb_col JSONB,

    -- 15. Arrays
    integer_array_col INTEGER[],
    text_array_col TEXT[][],

    -- 16. Composite Types
    composite_col address,

    -- 17. Range Types
    int4range_col INT4RANGE,
    int8range_col INT8RANGE,
    numrange_col NUMRANGE,
    tsrange_col TSRANGE,
    tstzrange_col TSTZRANGE,
    daterange_col DATERANGE,

    -- 18. Object Identifier Types
    oid_col OID,

    -- 19. pg_lsn Type
    pg_lsn_col PG_LSN
);

-- Insert a demo row
INSERT INTO all_types_demo (
    small_int_col, integer_col, big_int_col, decimal_col, numeric_col, real_col, double_precision_col,
    money_col,
    varchar_col, char_col, text_col,
    bytea_col,
    timestamp_col, timestamp_tz_col, date_col, time_col, time_tz_col, interval_col,
    boolean_col,
    enum_col,
    point_col, line_col, lseg_col, box_col, path_col, polygon_col, circle_col,
    cidr_col, inet_col, macaddr_col, macaddr8_col,
    bit_col, bit_varying_col,
    tsvector_col, tsquery_col,
    uuid_col,
    xml_col,
    json_col, jsonb_col,
    integer_array_col, text_array_col,
    composite_col,
    int4range_col, int8range_col, numrange_col, tsrange_col, tstzrange_col, daterange_col,
    oid_col,
    pg_lsn_col
) VALUES (
    32767, 2147483647, 9223372036854775807, 12345678.90, 12345678.90, 123.45, 123.456789,
    1000.00,
    'Variable character string', 'FixedChar ', 'This is a very long text string.',
    E'\\xDEADBEEF',
    '2026-02-22 14:30:00', '2026-02-22 14:30:00+00', '2026-02-22', '14:30:00', '14:30:00+00', '1 year 2 months 3 days 4 hours 5 minutes 6 seconds',
    TRUE,
    'happy',
    '(1,2)', '{1,2,3}', '[(1,2),(3,4)]', '((1,2),(3,4))', '((1,2),(3,4))', '((1,2),(3,4),(5,6))', '<(1,2),3>',
    '192.168.100.128/25', '192.168.100.128', '08:00:2b:01:02:03', '08:00:2b:01:02:03:04:05',
    B'101', B'1010',
    to_tsvector('english', 'The quick brown fox jumps over the lazy dog'), to_tsquery('english', 'fox & dog'),
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    '<book><title>PostgreSQL Manual</title></book>',
    '{"key": "value"}', '{"key": "value"}',
    '{1, 2, 3}', '{{"meeting", "lunch"}, {"training", "presentation"}}',
    ROW('San Francisco', 'Main St'),
    '[1, 10)', '[1, 10)', '[1.5, 10.5)', '[2026-01-01 00:00, 2026-12-31 23:59)', '[2026-01-01 00:00+00, 2026-12-31 23:59+00)', '[2026-01-01, 2026-12-31)',
    12345,
    '16/B374D848'
);
