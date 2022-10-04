SELECT COUNT(*) FROM homes;

SELECT state, COUNT(*) FROM homes GROUP BY state;

SELECT change, COUNT(*) FROM homes GROUP BY change;

SELECT status, COUNT(*) FROM homes GROUP BY status;