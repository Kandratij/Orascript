CREATE TABLE prices
( 
 ticker VARCHAR2(3), -- валюта сокращ
 pdate DATE, -- дата 
 price FLOAT -- курс валюты
);

INSERT INTO prices( ticker, pdate, price) VALUES ('usd', DATE'2016-10-22', 55.11);
INSERT INTO prices( ticker, pdate, price) VALUES ('usd', DATE'2016-10-22', 56.11);
INSERT INTO prices( ticker, pdate, price) VALUES ('usd', DATE'2016-10-25', 57.11);
INSERT INTO prices( ticker, pdate, price) VALUES ('usd', DATE'2016-10-25', 57.22);
INSERT INTO prices( ticker, pdate, price) VALUES ('usd', DATE'2016-10-27', 58.11);
INSERT INTO prices( ticker, pdate, price) VALUES ('usd', DATE'2016-11-29', 57.11);

INSERT INTO prices( ticker, pdate, price) VALUES ('eur', DATE'2016-11-22', 65.11);
INSERT INTO prices( ticker, pdate, price) VALUES ('eur', DATE'2016-11-22', 65.12);
INSERT INTO prices( ticker, pdate, price) VALUES ('eur', DATE'2016-11-25', 67.11);
INSERT INTO prices( ticker, pdate, price) VALUES ('eur', DATE'2016-11-27', 68.11);

INSERT INTO prices( ticker, pdate, price) VALUES ('chf', DATE'2016-11-22', 88.11);
INSERT INTO prices( ticker, pdate, price) VALUES ('chf', DATE'2016-11-25', 88.33);
INSERT INTO prices( ticker, pdate, price) VALUES ('chf', DATE'2016-11-25', 89.33);
COMMIT;

SELECT DISTINCT ticker
, (SELECT MIN(price) FROM prices p1 WHERE p1.pdate  = 
    (SELECT MIN(p3.pdate) FROM prices p3 WHERE p3.ticker = P.ticker) AND p1.ticker = P.ticker) minfirstprice
, (SELECT MAX(price) FROM prices p2 WHERE p2.pdate = 
    (SELECT MAX(p3.pdate) FROM prices p3 WHERE p3.ticker = P.ticker) AND p2.ticker = P.ticker) maxlastprice
FROM prices P ; 
-- минимальное и максимальное значение курса за наибольшую дату
-- получилось довольно сложно и громоздко, но результат правильный

-- а теперь используем KEEP FIRST, KEEP LAST, посмотрите, насколько улучшился наш запрос
SELECT 
  ticker,
  min(price) KEEP (DENSE_RANK FIRST ORDER BY pdate) as minfirstprice,
  max(price) KEEP (DENSE_RANK FIRST ORDER BY pdate) as maxfirstprice,
  min(price) KEEP (DENSE_RANK LAST ORDER BY pdate) as minlastprice,
  max(price) KEEP (DENSE_RANK LAST ORDER BY pdate) as maxlastprice,
  sum(price) KEEP (DENSE_RANK FIRST ORDER BY pdate) as sumfirstprice,
  sum(price) KEEP (DENSE_RANK LAST ORDER BY pdate) as sumlastprice
FROM prices
GROUP BY ticker
ORDER BY ticker;

-- и еще плюс , использование KEEP FIRST LAST вместе с аналитической функцией
SELECT
  ticker,
  price,
  min(price) KEEP (DENSE_RANK FIRST ORDER BY pdate) OVER (PARTITION BY ticker) minfirstprice,
  mAX(price) KEEP (DENSE_RANK FIRST ORDER BY pdate) OVER (PARTITION BY ticker) mAXfirstprice,    
  max(price) KEEP (DENSE_RANK LAST ORDER BY pdate) OVER (PARTITION BY ticker) minlasttprice,
  mIN(price) KEEP (DENSE_RANK LAST ORDER BY pdate) OVER (PARTITION BY ticker) maxlastprice
FROM prices
ORDER BY PRICE;
