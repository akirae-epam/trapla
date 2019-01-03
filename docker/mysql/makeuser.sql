CREATE DATABASE trapla_development;
CREATE DATABASE trapla_test;
CREATE DATABASE trapla_production;

CREATE USER 'user_develop'@'%' IDENTIFIED BY 'PassDevelop0-';
GRANT ALL PRIVILEGES ON trapla_development.* TO 'user_develop'@'%';

CREATE USER 'trapla_test'@'%' IDENTIFIED BY 'PassTest0-';
GRANT ALL PRIVILEGES ON trapla_test.* TO 'user_test'@'%';

CREATE USER 'trapla_production'@'%' IDENTIFIED BY 'PassProduction0-';
GRANT ALL PRIVILEGES ON trapla_production.* TO 'user_production'@'%';
