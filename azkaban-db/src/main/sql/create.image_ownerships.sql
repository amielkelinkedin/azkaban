-- Definition for image_ownerships table. This table is used for storing ownership information for
-- an image type
CREATE TABLE IF NOT EXISTS image_ownerships (
                                                id               INT             NOT NULL PRIMARY KEY AUTO_INCREMENT,
                                                type_id          INT NOT NULL,   FOREIGN KEY(type_id) references image_types (id),
    owner            VARCHAR(64)     NOT NULL,
    role             VARCHAR(64)     NOT NULL,
    created_on       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by       VARCHAR(64)     NOT NULL,
    modified_on      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by      VARCHAR(64)     NOT NULL
    );

CREATE INDEX image_ownerships_type_id
  ON image_ownerships (type_id);