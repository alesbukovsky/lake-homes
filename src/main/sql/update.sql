DELETE FROM homes WHERE UPPER(change) = 'REMOVED';

UPDATE homes 
SET change = 'REMOVED' 
WHERE mls NOT IN (SELECT mls FROM uploads);

INSERT INTO homes (mls, state, address, price, status, change, link, thumbnail) (
    SELECT mls, state, address, price, status, 'NEW', link, thumbnail FROM uploads
) ON CONFLICT (mls) DO UPDATE SET
    state = EXCLUDED.state,
    price = EXCLUDED.price,
    status = EXCLUDED.status,
    change = NULL
;