--创建表空间
CREATE TABLESPACE "REMS" 
DATAFILE 'REMS.DAT' SIZE 10M 
AUTOEXTEND 
ON NEXT 1M MAXSIZE UNLIMITED; 

--创建用户
CREATE USER "REMS" PROFILE "DEFAULT" 
IDENTIFIED BY "123" DEFAULT TABLESPACE "REMS" 
TEMPORARY TABLESPACE "TEMP" 
ACCOUNT UNLOCK;

--授权
GRANT "CONNECT" TO "REMS";

GRANT "RESOURCE" TO "REMS";

GRANT "DBA" TO "REMS";

--创建日志序列
CREATE SEQUENCE "REMS"."SEQ_LOG4J";

--创建日志表
CREATE TABLE "REMS"."TB_LOG4J" 
(	
"ID" NUMBER(19), 
"TIME" VARCHAR2(50), 
"LOGGER" VARCHAR2(50), 
"LEVEL" VARCHAR2(50), 
"MSG" VARCHAR2(500), 
"SOURCE" VARCHAR2(50), 
PRIMARY KEY ("ID")
);

--创建区域配置表
CREATE TABLE "REMS"."CFG_AREA" 
(	
"ID" NUMBER(10) NOT NULL, 
"NAME" VARCHAR2(50) NOT NULL, 
"TYPE" NUMBER(1) DEFAULT 0,  
"ENABLE" NUMBER(1) DEFAULT 1,
"PARENT_ID" NUMBER(10), 
PRIMARY KEY ("ID")
);
COMMENT ON TABLE "REMS"."CFG_AREA" IS '区域配置'; 
COMMENT ON COLUMN "REMS"."CFG_AREA"."ID" IS '编号';
COMMENT ON COLUMN "REMS"."CFG_AREA"."NAME" IS '名称';
COMMENT ON COLUMN "REMS"."CFG_AREA"."TYPE" IS '类型（0：省、自治区、直辖市；1：城市；2：区、县、市）';
COMMENT ON COLUMN "REMS"."CFG_AREA"."ENABLE" IS '启用符（1：启用；0：停用）';
COMMENT ON COLUMN "REMS"."CFG_AREA"."PARENT_ID" IS '父编号';

--创建数据配置表
CREATE TABLE "REMS"."CFG_DATA" 
(	
"ID" NUMBER(10) NOT NULL, 
"NAME" VARCHAR2(50) NOT NULL, 
"TYPE" NUMBER(3) NOT NULL, 
"ENABLE" NUMBER(1) DEFAULT 1, 
PRIMARY KEY ("ID")
);
COMMENT ON TABLE "REMS"."CFG_DATA" IS '数据配置';
COMMENT ON COLUMN "REMS"."CFG_DATA"."ID" IS '编号';
COMMENT ON COLUMN "REMS"."CFG_DATA"."NAME" IS '名称';
COMMENT ON COLUMN "REMS"."CFG_DATA"."TYPE" IS '类型（1：产权性质；2：朝向；3：物业类型；4：住宅类别；5：建筑类别；6：房屋结构；7：装修程度；8：看房时间；9：配套设施；10：房源特色；11：建筑年代；12：合租方式；13：合租人性别要求；14：支付方式；15：入住时间；16：房屋配套）';
COMMENT ON COLUMN "REMS"."CFG_DATA"."ENABLE" IS '启用符（1：启用；0：停用）';

--创建房屋序列
CREATE SEQUENCE "REMS"."SEQ_HOUSE";

--创建房屋表
CREATE TABLE "REMS"."TB_HOUSE" 
(	
"ID" NUMBER(19) NOT NULL, 
"NAME" VARCHAR2(50) NOT NULL, 
"PROVINCE_ID" NUMBER(10) NOT NULL, 
"CITY_ID" NUMBER(10) NOT NULL, 
"DISTRICT_ID" NUMBER(10) NOT NULL, 
"ADDRESS" VARCHAR2(100) NOT NULL, 
"BEDROOM_COUNT" NUMBER(2) NOT NULL, 
"LIVING_ROOM_COUNT" NUMBER(2) NOT NULL, 
"KITCHEN_COUNT" NUMBER(2) NOT NULL, 
"WASHROOM_COUNT" NUMBER(2) NOT NULL, 
"BALCONY_COUNT" NUMBER(2) NOT NULL, 
"PROP_MGT_TYPE_ID" NUMBER(10), 
"DIRECTION_ID" NUMBER(10), 
"DECORATION_ID" NUMBER(10), 
"TOTAL_FLOOR" NUMBER(3), 
"FLOOR" NUMBER(3), 
"CONSTRUCT_YEAR_ID" NUMBER(10), 
"TRANSPORT" VARCHAR2(500), 
"ENVIRONMENT" VARCHAR2(500), 
"REMARK" VARCHAR2(500), 
"RENT_HOUSE_ID" NUMBER(19),
"SECOND_HAND_HOUSE_ID" NUMBER(19),
PRIMARY KEY ("ID")
);
COMMENT ON TABLE "REMS"."TB_HOUSE" IS '房屋';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."ID" IS '编号';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."NAME" IS '楼盘名称';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."PROVINCE_ID" IS '省、自治区、直辖市编号（对应区域配置表类型0）';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."CITY_ID" IS '城市编号（对应区域配置表类型1）';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."DISTRICT_ID" IS '区、县、市编号（对应区域配置表类型2）';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."ADDRESS" IS '详细地址';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."BEDROOM_COUNT" IS '室';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."LIVING_ROOM_COUNT" IS '厅';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."KITCHEN_COUNT" IS '厨';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."WASHROOM_COUNT" IS '卫';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."BALCONY_COUNT" IS '阳台';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."PROP_MGT_TYPE_ID" IS '物业类型编号（对应数据配置表类型3）';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."DIRECTION_ID" IS '朝向编号（对应数据配置表类型2）';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."DECORATION_ID" IS '装修程度编号（对应数据配置表类型7）';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."TOTAL_FLOOR" IS '总楼层';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."FLOOR" IS '所在楼层';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."CONSTRUCT_YEAR_ID" IS '建筑年代编号（对应数据配置表类型11）';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."TRANSPORT" IS '交通状况';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."ENVIRONMENT" IS '周边配套';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."REMARK" IS '房源描述';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."RENT_HOUSE_ID" IS '出租房编号';
COMMENT ON COLUMN "REMS"."TB_HOUSE"."SECOND_HAND_HOUSE_ID" IS '二手房编号';
   
