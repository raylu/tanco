-- sqlite schema for rogo (both client and server)

create table meta (
    key text primary key,
    val text);

insert into meta values ('schema_version', '1.0');


create table servers (
    id integer primary key,
    url text not null unique,
    name text not null,
    info text not null);

insert into servers (url, name, info) values
  ('https://rogo.tangentcode.com/', 'tangentcode',
   'The original rogo server at tangentcode.com');


create table users (
    id integer primary key,
    sid integer not null references servers,
    authid text, -- references external authentication provider (firebase)
    username text not null);


create table tokens (
    id integer primary key,
    uid integer not null references users,
    jwt text not null,
    ts integer not null );


create table challenges (
    id integer primary key,
    sid  integer not null references servers,
    name  text,
    title text,
    unique (sid, name));


create table attempts (
    id integer primary key,
    uid integer not null references users,
    chid integer not null references challenges,
    ts integer not null,
    hash text unique,
    done integer,
    is_private integer,
    state text,
    lang text,
    repo text);


create table progress (
    id integer primary key,
    aid integer not null references attempts,
    tid integer not null references tests,
    ts integer not null,
    vcs_ref text);


create table tests (
    id integer primary key,
    chid integer not null references challenges,
    name text not null,
    head text not null,
    body text not null,
    ilines text not null,
    olines integer not null);