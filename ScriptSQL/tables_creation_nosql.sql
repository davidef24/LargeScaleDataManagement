CREATE TABLE ClubNOSQL (
    id SERIAL PRIMARY KEY,
    name text,
    stadium_name text,
    stadium_seats INT,
    country text
);

CREATE TABLE PlayerNOSQL (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    country text,
    birth DATE,
    position text,
    foot text,
    height integer,
    highest_market_value integer
);

CREATE TABLE MatchNOSQL (
    id SERIAL PRIMARY KEY,
    home_club_id INT NOT NULL,
    away_club_id INT NOT NULL,
    date text,
    international_match BOOLEAN,
    home_score INT  NOT NULL,
    away_score INT  NOT NULL
);

CREATE TABLE PlayerTakesRedCardNOSQL (
    player_id INT NOT NULL,
    match_id INT NOT NULL,
    date text
);

CREATE TABLE PlayerScoresNOSQL (
    player_id INT NOT NULL,
    match_id INT NOT NULL,
    minute text,
    penalty text
);

CREATE TABLE PlayerNominedBDNOSQL (
    player_id INT NOT NULL,
    year INT NOT NULL,
    position integer,
    club_id INT
);

CREATE TABLE PlayerAssistNOSQL (
    player_id INT NOT NULL,
    match_id INT NOT NULL,
    time text
   
);

CREATE TABLE TransferNOSQL (
    id SERIAL PRIMARY KEY,
    from_club_id INT NOT NULL,
    acquiring_club_id INT NOT NULL,
    player_id INT NOT NULL,
    cost numeric,
    date DATE
);
