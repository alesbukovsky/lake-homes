CREATE TABLE IF NOT EXISTS houses (
    mls INTEGER NOT NULL PRIMARY KEY UNIQUE,
    change VARCHAR(100),
    address VARCHAR(500),
    price INTEGER,
    status VARCHAR(25),
    link VARCHAR(500),
    thumbnail VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS uploads (
    mls INTEGER NOT NULL PRIMARY KEY UNIQUE,
    address VARCHAR(500),
    price INTEGER,
    status VARCHAR(25),
    link VARCHAR(500),
    thumbnail VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS metas (
    key VARCHAR(25) NOT NULL PRIMARY KEY UNIQUE,
    value VARCHAR(100)
)

CREATE OR REPLACE FUNCTION record_change() RETURNS TRIGGER 
AS $$
    BEGIN
        IF (NEW.price <> OLD.price) THEN
            UPDATE houses SET change = 'PRICE' WHERE mls = NEW.mls;
        ELSIF (NEW.status <> OLD.status) THEN
            UPDATE houses SET change = 'STATUS' WHERE mls = NEW.mls;
        END IF;
        RETURN NULL;
    END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS record_change ON houses;

CREATE TRIGGER record_change
AFTER UPDATE OF price, status ON houses
FOR EACH ROW EXECUTE FUNCTION record_change();