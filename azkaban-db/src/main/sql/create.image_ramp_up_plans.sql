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

-- TODO: create index if not exists is not supported. Hence, current Azkaban codebase throws
--  duplicate index exception during build. This to be addressed separately. Commenting it for now.
--  One option is to move each table create scripts to separate file. But all the  containerization
--  tables are placed in this file so that it easier to manage.

CREATE INDEX image_rampup_plan_type_id
  ON image_rampup_plan (type_id);

CREATE INDEX image_rampup_plan_active
  ON image_rampup_plan (active);