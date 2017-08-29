# postgres-plus
postgres:alpine docker image modified to include additional extensions

Currently includes:
* [tds_fdw](https://github.com/tds-fdw/tds_fdw)
* [Multicorn](https://github.com/Kozea/Multicorn)

Will eventually include more

```sh
docker build -t technekes/postgres-plus . --pull
docker run --name db -e POSTGRES_DB=docker -e POSTGRES_USER=docker -e POSTGRES_PASSWORD=docker -d technekes/postgres-plus

# echo credentials into `/credentials.json`
docker exec -it db bash

echo '{
}' > /credentials.json

docker run -it --rm --link db technekes/postgres-plus psql postgresql://docker:docker@db/docker
```

```sql
CREATE EXTENSION multicorn;

CREATE SERVER multicorn_gspreadsheet FOREIGN DATA WRAPPER multicorn
OPTIONS
(
   wrapper 'gspreadsheet_fdw.GspreadsheetFdw'
);

DROP FOREIGN TABLE IF EXISTS dupont_products;

CREATE FOREIGN TABLE dupont_products
(
   manufacturer       text
  ,product_code       text
  ,product_name       text
  ,uom                text
  ,brand              text
  ,edi_status         text
  ,is_bulk_product    boolean
  ,is_precision_pak   boolean
  ,package_size       text
  ,product_family_id  text
  ,product_family     text
  ,description        text
  ,active_family      text
  ,actives            text
  ,geographies        text
  ,category           text
  ,market_category    text
  ,market_segment     text
  ,remedy             boolean
  ,last_updated_on    date
  ,brand_indicator    text
  ,price              decimal(15, 5)
  ,price_effective_on date
  ,amount_2016        decimal(12, 2)
  ,amount_2017        decimal(12, 2)
) server multicorn_gspreadsheet options(
  keyfile '/credentials.json',
  gskey '1P9E8b4QU1SGJ0s7lJ8W0j3owvqmyK1vBtmXGBDXt-vg'
);

SELECT
   brand
  ,product_code
  ,product_name
  ,remedy
  ,is_bulk_product
  ,amount_2017::money
FROM dupont_products
ORDER BY
   amount_2017 DESC
LIMIT 10
;

-- CREATE SERVER tk_prod_basf FOREIGN DATA WRAPPER multicorn
-- OPTIONS
-- (
--    wrapper 'multicorn.sqlalchemyfdw.SqlAlchemyFdw'
--   ,drivername 'mssql+pymssql'
--   ,host '10.2.50.241'
--   ,port '1433'
--   ,database 'basf_bdw'
-- )
-- ;
--
-- CREATE USER MAPPING FOR docker SERVER tk_prod_basf
-- OPTIONS
-- (
--    username 'tds_fdw'
--   ,password 'rnqeF2JYivAPVDGu'
-- )
-- ;
```
