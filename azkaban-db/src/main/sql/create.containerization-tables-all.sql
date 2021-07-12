-- Stored Procedure for Creating Indexes to assure proper local boot
DROP PROCEDURE IF EXISTS CreateIndex;
CREATE PROCEDURE CreateIndex
(
    given_table     VARCHAR(64),
    given_index     VARCHAR(64),
    given_columns   VARCHAR(64)
)
BEGIN
    DECLARE IndexExists INTEGER;

    SELECT COUNT(1) INTO IndexExists
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE table_name = given_table
    AND index_name = given_index;

    IF IndexExists = 0 THEN
    SET @createIndex = CONCAT('CREATE INDEX ',given_index,' ON',
    given_table,' (', given_column, ')';
    PREPARE ex FROM @createIndex;
    EXECUTE ex;
    DEALLOCATE PREPARE ex;

    END IF;
END ;

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

-- CREATE INDEX image_types_name ON image_types (name);
EXEC CreateIndex  @given_index = 'image_types_name',
    @given_table = 'image_types', @given_column = 'name';



-- CREATE INDEX image_types_active ON image_types (active);
EXEC CreateIndex  @given_index = 'image_types_active',
    @given_table = 'image_types', @given_column = 'active';

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

-- CREATE INDEX image_versions_type_id ON image_versions (type_id);
EXEC CreateIndex @given_index = 'image_versions_type_id',
    @given_table = 'image_versions', @given_column = 'type_id';

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

-- CREATE INDEX image_ownerships_type_id ON image_ownerships (type_id);
EXEC CreateIndex @given_index = 'image_ownerships_type_id',
    @given_table = 'image_ownerships', @given_column = 'type_id';

-- Definition for image_rampup_plan table. This table is used for creating rampup plan for an
-- image type. Only one ramp up plan will be active at a time.
CREATE TABLE IF NOT EXISTS image_rampup_plan (
  id               INT             NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name             VARCHAR(1024)   NOT NULL,
  description      VARCHAR(2048),
  type_id          INT NOT NULL,   FOREIGN KEY(type_id) references image_types (id),
  active           BOOLEAN         NOT NULL,
  created_on       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by       VARCHAR(64)     NOT NULL,
  modified_on      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified_by      VARCHAR(64)     NOT NULL
);

-- CREATE INDEX image_rampup_plan_type_id ON image_rampup_plan (type_id);
EXEC CreateIndex @given_index = 'image_rampup_plan_type_id',
    @given_table = 'image_rampup_plan', @given_column = 'type_id';

-- CREATE INDEX image_rampup_plan_active ON image_rampup_plan (active);
EXEC CreateIndex @given_index = 'image_rampup_plan_active',
    @given_table = 'image_rampup_plan', @given_column = 'active';

-- Definition for image_rampup table. This table contains information of the image versions being
-- ramped up for an image type
CREATE TABLE IF NOT EXISTS image_rampup (
  id                INT            NOT NULL PRIMARY KEY AUTO_INCREMENT,
  plan_id           INT            NOT NULL, FOREIGN KEY(plan_id) references image_rampup_plan (id),
  version_id        INT            NOT NULL, FOREIGN KEY(version_id) references image_versions (id),
  rampup_percentage INT            NOT NULL DEFAULT 0,
  stability_tag     VARCHAR(64)    NOT NULL,
  created_on        TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by        VARCHAR(64)    NOT NULL,
  modified_on       TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified_by       VARCHAR(64)    NOT NULL
);

-- CREATE INDEX image_rampup_plan_id ON image_rampup (plan_id);
EXEC CreateIndex @given_database = @DB_NAME,  @given_index = 'image_rampup_plan_id',
    @given_table = 'image_rampup', @given_column = 'plan_id';

-- CREATE INDEX image_rampup_version_id ON image_rampup (version_id);
EXEC CreateIndex @given_database = @DB_NAME,  @given_index = 'image_rampup_plan_id',
    @given_table = 'image_rampup', @given_column = 'version_id';

-- Definition for version_set table. Version set contains set of image versions and will be
-- used during flow container launch
CREATE TABLE IF NOT EXISTS version_set (
     id  INT NOT NULL AUTO_INCREMENT,
     md5  CHAR(32) NOT NULL,
     json VARCHAR(4096) NOT NULL,
     created_on datetime DEFAULT CURRENT_TIMESTAMP,
     PRIMARY KEY (id)
);

CREATE UNIQUE INDEX version_set_md5
 ON version_set (md5);

-- TODO: Add the alter table script in the specific release
-- Adding version_set_id column in execution_flows
-- alter table execution_flows add column version_set_id INT default null;

-- TODO: Add the alter table script in the specific release
-- Adding dispatch_method column in execution_flows
-- alter table execution_flows add column dispatch_method TINYINT default 1;
-- CREATE INDEX ex_flows_dispatch_method ON execution_flows (dispatch_method);