--创建出租房序列
CREATE SEQUENCE "REMS"."SEQ_RENT_HOUSE";
   
--创建出租房表
CREATE TABLE "REMS"."TB_RENT_HOUSE" 
(	
"ID" NUMBER(19) NOT NULL, 
"PRICE" NUMBER(7,2), 
"AREA" NUMBER(7,2), 
"TYPE" NUMBER(1) DEFAULT 0, 
"SHARE_TYPE_ID" NUMBER(10), 
"ROOMMATE_GENDER_ID" NUMBER(10), 
"PAYMENT_ID" NUMBER(10), 
"CHECK_IN_ID" NUMBER(10), 
PRIMARY KEY ("ID")
);
COMMENT ON TABLE "REMS"."TB_RENT_HOUSE" IS '出租房';
COMMENT ON COLUMN "REMS"."TB_RENT_HOUSE"."ID" IS '编号';
COMMENT ON COLUMN "REMS"."TB_RENT_HOUSE"."PRICE" IS '租金';
COMMENT ON COLUMN "REMS"."TB_RENT_HOUSE"."AREA" IS '出租面积';
COMMENT ON COLUMN "REMS"."TB_RENT_HOUSE"."TYPE" IS '租赁方式（0：整租；1：合租）';
COMMENT ON COLUMN "REMS"."TB_RENT_HOUSE"."SHARE_TYPE_ID" IS '合租方式编号（对应数据配置表类型12）';
COMMENT ON COLUMN "REMS"."TB_RENT_HOUSE"."ROOMMATE_GENDER_ID" IS '合租人性别要求编号（对应数据配置表类型13）';
COMMENT ON COLUMN "REMS"."TB_RENT_HOUSE"."PAYMENT_ID" IS '支付方式编号（对应数据配置表类型14）';
COMMENT ON COLUMN "REMS"."TB_RENT_HOUSE"."CHECK_IN_ID" IS '入住时间编号（对应数据配置表类型15）';

--创建二手房序列
CREATE SEQUENCE "REMS"."SEQ_SECOND_HAND_HOUSE";

--创建二手房表
CREATE TABLE "REMS"."TB_SECOND_HAND_HOUSE" 
(	
"ID" NUMBER(19) NOT NULL, 
"PRICE" NUMBER(7,2), 
"BUILDING_AREA" NUMBER(7,2), 
"USABLE_AREA" NUMBER(7,2), 
"PROPETY_ID" NUMBER(10), 
"PROP_TYPE_ID" NUMBER(10), 
"PROP_STRUCT_ID" NUMBER(10), 
"CONSTRUCT_TYPE_ID" NUMBER(10), 
"VISIT_TIME_ID" NUMBER(10), 
PRIMARY KEY ("ID")
);
COMMENT ON TABLE "REMS"."TB_SECOND_HAND_HOUSE" IS '二手房';
COMMENT ON COLUMN "REMS"."TB_SECOND_HAND_HOUSE"."ID" IS '编号';
COMMENT ON COLUMN "REMS"."TB_SECOND_HAND_HOUSE"."PRICE" IS '售价';
COMMENT ON COLUMN "REMS"."TB_SECOND_HAND_HOUSE"."BUILDING_AREA" IS '建筑面积';
COMMENT ON COLUMN "REMS"."TB_SECOND_HAND_HOUSE"."USABLE_AREA" IS '使用面积';
COMMENT ON COLUMN "REMS"."TB_SECOND_HAND_HOUSE"."PROPETY_ID" IS '产权性质编号（对应数据配置表类型1）';
COMMENT ON COLUMN "REMS"."TB_SECOND_HAND_HOUSE"."PROP_TYPE_ID" IS '住宅类别编号（对应数据配置表类型4）';
COMMENT ON COLUMN "REMS"."TB_SECOND_HAND_HOUSE"."PROP_STRUCT_ID" IS '房屋结构编号（对应数据配置表类型6）';
COMMENT ON COLUMN "REMS"."TB_SECOND_HAND_HOUSE"."CONSTRUCT_TYPE_ID" IS '建筑类别编号（对应数据配置表类型5）';
COMMENT ON COLUMN "REMS"."TB_SECOND_HAND_HOUSE"."VISIT_TIME_ID" IS '看房时间编号（对应数据配置表类型8）';
