// Connect to the sample_db database (it will be created automatically when data is inserted)
db = db.getSiblingDB('sample_db');

// Drop the collection if it already exists to ensure a clean slate
db.all_types_demo.drop();

// Create the collection explicitly (optional, but good practice)
db.createCollection('all_types_demo');

// Insert a document containing all major BSON data types
db.all_types_demo.insertOne({
    "double_field": 123.45,                                      // 1: Double
    "string_field": "Hello MongoDB",                             // 2: String
    "object_field": { "nested_key": "nested_value" },            // 3: Object
    "array_field": [1, 2, 3, "four"],                            // 4: Array
    "binary_field": BinData(0, "SGVsbG8gV29ybGQ="),              // 5: Binary data (Base64 for "Hello World")
    "undefined_field": undefined,                                // 6: Undefined (Deprecated but supported)
    "objectid_field": new ObjectId(),                            // 7: ObjectId
    "boolean_field": true,                                       // 8: Boolean
    "date_field": new Date(),                                    // 9: Date
    "null_field": null,                                          // 10: Null
    "regex_field": /pattern/i,                                   // 11: Regular Expression
    "javascript_field": Code("function() { return true; }"),     // 13: JavaScript
    "int32_field": NumberInt(100),                               // 16: 32-bit integer
    "timestamp_field": new Timestamp(),                          // 17: Timestamp
    "int64_field": NumberLong("9223372036854775807"),            // 18: 64-bit integer
    "decimal128_field": NumberDecimal("12345.6789"),             // 19: Decimal128
    "minkey_field": MinKey(),                                    // -1: Min key
    "maxkey_field": MaxKey()                                     // 127: Max key
});

print("Successfully created 'sample_db' database and 'all_types_demo' collection with all BSON types.");
