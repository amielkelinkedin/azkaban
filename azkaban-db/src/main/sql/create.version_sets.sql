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