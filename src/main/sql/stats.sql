SELECT COUNT(*) FROM houses;

SELECT state, COUNT(*) FROM houses GROUP BY state;

SELECT change, COUNT(*) FROM houses GROUP BY change;

SELECT status, COUNT(*) FROM houses GROUP BY status;