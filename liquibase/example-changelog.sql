--liquibase formatted sql

--changeset Johnny Ho:1 labels:v0.l.0 context:dev,staging,prod
--comment: Create table product_category 
create table product_category (
    id int primary key auto_increment not null,
    name varchar(50),
    desc text,
    created_at timestamp,
    modified_at timestamp,
    deleted_at timestamp
)

--changeset Johnny Ho:1 labels:v0.l.0 context:dev,staging,prod
--comment: Create table product_inventory 
create table product_inventory (
    id int primary key auto_increment not null,
    quantity int,
    created_at timestamp,
    modified_at timestamp,
    deleted_at timestamp
)

--changeset Johnny Ho:1 labels:v0.l.0 context:dev,staging,prod
--comment: Create table discount 
create table discount (
    id int primary key auto_increment not null,
    name varchar(50),
    desc text,
    discount_percent decimal,
    active boolean,
    created_at timestamp,
    modified_at timestamp,
    deleted_at timestamp
)

--changeset Johnny Ho:1 labels:v0.l.0 context:dev,staging,prod
--comment: Create table product
create table product (
    id int primary key auto_increment not null,
    desc text not null,
    SKU varchar(50),
    category_id int,
    inventory_id int,
    price decimal,
    discount_id int,
    product_code varchar(50),
    created_at timestamp,
    modified_at timestamp,
    deleted_at timestamp,
    FOREIGN KEY (category_id) REFERENCES product_category(id),
    FOREIGN KEY (inventory_id) REFERENCES product_inventory(id),
    FOREIGN KEY (discount_id) REFERENCES discount(id)
)
--rollback DROP TABLE person;

--changeset Johnny Ho:2 labels:example-label context:example-context
--comment: create table user
create table user (
    id int primary key auto_increment not null,
    username varchar(50) not null,
    password text,
    -- encrypted PII
    first_name varchar(50),
    -- encrypted PII
    last_name varchar(50),
    -- encrypted PII
    telephone varchar(50),
    created_at timestamp,
    modified_at timestamp
)
--rollback DROP TABLE user;

--changeset Johnny Ho:2 labels:example-label context:example-context
--comment: create table payment_details
create table payment_details (
    id int primary key auto_increment not null,
    order_id int,
    amount decimal,
    provider varchar,
    status varchar,
    created_at timestamp,
    modified_at timestamp
)
--rollback DROP TABLE payment_details;

--changeset Johnny Ho:2 labels:example-label context:example-context
--comment: create table order_details
create table order_details (
    id int primary key auto_increment not null,
    user_id int,
    total decimal,
    payment_id int,
    created_at timestamp,
    modified_at timestamp,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (payment_id) REFERENCES payment_details(id)
)
--rollback DROP TABLE order_details;

--changeset Johnny Ho:2 labels:example-label context:example-context
--comment: create table order_items
create table order_items (
    id int primary key auto_increment not null,
    order_id int,
    product_id int,
    quantity int,
    created_at timestamp,
    modified_at timestamp,
    FOREIGN KEY (order_id) REFERENCES order_details(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
)
--rollback DROP TABLE order_items;
