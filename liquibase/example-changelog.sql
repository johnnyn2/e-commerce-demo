--liquibase formatted sql

--changeset Johnny Ho:1 labels:v0.l.0 context:dev,staging,prod
--comment: Create table product
create table product (
    id int primary key auto_increment not null,
    description text not null,
    SKU varchar(50),
    category_id int,
    inventory_id int,
    price decimal,
    discount_id int,
    created_at timestamp,
    modified_at timestamp,
    deleted_at timestamp,
    FOREIGN KEY (category_id) REFERENCES product_category(id),
    FOREIGN KEY (inventory_id) REFERENCES product_inventory(id),
    FOREIGN KEY (discount_id) REFERENCES discount(id)
)
--rollback DROP TABLE person;

--changeset Johnny Ho:2 labels:example-label context:example-context
--comment: example comment
create table company (
    id int primary key auto_increment not null,
    name varchar(50) not null,
    address1 varchar(50),
    address2 varchar(50),
    city varchar(30)
)
--rollback DROP TABLE company;

--changeset other.dev:3 labels:example-label context:example-context
--comment: example comment
alter table person add column country varchar(2)
--rollback ALTER TABLE person DROP COLUMN country;

