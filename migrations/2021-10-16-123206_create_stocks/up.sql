CREATE TABLE stocks (
  code integer NOT NULL,
  datetime timestamp NOT NULL,
  volume integer NOT NULL,
  price decimal NOT NULL,
  PRIMARY KEY (code, datetime)
)