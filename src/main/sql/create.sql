CREATE TABLE IF NOT EXISTS homes (
    mls INTEGER NOT NULL PRIMARY KEY UNIQUE,
    change VARCHAR(100),
    state VARCHAR(2),
    address VARCHAR(500),
    price INTEGER,
    status VARCHAR(25),
    link VARCHAR(500),
    thumbnail VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS uploads (
    mls INTEGER NOT NULL PRIMARY KEY UNIQUE,
    state VARCHAR(2),
    address VARCHAR(500),
    price INTEGER,
    status VARCHAR(25),
    link VARCHAR(500),
    thumbnail VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS metas (
    key VARCHAR(25) NOT NULL PRIMARY KEY UNIQUE,
    value VARCHAR(100)
);

CREATE OR REPLACE FUNCTION record_change() RETURNS TRIGGER 
AS $$
    BEGIN
        IF (NEW.price <> OLD.price) THEN
            UPDATE homes SET change = 'PRICE' WHERE mls = NEW.mls;
        ELSIF (NEW.status <> OLD.status) THEN
            UPDATE homes SET change = 'STATUS' WHERE mls = NEW.mls;
        END IF;
        RETURN NULL;
    END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS record_change ON homes;

CREATE TRIGGER record_change
AFTER UPDATE OF price, status ON homes
FOR EACH ROW EXECUTE FUNCTION record_change();