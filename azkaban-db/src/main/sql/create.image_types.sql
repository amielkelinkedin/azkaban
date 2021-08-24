-- Definition for image_types table. This table is used for storing different image types
CREATE TABLE IF NOT EXISTS image_types (
                                           id               INT             NOT NULL PRIMARY KEY AUTO_INCREMENT,
                                           name             VARCHAR(64)     NOT NULL UNIQUE,
    description      VARCHAR(2048),
    active           BOOLEAN,
    deployable       VARCHAR(64),
    created_on       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by       VARCHAR(64)     NOT NULL,
    modified_on      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by      VARCHAR(64)     NOT NULL
    );

CREATE INDEX image_types_name
  ON image_types (name);

CREATE INDEX image_types_active
  ON image_types (active);
