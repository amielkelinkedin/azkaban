-- Definition for image_versions table. This table is used for storing versions of an image type
CREATE TABLE IF NOT EXISTS image_versions (
                                              id               INT             NOT NULL PRIMARY KEY AUTO_INCREMENT,
                                              path             VARCHAR(1024)   NOT NULL,
    description      VARCHAR(2048),
    version          VARCHAR(64)     NOT NULL,
    type_id          INT NOT NULL,   FOREIGN KEY(type_id) references image_types (id),
    state            VARCHAR(64)     NOT NULL,
    release_tag      VARCHAR(64)     NOT NULL,
    created_on       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by       VARCHAR(64)     NOT NULL,
    modified_on      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by      VARCHAR(64)     NOT NULL,
    UNIQUE (type_id, version)
    );

CREATE INDEX image_versions_type_id
  ON image_versions (type_id);