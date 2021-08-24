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

CREATE INDEX image_rampup_plan_id
  ON image_rampup (plan_id);

CREATE INDEX image_rampup_version_id
  ON image_rampup (version_id);